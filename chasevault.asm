.include "x16.inc"

.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"
   jmp start

VRAM_TILEMAP   = $04000 ; 128x128
VRAM_SPRITES   = $0E000 ; 128 4bpp 16x16 frames
VRAM_TILES     = $10000 ; 424 4bpp 16x16 (may also be used as sprite frames)
VRAM_BITMAP    = $16A00 ; 4bpp 320x240

tilemap_fn:    .asciiz "tilemap.bin"
sprites_fn:    .asciiz "sprites.bin"
tiles_fn:      .asciiz "tiles.bin"
palette_fn:    .asciiz "pal.bin"
spriteattr_fn: .asciiz "spriteattr.bin"

b0_filename: .asciiz "bitmap.b000.bin"
b1_filename: .asciiz "bitmap.b001.bin"
b2_filename: .asciiz "bitmap.b002.bin"
b3_filename: .asciiz "bitmap.b003.bin"
b4_filename: .asciiz "bitmap.b004.bin"
end_filenames:
BANKS_TO_LOAD = 10
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

.include "loadbank.asm"

start:
   lda #0
   sta VERA_ctrl
   VERA_SET_ADDR VRAM_layer0, 0  ; disable VRAM layer 0
   lda #$FE
   and VERA_data
   sta VERA_data

   VERA_SET_ADDR VRAM_layer1, 1  ; configure VRAM layer 1
   lda #$61                      ; 4bpp tiles
   sta VERA_data
   lda #$3A                      ; 128x128 map of 16x16 tiles
   sta VERA_data
   lda #((VRAM_TILEMAP >> 2) & $FF)
   sta VERA_data
   lda #((VRAM_TILEMAP >> 10) & $FF)
   sta VERA_data
   lda #((VRAM_TILES >> 2) & $FF)
   sta VERA_data
   lda #((VRAM_TILES >> 10) & $FF)
   sta VERA_data
   lda #$00                      ; initial scroll position on screen 0
   sta VERA_data
   sta VERA_data
   sta VERA_data
   sta VERA_data

   VERA_SET_ADDR VRAM_hscale, 1  ; set display to 2x scale
   lda #64
   sta VERA_data
   sta VERA_data

   ; TODO: load VRAM data from binaries

   ; TODO: store bitmap binaries to banked RAM

   ; TODO: configure layer 0 for background bitmaps

   ; TODO: load screen 0 bitmap from banked RAM into layer 0

   ; TODO: setup game parameters and initialize states

   ; TODO: setup interrupts

   ; TODO: start game

end:
   nop
   jmp end  ; loop forever
