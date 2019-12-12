.ifndef FILENAMES_INC
FILENAMES_INC = 1

.include "globals.asm"

filenames:
tilemap_fn:    .asciiz "tilemap.bin"
sprites_fn:    .asciiz "sprites.bin"
tiles_fn:      .asciiz "tiles.bin"
palette_fn:    .asciiz "pal.bin"
spriteattr_fn: .asciiz "spriteattr.bin"
ssbg_fn:       .asciiz "startscrnbg.bin"
bm_filename:   .asciiz "bitmap.bin"
normx_fn:      .asciiz "normx.bin"
normy_fn:      .asciiz "normy.bin"
end_filenames:
FILES_TO_LOAD = 3
bankparams:
.byte BITMAP_BANK                ; bank
.byte normx_fn-bm_filename-1     ; filename length
.word bm_filename                ; filename address
.byte NORMX_BANK
.byte normy_fn-normx_fn-1
.word normx_fn
.byte NORMY_BANK
.byte end_filenames-normy_fn-1
.word normy_fn

.endif
