.include "x16.inc"

.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"
   jmp start

.include "filenames.asm"
.include "loadbank.asm"
.include "loadvram.asm"
.include "irq.asm"
.include "vsync.asm"
.include "game.asm"
.include "globals.asm"

start:
   ; move text to layer 0 (TODO: replace with bitmap)
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_layer0, 1
   lda #1
   sta VERA_ctrl
   VERA_SET_ADDR VRAM_layer1, 1
   ldx #10
@copy_loop:
   lda VERA_data1
   sta VERA_data0
   dex
   bne @copy_loop
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_layer0, 0  ; disable VRAM layer 0
   lda #$FE
   and VERA_data0
   sta VERA_data0

   ; Setup tiles on layer 1
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_layer1, 1  ; configure VRAM layer 1
   lda #$60                      ; 4bpp tiles
   sta VERA_data0
   lda #$31                      ; 64x32 map of 16x16 tiles
   sta VERA_data0
   lda #((VRAM_STARTSCRN >> 2) & $FF)
   sta VERA_data0
   lda #((VRAM_STARTSCRN >> 10) & $FF)
   sta VERA_data0
   lda #((VRAM_TILES >> 2) & $FF)
   sta VERA_data0
   lda #((VRAM_TILES >> 10) & $FF)
   sta VERA_data0
   lda #$00                      ; initial scroll position on screen 0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0
   sta VERA_data0

   VERA_SET_ADDR VRAM_hscale, 1  ; set display to 2x scale
   lda #64
   sta VERA_data0
   sta VERA_data0

   ; load VRAM data from binaries
   lda #>(VRAM_TILEMAP>>4)
   ldx #<(VRAM_TILEMAP>>4)
   ldy #<tilemap_fn
   jsr loadvram

   lda #>(VRAM_SPRITES>>4)
   ldx #<(VRAM_SPRITES>>4)
   ldy #<sprites_fn
   jsr loadvram

   lda #>(VRAM_TILES>>4)
   ldx #<(VRAM_TILES>>4)
   ldy #<tiles_fn
   jsr loadvram

   lda #>(VRAM_palette>>4)
   ldx #<(VRAM_palette>>4)
   ldy #<palette_fn
   jsr loadvram

   ; TODO: store bitmap binaries to banked RAM

   ; TODO: configure layer 0 for background bitmaps

   ; TODO: load screen 0 bitmap from banked RAM into layer 0

   VERA_SET_ADDR VRAM_layer1, 0  ; enable VRAM layer 1
   lda #$01
   ora VERA_data0
   sta VERA_data0

   ; setup interrupts
   jsr init_irq

mainloop:
   wai
   jsr check_vsync
   bra mainloop  ; loop forever
