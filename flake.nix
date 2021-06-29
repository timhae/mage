{
  description = "XMage Server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
  };

  outputs = { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
          config.allowUnfree = true;
          enableJavaFX = true;
        };
      in rec {
        devShell =
          pkgs.mkShell { buildInputs = with pkgs; [ maven protobuf jdk11 ]; };

        defaultPackage = with pkgs;
          stdenv.mkDerivation rec {
            name = "mage-server";
            version = "1.4.50";
            subversion = "V2";

            src = fetchurl {
              url = "https://haering.dev/mage-server.zip";
              sha256 = "cbp9regDqPN4y2rTIQculL70v5O3vaX/iEAulL3BBrc=";
            };

            preferLocalBuild = true;

            unpackPhase = ''
              ${unzip}/bin/unzip ${src}
            '';

            installPhase = ''
              mkdir -p $out/bin $out/extension $out/plugins
              cp -rv ./* $out

              cat << EOF > $out/bin/xmage_server
              #!/usr/bin/env bash
              exec ${jdk11}/bin/java -Xms1g -Xmx4g \
              -Dfile.encoding=UTF-8 \
              -Djava.security.policy=$out/config/security.policy \
              -Dlog4j.configuration=file:$out/config/log4j.properties \
              -Dconfig-path=$out/config/config.xml \
              -Dplugin-path=$out/plugins/ \
              -Dextension-path=$out/extension/ \
              -Dmessage-path=$out/ \
              -jar $out/lib/${name}-${version}.jar
              echo "start xmage server"
              EOF

              chmod +x $out/bin/xmage_server
            '';
          };
      });
}
