# x16-chasevault
Chase Vault: A new game for the Commander X16 retrocomputer.

As seen on YouTube: https://youtu.be/txjvnLN1h38

![](cv9.gif)

To build game files, run **build.sh** in bash (Git bash is recommended for Windows). The following files generated will need to be loaded to the X16 filesystem:

* **CHASEVAULT.PRG** - Program that needs to be loaded by BASIC.
Simply `LOAD "CHASEVAULT.PRG"` then `RUN`, or auto-run with the emulator from this directory: `path/to/x16emu -prg CHASEVAULT.PRG -run`
* **TILEMAP.BIN** - 128x128 map of 16x16 tiles, loaded by program to VRAM
* **SPRITES.BIN** - 16x16 4bpp sprite frames, loaded by program to VRAM
* **TILES.BIN** - 16x16 4bpp tiles, loaded by program to VRAM
* **PAL.BIN** - custom palette, loaded by program to VERA register
* **SPRITEATTR.BIN** - initial sprite attributes, loaded by program to VERA registers
* **STARTSCRNBG.BIN** - start screen background bitmap, loaded by program directly to VRAM at start
* **BITMAP.BIN** - game level background bitmap, loaded by program to banked RAM at start, then replaces STARTSCRNBG.BIN in VRAM after start
* **NORMX.BIN** - vector normalization X-value lookup table, loaded by program to banked RAM
* **NORMY.BIN** - vector normalization Y-value lookup table, loaded by program to banked RAM

Build requirements: gcc, cc65

Please note at this time that the game is not yet fully
playable. It is under active development, so the master branch is not stable.

Last working demo commit: https://github.com/SlithyMatt/x16-chasevault/tree/6a13c050f2e9a674f14ff1f10ccf38f70a9ba562

The levels 1-31, 33, 34, 37-39, 41, 44 and 45 are fully playable in this build, but no further levels have been developed at this time.
