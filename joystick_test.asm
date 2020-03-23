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
.include "globals.asm"
.include "joystick.asm"
.include "vsync.asm"
.include "superimpose.asm"
.include "debug.asm"

hscroll: .word 0
vscroll: .word 0

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

   ; setup screen
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_TILEMAP, 1
   ldx #<7680
   ldy #>7680
@map_loop:
   stz VERA_data0
   dex
   cpy #0
   beq @check_x_zero
   cpx #$FF
   bne @map_loop
   dey
   bra @map_loop
@check_x_zero:
   cpx #0
   bne @map_loop

   SUPERIMPOSE "joystick1  joystick2", 0, 0
   SUPERIMPOSE "left       left", 0, 1
   SUPERIMPOSE "right      right", 0, 2
   SUPERIMPOSE "down       down", 0, 3
   SUPERIMPOSE "up         up", 0, 4
   SUPERIMPOSE "select     select", 0, 5
   SUPERIMPOSE "start      start", 0, 6
   SUPERIMPOSE "b          b", 0, 7
   SUPERIMPOSE "a          a", 0, 8


mainloop:
   wai
   lda vsync_trig
   beq mainloop

   ; VSYNC occurred
   jsr joystick_tick

   DEBUG_BYTE joystick1_left, 7, 1
   DEBUG_BYTE joystick1_right, 7, 2
   DEBUG_BYTE joystick1_down, 7, 3
   DEBUG_BYTE joystick1_up, 7, 4
   DEBUG_BYTE joystick1_select, 7, 5
   DEBUG_BYTE joystick1_start, 7, 6
   DEBUG_BYTE joystick1_b, 7, 7
   DEBUG_BYTE joystick1_a, 7, 8

   DEBUG_BYTE joystick2_left, 18, 1
   DEBUG_BYTE joystick2_right, 18, 2
   DEBUG_BYTE joystick2_down, 18, 3
   DEBUG_BYTE joystick2_up, 18, 4
   DEBUG_BYTE joystick2_select, 18, 5
   DEBUG_BYTE joystick2_start, 18, 6
   DEBUG_BYTE joystick2_b, 18, 7
   DEBUG_BYTE joystick2_a, 18, 8

   stz vsync_trig
   jmp mainloop  ; loop forever
