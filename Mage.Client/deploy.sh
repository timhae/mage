#!/usr/bin/env nix-shell
#!nix-shell -i bash -p maven openjdk11 protobuf

mvn assembly:assembly
scp target/mage-client.zip root@hetzner1:/var/www/haering.dev/
