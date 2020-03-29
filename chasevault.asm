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

   lda #>(VRAM_palette>>4)
   ldx #<(VRAM_palette>>4)
   ldy #<palette_fn
   jsr loadvram



   ; load VRAM data from binaries
   lda #>(VRAM_TILES>>4)
   ldx #<(VRAM_TILES>>4)
   ldy #<tiles_fn
   jsr loadvram



   lda #>(VRAM_LOADMAP>>4)
   ldx #<(VRAM_LOADMAP>>4)
   ldy #<loadmap_fn
   jsr loadvram



   ; Disable layers and sprites
   lda VERA_dc_video
   and #$8F
   sta VERA_dc_video

   ; Setup tiles on layer 1
   lda #$02                      ; 32x32 map of 4bpp tiles
   sta VERA_L1_config
   lda #((VRAM_LOADMAP >> 9) & $FF)
   sta VERA_L1_mapbase
   lda #((((VRAM_TILES >> 11) & $3F) << 2) | $03)  ; 16x16 tiles
   sta VERA_L1_tilebase
   stz VERA_L1_hscroll_l         ; set scroll position to 0,0
   stz VERA_L1_hscroll_h
   stz VERA_L1_vscroll_l
   stz VERA_L1_vscroll_h

   ; set display to 2x scale
   lda #64
   sta VERA_dc_hscale
   sta VERA_dc_vscale

   ; enable layer 1
   lda VERA_dc_video
   ora #$20
   sta VERA_dc_video

   lda #>(VRAM_SPRITES>>4)
   ldx #<(VRAM_SPRITES>>4)
   ldy #<sprites_fn
   jsr loadvram

   ;jmp mainloop

   ; store additional binaries to banked RAM
   jsr loadbank



   lda #>(VRAM_TILEMAP>>4)
   ldx #<(VRAM_TILEMAP>>4)
   ldy #<tilemap_fn
   jsr loadvram



   lda #>(VRAM_BITMAP>>4)
   ldx #<(VRAM_BITMAP>>4)
   ldy #<ssbg_fn
   jsr loadvram



   ; Disable layers and sprites
   lda VERA_dc_video
   and #$8F
   sta VERA_dc_video

   ; Re-map tiles to start screen
   lda #$12                      ; 64x32 map of 4bpp tiles
   sta VERA_L1_config
   lda #((VRAM_STARTSCRN >> 9) & $FF)
   sta VERA_L1_mapbase

   ; configure layer 0 for background bitmaps
   lda #$06       ; 4bpp bitmap
   sta VERA_L0_config
   lda #((((VRAM_BITMAP >> 11) & $3F) << 2) | $00) ; 320x240
   sta VERA_L0_tilebase
   lda #8
   sta BITMAP_PO ; Palette offset = 8

   ; enable all layers
   lda VERA_dc_video
   ora #$30
   sta VERA_dc_video

   ; setup interrupts
   jsr init_irq

mainloop:
   wai
   jsr check_vsync
   bra mainloop  ; loop forever
