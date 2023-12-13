#!/usr/bin/env bash

set -e

bash build.sh -e

cp tetris.nes ed2ntc.nes
cp tetris.bps ed2ntc.bps


