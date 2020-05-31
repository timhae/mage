#!/bin/sh

java -Xms256m -Xmx1g -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -jar ./lib/mage-client-${project.version}.jar &
