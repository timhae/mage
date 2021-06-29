#!/bin/sh

java -Xms256M -Xmx2G -Dfile.encoding=UTF-8 -jar ./lib/mage-client-${project.version}.jar &
