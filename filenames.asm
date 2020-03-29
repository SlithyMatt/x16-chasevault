.ifndef FILENAMES_INC
FILENAMES_INC = 1

.include "globals.asm"

filenames:
tilemap_fn:    .asciiz "tilemap.bin"
loadmap_fn:    .asciiz "loadmap.bin"
sprites_fn:    .asciiz "sprites.bin"
tiles_fn:      .asciiz "tiles.bin"
palette_fn:    .asciiz "pal.bin"
spriteattr_fn: .asciiz "sprtattr.bin"
ssbg_fn:       .asciiz "startbg.bin"
bm_filename:   .asciiz "bitmap.bin"
normx_fn:      .asciiz "normx.bin"
normy_fn:      .asciiz "normy.bin"
music_fn:      .asciiz "music.bin"
win_music_fn:  .asciiz "winmusic.bin"
end_filenames:
FILES_TO_LOAD = 5
bankparams:
.byte BITMAP_BANK                ; bank
.byte normx_fn-bm_filename-1     ; filename length
.word bm_filename                ; filename address
.byte NORMX_BANK
.byte normy_fn-normx_fn-1
.word normx_fn
.byte NORMY_BANK
.byte music_fn-normy_fn-1
.word normy_fn
.byte GAME_MUSIC_BANK
.byte win_music_fn-music_fn-1
.word music_fn
.byte WIN_MUSIC_BANK
.byte end_filenames-win_music_fn-1
.word win_music_fn

.endif
