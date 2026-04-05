#!/usr/bin/env bash

set -e

node build.js -e

cp tetris.nes ed2ntc.nes

# create IPS patch
# tools/flips-linux --create -i clean.nes ed2ntc.nes ed2ntc.ips
