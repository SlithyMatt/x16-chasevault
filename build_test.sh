#!/bin/bash

cl65 --cpu 65C02 -o player_test.prg -l player_test.list player_test.asm
cl65 --cpu 65C02 -o enemy_test.prg -l enemy_test.list enemy_test.asm
cl65 --cpu 65C02 -o MAPBROWSE.PRG -l map_browse.list map_browse.asm
cl65 --cpu 65C02 -o startscreen_browse.prg -l startscreen_browse.list startscreen_browse.asm
cl65 --cpu 65C02 -o joystick_test.prg -l joystick_test.list joystick_test.asm
cl65 --cpu 65C02 -o fireball_test.prg -l fireball_test.list fireball_test.asm
cl65 --cpu 65C02 -o bomb_test.prg -l bomb_test.list bomb_test.asm
cl65 --cpu 65C02 -o ws_test.prg -l ws_test.list ws_test.asm
./asc2bin.exe spritesheet.txt SPRITESHEET.BIN 4000
cl65 --cpu 65C02 -o sprite_sheet.prg -l sprite_sheet.list sprite_sheet.asm
