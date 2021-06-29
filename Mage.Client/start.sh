#!/usr/bin/env bash

./build.sh && mvn exec:java -Dexec.mainClass="mage.client.MageFrame"
