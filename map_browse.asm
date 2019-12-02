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
select_down: .byte 0
next_scale: .byte 128

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
   lda #$3A                      ; 128x128 map of 16x16 tiles
   sta VERA_data0
   lda #((VRAM_TILEMAP >> 2) & $FF)
   sta VERA_data0
   lda #((VRAM_TILEMAP >> 10) & $FF)
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

   ; setup game parameters and initialize states
   jsr init_game

   VERA_SET_ADDR VRAM_layer1, 0  ; enable VRAM layer 1
   lda #$01
   ora VERA_data0
   sta VERA_data0

   ; setup interrupts
   jsr init_irq

mainloop:
   wai
   lda vsync_trig
   beq mainloop

   ; VSYNC occurred
   jsr joystick_tick
   lda joystick1_select
   beq @select_up
   lda select_down
   bne @check_right
   lda #1
   sta select_down
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_hscale,1
   lda next_scale
   sta VERA_data0
   sta VERA_data0
   cmp #64
   beq @next128
   lda #64
   bra @scale
@next128:
   lda #128
@scale:
   sta next_scale
   bra @check_right
@select_up:
   stz select_down
@check_right:
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
   stz VERA_ctrl
   VERA_SET_ADDR $F3006, 1
   lda hscroll
   sta VERA_data0
   lda hscroll+1
   sta VERA_data0
   lda vscroll
   sta VERA_data0
   lda vscroll+1
   sta VERA_data0

   stz vsync_trig
   jmp mainloop  ; loop forever
