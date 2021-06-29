{
  description = "X Mage";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; };
  outputs = { self, nixpkgs }:
    let
      version = "2023-06-30";
      lastModifiedDate =
        self.lastModifiedDate or self.lastModified or "19700101";
      supportedSystems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          enableJavaFX = true;
          overlays = with self; [ overlay-server ];
        });
    in
    {
      overlay-server = final: prev: rec {
        mage-server = with final; final.callPackage
          ({ inShell ? false }: stdenv.mkDerivation rec {
            inherit version;
            src =
              if inShell then
                null
              else
                fetchzip {
                  stripRoot = false;
                  url = "http://haering.dev/xmage/mage-server-${version}.zip";
                  sha256 = "sha256-B88I4D0g8aIAE8tw+BygpQ2U6yULWCT8/2T9jJ1tx+U=";
                };
            pname = "mage-server";
            buildInputs = if inShell then [ jdk11 maven protobuf ] else [ ];
            installPhase = ''
              mkdir -p $out/bin $out/extension $out/plugins
              cp -rv ./* $out

              cat << EOF > $out/bin/mage-server
              #!/usr/bin/env bash
              exec ${pkgs.jdk11}/bin/java -Xms1g -Xmx4g \
                -Dfile.encoding=UTF-8 \
                -Djava.security.policy=$out/config/security.policy \
                -Dlog4j.configuration=file:$out/config/log4j.properties \
                -Dconfig-path=$out/config/config.xml \
                -Dplugin-path=$out/plugins/ \
                -Dextension-path=$out/extension/ \
                -Dmessage-path=$out/ \
                -jar $out/lib/${pname}-1.4.50.jar
              EOF

              chmod +x $out/bin/mage-server
            '';
          })
          { };
      };
      packages =
        forAllSystems (system: { inherit (nixpkgsFor.${system}) mage-server; });
      defaultPackage =
        forAllSystems (system: self.packages.${system}.mage-server);
      devShell = forAllSystems (system:
        self.packages.${system}.mage-server.override { inShell = true; });
      nixosModules = { mage-server = self.nixosModule; };
      nixosModule = { config, lib, pkgs, ... }:
        let cfg = config.services.mage-server;
        in with lib; {
          options.services.mage-server.enable = mkEnableOption "enable the x mage server";
          config = mkIf cfg.enable {
            systemd.services.mage-server = {
              wantedBy = [ "multi-user.target" ];
              after = [ "network-online.target" ];
              description = "X mage server";
              serviceConfig = {
                Type = "simple";
                ExecStart =
                  "${self.packages.x86_64-linux.mage-server}/bin/mage-server";
                WorkingDirectory = "/var/lib/mage-server";
                StateDirectory = "mage-server";
                DynamicUser = true;
              };
            };
            networking.firewall = {
              allowedTCPPorts = [ 17171 17172 ];
              allowedUDPPorts = [ 17171 17172 ];
            };
          };
        };
    };
}
