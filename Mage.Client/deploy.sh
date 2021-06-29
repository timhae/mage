#!/usr/bin/env bash

mvn assembly:assembly
scp target/mage-client.zip "tim@server:/var/www/haering.dev/xmage/mage-client-$(date "+%Y-%m-%d").zip"
