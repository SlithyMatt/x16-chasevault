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

   ; setup screen
   VERA_SET_ADDR VRAM_TILEMAP, 2
   ldx #<16384
   ldy #>16384
@map_loop:
   stz VERA_data0
   dex
   bne @map_loop
   dey
   bne @map_loop
   cpx #0
   bne @map_loop

   SUPERIMPOSE "joystick1  joystick2", 0, 0
   SUPERIMPOSE "left       left", 0, 1
   SUPERIMPOSE "right      down", 0, 2
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
