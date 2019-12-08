.ifndef FILENAMES_INC
FILENAMES_INC = 1

filenames:
tilemap_fn:    .asciiz "tilemap.bin"
sprites_fn:    .asciiz "sprites.bin"
tiles_fn:      .asciiz "tiles.bin"
palette_fn:    .asciiz "pal.bin"
spriteattr_fn: .asciiz "spriteattr.bin"
ssbg_fn:       .asciiz "startscrnbg.bin"
bm_filename:   .asciiz "bitmap.bin"
end_filenames:
BANKS_TO_LOAD = 1
bankparams:
.byte end_filenames-bm_filename-1
.byte <bm_filename
.byte >bm_filename

.endif
