#!/usr/bin/env bash

set -e

bash build.sh -e

# create IPS patch
tools/flips-linux --create -i clean.nes tetris.nes ed2ntc.ips

