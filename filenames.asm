.ifndef FILENAMES_INC
FILENAMES_INC = 1

filenames:
tilemap_fn:    .asciiz "tilemap.bin"
sprites_fn:    .asciiz "sprites.bin"
tiles_fn:      .asciiz "tiles.bin"
palette_fn:    .asciiz "pal.bin"
spriteattr_fn: .asciiz "spriteattr.bin"
b0_filename:   .asciiz "bitmap.b000.bin"
b1_filename:   .asciiz "bitmap.b001.bin"
b2_filename:   .asciiz "bitmap.b002.bin"
b3_filename:   .asciiz "bitmap.b003.bin"
b4_filename:   .asciiz "bitmap.b004.bin"
end_filenames:
BANKS_TO_LOAD = 5
bankparams:
.byte b1_filename-b0_filename-1
.byte <b0_filename
.byte >b0_filename
.byte b2_filename-b1_filename-1
.byte <b1_filename
.byte >b1_filename
.byte b3_filename-b2_filename-1
.byte <b2_filename
.byte >b2_filename
.byte b4_filename-b3_filename-1
.byte <b3_filename
.byte >b3_filename
.byte end_filenames-b4_filename-1
.byte <b4_filename
.byte >b4_filename

.endif
