#!/usr/bin/env bash

set -e

bash build.sh -e

cp tetris.nes ed2ntc.nes

# create IPS patch
tools/flips-linux --create -i clean.nes ed2ntc.nes ed2ntc.ips

