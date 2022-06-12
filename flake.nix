{
  description = "X Mage Server";
  inputs = { nixpkgs.url = "path:/home/tim/repos/nixpkgs"; };
  # inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05"; };
  outputs = { self, nixpkgs }:
    let
      version = "1.4.50";
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
      src = ./.;
      # src = fetchFromGitHub {
      #   owner = "timhae";
      #   repo = "mage";
      #   rev = "release";
      #   sha256 = "orniqOCtV4zHXfLnjywSAkhaaQJV4jfI8nm7ldqJZXs=";
      # };
      mvnParameters = "-Dmaven.javadoc.skip=true -DskipTests=true";
    in {
      overlay-server = final: prev: {
        mage-server = with final;
          (javaPackages.mavenfod.override {
            maven = maven.override { jdk = jdk11; };
          }) rec {
            inherit version src mvnParameters;
            pname = "mage-server";
            buildInputs = [ maven protobuf jdk11 ];
            mvnSha256 = "SFvcmxyNgJ/J8hi8ozYwzHNpqVeoc7wE/8Giroaglvc=";
            postBuild = ''
              cd ./Mage.Server
              mvn assembly:assembly --offline "-Dmaven.repo.local=$mvnDeps/.m2" ${mvnParameters}
              ${unzip}/bin/unzip ./target/mage-server.zip -d $out
              mkdir -p $out/bin
              touch $out/bin/run
            '';
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
              -jar $out/lib/${pname}-${version}.jar
              EOF

              chmod +x $out/bin/mage-server
            '';
          };
      };
      packages =
        forAllSystems (system: { inherit (nixpkgsFor.${system}) mage-server; });
      defaultPackage =
        forAllSystems (system: self.packages.${system}.mage-server);
      devShell = forAllSystems (system: self.packages.${system}.mage-server);

      # A NixOS module, if applicable (e.g. if the package provides a system service).
      # nixosModules.mage-server = { pkgs, ... }: {
      #   nixpkgs.overlays = [ self.overlay ];
      #   environment.systemPackages = [ pkgs.mage-server ];
      #   #systemd.services = { ... };
      # };
      # Tests run by 'nix flake check' and by Hydra.
      # checks = forAllSystems (system:
      #   with nixpkgsFor.${system};
      #   {
      #     inherit (self.packages.${system}) hello;
      #     # Additional tests, if applicable.
      #     test = stdenv.mkDerivation {
      #       name = "hello-test-${version}";
      #       buildInputs = [ hello ];
      #       unpackPhase = "true";
      #       buildPhase = ''
      #         echo 'running some integration tests'
      #         [[ $(hello) = 'Hello Nixers!' ]]
      #       '';
      #       installPhase = "mkdir -p $out";
      #     };
      #   }
      #   // lib.optionalAttrs stdenv.isLinux {
      #     # A VM test of the NixOS module.
      #     vmTest = with import (nixpkgs + "/nixos/lib/testing-python.nix") {
      #       inherit system;
      #     };
      #       makeTest {
      #         nodes = {
      #           client = { ... }: { imports = [ self.nixosModules.hello ]; };
      #         };
      #         testScript = ''
      #           start_all()
      #           client.wait_for_unit("multi-user.target")
      #           client.succeed("hello")
      #         '';
      #       };
      #   });
    };
}

# buildPhase = ''
#   mkdir -p $out/bin
#   touch $out/bin/run
#   java --version >> $out/bin/run
#   echo "---" >> $out/bin/run
#   mvn -version >> $out/bin/run
#   echo "---" >> $out/bin/run
#   cat << EOF > $out/bin/test.java
#     import javafx.application.Application;
#     import javafx.scene.Scene;
#     import javafx.scene.control.Alert;
#     import javafx.scene.control.Alert.AlertType;
#     import javafx.scene.control.Button;
#     import javafx.scene.layout.StackPane;
#     import javafx.stage.Stage;

#     class HelloWorld {
#       public static void main(String[] args) {
#           System.out.println("JavaFX Version: " + System.getProperty("javafx.version"));
#           System.out.println("JavaFX Runtime Version: " + System.getProperty("javafx.runtime.version"));
#       }
#     }
#   EOF
#   java $out/bin/test.java >> $out/bin/run
# '';
