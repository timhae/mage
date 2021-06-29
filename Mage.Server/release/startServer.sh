#!/bin/sh

java -Xms256M -Xmx2G -Dfile.encoding=UTF-8 -Djava.security.policy=./config/security.policy -Dlog4j.configuration=file:./config/log4j.properties -Dconfig-path=./config/config.xml -Dplugin-path=./plugins/ -Dextension-path=./extension/ -Dmessage-path=./ -jar ./lib/mage-server-${project.version}.jar
