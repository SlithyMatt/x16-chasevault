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
   ; Disable layers and sprites
   lda VERA_dc_video
   and #$8F
   sta VERA_dc_video

   ; Setup tiles on layer 1
   lda #$A2                      ; 128x128 map of 4bpp tiles
   sta VERA_L1_config
   lda #((VRAM_TILEMAP >> 9) & $FF)
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

   ; setup game parameters and initialize states
   jsr init_game

   ; enable layer 1
   lda VERA_dc_video
   ora #$20
   sta VERA_dc_video

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
   lda next_scale
   sta VERA_dc_hscale
   sta VERA_dc_vscale
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
   lda hscroll
   sta VERA_L1_hscroll_l
   lda hscroll+1
   sta VERA_L1_hscroll_h
   lda vscroll
   sta VERA_L1_vscroll_l
   lda vscroll+1
   sta VERA_L1_vscroll_h

   stz vsync_trig
   jmp mainloop  ; loop forever
