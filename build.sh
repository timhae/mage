#!/usr/bin/env bash

./clean_dbs.sh
mvn install -DskipTests=true -Dmaven.javadoc.skip=true
