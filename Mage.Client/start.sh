#!/usr/bin/env nix-shell
#!nix-shell -i bash -p maven openjdk11

mvn exec:java -Dexec.mainClass="mage.client.MageFrame"
