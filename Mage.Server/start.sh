#!/usr/bin/env bash

./build.sh && mvn exec:java -Dexec.mainClass="mage.server.Main" -Dexec.args="-testMode=true" -Dconfig-path=./config/config.xml -Dplugin-path=./plugins/ -Dextension-path=./extension/ -Dmessage-path=./
