#!/usr/bin/env nix-shell
#!nix-shell -i bash -p maven openjdk11 protobuf

./clean_dbs.sh
pushd Mage.Client
./deploy.sh
popd
pushd Mage.Server
./deploy.sh
