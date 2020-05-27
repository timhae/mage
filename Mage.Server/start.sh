#!/usr/bin/env nix-shell
#!nix-shell -i bash -p maven openjdk11

mvn exec:java -Dexec.mainClass="mage.server.Main" -Dexec.args="-testMode=true"
