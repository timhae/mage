#!/usr/bin/env bash

mvn assembly:assembly
scp target/mage-server.zip "tim@server:/var/www/haering.dev/xmage/mage-server-$(date "+%Y-%m-%d").zip"
