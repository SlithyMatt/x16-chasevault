#!/bin/bash

cl65 --cpu 65C02 -o player_test.prg -l player_test.list player_test.asm
cl65 --cpu 65C02 -o enemy_test.prg -l enemy_test.list enemy_test.asm
cl65 --cpu 65C02 -o map_browse.prg -l map_browse.list map_browse.asm
cl65 --cpu 65C02 -o joystick_test.prg -l joystick_test.list joystick_test.asm
