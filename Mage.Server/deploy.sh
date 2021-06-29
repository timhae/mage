#!/usr/bin/env bash

mvn assembly:assembly
scp target/mage-server.zip tim@netcup:/var/www/haering.dev
