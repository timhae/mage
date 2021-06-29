#!/usr/bin/env bash

./clean_dbs.sh
mvn clean install -DskipTests=true -Dmaven.javadoc.skip=true
