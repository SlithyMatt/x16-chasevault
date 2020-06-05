#!/bin/bash

cl65 --cpu 65C02 -o MAPBROWSE.PRG -l map_browse.list map_browse.asm
cl65 --cpu 65C02 -o startscreen_browse.prg -l startscreen_browse.list startscreen_browse.asm
cl65 --cpu 65C02 -o joystick_test.prg -l joystick_test.list joystick_test.asm
cl65 --cpu 65C02 -o ws_test.prg -l ws_test.list ws_test.asm
./asc2bin.exe spritesheet.txt SPRITESHEET.BIN 4000
cl65 --cpu 65C02 -o sprite_sheet.prg -l sprite_sheet.list sprite_sheet.asm
cl65 --cpu 65C02 -o TSTMUSIC.PRG -l music_test.list music_test.asm
