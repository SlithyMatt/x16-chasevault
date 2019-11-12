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
.include "player.asm"
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
   lda VERA_data2
   sta VERA_data
   dex
   bne @copy_loop

   ; Setup tiles on layer 1
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_layer1, 1  ; configure VRAM layer 1
   lda #$60                      ; 4bpp tiles
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
   ;sta VERA_data
   ;sta VERA_data

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

   VERA_SET_ADDR VRAM_layer1, 0  ; enable VRAM layer 1
   lda #$01
   ora VERA_data
   sta VERA_data

   VERA_SET_ADDR VRAM_sprreg, 0  ; enable sprites
   lda #$01
   sta VERA_data

   ; Setup state
   jsr init_game
   jsr timer_clear
   lda player
   ora #$03
   sta player

   lda #255
   jsr make_vulnerable
   lda #2
   ldx #48
   jsr move_sprite_left
   lda #3
   ldx #32
   jsr move_sprite_left
   jsr enemy_tick
   lda #1
   sta joystick1_left
   .repeat 48
      jsr player_tick
   .endrepeat
   stz joystick1_left
   lda #1
   sta joystick1_up
   sta score_mult
   .repeat 80
      jsr player_tick
      jsr enemy_tick
   .endrepeat

   brk
