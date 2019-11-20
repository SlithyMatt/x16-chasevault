.include "x16.inc"

.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"
   jmp start

.include "filenames.asm"
.include "loadvram.asm"
.include "irq.asm"
.include "game.asm"
.include "globals.asm"
.include "joystick.asm"
.include "vsync.asm"

hscroll: .word 0
vscroll: .word 0

start:
   ; move text to layer 0 (TODO: replace with bitmap)
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_layer0, 1
   lda #1
   sta VERA_ctrl
   VERA_SET_ADDR VRAM_layer1, 1
   ldx #10
@copy_loop:
   lda VERA_data2
   sta VERA_data
   dex
   bne @copy_loop
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_layer0, 0  ; disable VRAM layer 0
   lda #$FE
   and VERA_data
   sta VERA_data

   ; Setup tiles on layer 1
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_layer1, 1  ; configure VRAM layer 1
   lda #$60                      ; 4bpp tiles
   sta VERA_data
   lda #$31                      ; 64x32 map of 16x16 tiles
   sta VERA_data
   lda #((VRAM_STARTSCRN >> 2) & $FF)
   sta VERA_data
   lda #((VRAM_STARTSCRN >> 10) & $FF)
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

   ; load VRAM data from binaries
   lda #>(VRAM_TILEMAP>>4)
   ldx #<(VRAM_TILEMAP>>4)
   ldy #<tilemap_fn
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
   ora VERA_data
   sta VERA_data

   ; setup interrupts
   jsr init_irq

mainloop:
   wai
   lda vsync_trig
   beq mainloop

   ; VSYNC occurred
   jsr joystick_tick
   lda joystick1_right
   cmp #0
   beq @check_left
   lda hscroll
   clc
   adc #1
   sta hscroll
   lda hscroll+1
   adc #0
   sta hscroll+1
@check_left:
   lda joystick1_left
   cmp #0
   beq @check_down
   lda hscroll
   sec
   sbc #1
   sta hscroll
   lda hscroll+1
   sbc #0
   sta hscroll+1
@check_down:
   lda joystick1_down
   cmp #0
   beq @check_up
   lda vscroll
   clc
   adc #1
   sta vscroll
   lda vscroll+1
   adc #0
   sta vscroll+1
@check_up:
   lda joystick1_up
   cmp #0
   beq @set_scroll
   lda vscroll
   sec
   sbc #1
   sta vscroll
   lda vscroll+1
   sbc #0
   sta vscroll+1
@set_scroll:
   VERA_SET_ADDR VRAM_layer1, 1
   lda VERA_data ; ignore
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda hscroll
   sta VERA_data
   lda hscroll+1
   sta VERA_data
   lda vscroll
   sta VERA_data
   lda vscroll+1
   sta VERA_data

   stz vsync_trig
   jmp mainloop  ; loop forever
