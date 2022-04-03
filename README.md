# x16-chasevault
Chase Vault: A new game for the Commander X16 retrocomputer.

As seen on YouTube: https://youtu.be/f6d036XFiTk

![](cv9.gif)

To build game files, run **build.sh** in bash (Git bash is recommended for Windows). The following files generated will need to be loaded to the X16 filesystem:

* **CHASVALT.PRG** - Program that needs to be loaded by BASIC.
Simply `LOAD "CHASVALT.PRG"` then `RUN`, or auto-run with the emulator from this directory: `path/to/x16emu -prg CHASVALT.PRG -run`
* **TILEMAP.BIN** - 128x128 map of 16x16 tiles, loaded by program to VRAM
* **LOADMAP.BIN** - 32x32 map of 16x16 tiles, loaded to VRAM to display load screen until final tilemap is loaded.
* **SPRITES.BIN** - 16x16 4bpp sprite frames, loaded by program to VRAM
* **TILES.BIN** - 16x16 4bpp tiles, loaded by program to VRAM
* **PAL.BIN** - custom palette, loaded by program to VERA register
* **SPRTATTR.BIN** - initial sprite attributes, loaded by program to VERA registers
* **STARTBG.BIN** - start screen background bitmap, loaded by program directly to VRAM at start
* **BITMAP.BIN** - game level background bitmap, loaded by program to banked RAM at start, then replaces STARTBG.BIN in VRAM after start
* **NORMX.BIN** - vector normalization X-value lookup table, loaded by program to banked RAM
* **NORMY.BIN** - vector normalization Y-value lookup table, loaded by program to banked RAM
* **MUSIC.BIN** - music for YM2151 FM synthesizer
* **WINMUSIC.BIN** - music for winners only

Build requirements: gcc, cc65

This game is now undergoing beta testing. The master baseline is not guaranteed to be fully working. The latest stable release is
https://github.com/SlithyMatt/x16-chasevault/releases/tag/v0.7b
