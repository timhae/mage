#!/usr/bin/env nix-shell
#!nix-shell -i bash -p maven openjdk11 protobuf

mvn install -DskipTests=true -Dmaven.javadoc.skip=true
