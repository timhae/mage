#!/usr/bin/env nix-shell
#!nix-shell -i bash -p maven openjdk11 protobuf

mvn assembly:assembly
scp target/mage-server.zip autarch@bernardi.uberspace.de:/home/autarch/mage-server_no_backup/
