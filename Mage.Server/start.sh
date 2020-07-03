#!/usr/bin/env nix-shell
#!nix-shell -i bash -p maven openjdk11 protobuf

mvn exec:java -Dexec.mainClass="mage.server.Main" -Dexec.args="-testMode=true"
