#!/usr/bin/env bash

./build.sh
pushd Mage.Server || exit
./build.sh
./deploy.sh
popd || exit
pushd Mage.Client || exit
./build.sh
./deploy.sh
