#!/bin/bash

if [ ! -f "asc2bin.exe" ]; then
  ./build_tools.sh
fi

if [ ! -f "TILEMAP.BIN" ]; then
  ./build_bins.sh
fi

cl65 -o CHASEVAULT.PRG -l chasevault.list chasevault.asm
