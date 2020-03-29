#!/bin/bash

./asc2bin.exe tilemap.txt TILEMAP.BIN 0000
./asc2bin.exe loadmap.txt LOADMAP.BIN 6000
./asc2bin.exe sprite_buffer.txt SPRITES.BIN 0000
./asc2bin.exe tile_buffer.txt TILES.BIN 8800
./asc2bin.exe palette.txt PAL.BIN FA00
./asc2bin.exe sprite_attr.txt SPRTATTR.BIN FC00
./make4bitbin.exe bitmap.data BITMAP.BIN A000
./make4bitbin.exe startscrnbg.data STARTBG.BIN 6800
./normtables.exe
./asc2bin.exe normx.txt NORMX.BIN A000
./asc2bin.exe normy.txt NORMY.BIN A000
./vgm2x16opm.exe ChaseVaultTheme.vgm MUSIC.BIN A000
./vgm2x16opm.exe ChaseVaultWin.vgm WINMUSIC.BIN A000
