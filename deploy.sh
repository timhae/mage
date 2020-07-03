#!/usr/bin/env nix-shell
#!nix-shell -i bash -p maven openjdk11 protobuf

pushd .
pushd Mage.Client
mvn assembly:assembly
pushd target
scp mage-client.zip autarch@bernardi.uberspace.de:/home/autarch/html/
popd
popd
pushd Mage.Server
mvn assembly:assembly
pushd target
scp mage-server.zip autarch@bernardi.uberspace.de:/home/autarch/mage-server_no_backup/
popd
popd
