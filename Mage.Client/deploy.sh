#!/usr/bin/env bash

mvn assembly:assembly
scp target/mage-client.zip tim@netcup:/var/www/haering.dev/
