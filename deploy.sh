#!/usr/bin/env nix-shell
#!nix-shell -i bash -p maven openjdk11 protobuf

./clean_dbs.sh
./Mage.Client/deploy.sh
./Mage.Server/deploy.sh
