#!/bin/bash

./asc2bin.exe tilemap.txt TILEMAP.BIN 4000
./asc2bin.exe sprite_buffer.txt SPRITES.BIN E000
./asc2bin.exe tile_buffer.txt TILES.BIN 0000
./asc2bin.exe palette.txt PAL.BIN 1000
./asc2bin.exe sprite_attr.txt SPRITEATTR.BIN 5000
./make4bitbin.exe bitmap.data BITMAP.BIN A000
./make4bitbin.exe startscrnbg.data STARTSCRNBG.BIN 6A00
./normtables.exe
./asc2bin.exe normx.txt NORMX.BIN A000
./asc2bin.exe normy.txt NORMY.BIN A000
