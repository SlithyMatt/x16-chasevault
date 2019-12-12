.include "x16.inc"

.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"
   jmp start

.include "filenames.asm"
.include "loadvram.asm"
.include "player.asm"
.include "joystick.asm"
.include "skull.asm"
.include "globals.asm"
.include "timer.asm"

vsync_trig: .byte 0

def_irq: .word $0000

init_irq:
   lda IRQVec
   sta def_irq
   lda IRQVec+1
   sta def_irq+1
   lda #<handle_irq
   sta IRQVec
   lda #>handle_irq
   sta IRQVec+1
   rts

handle_irq:
   ; check for VSYNC
   lda VERA_irq
   and #$01
   beq @done_vsync
   sta vsync_trig
@done_vsync:
   jmp (def_irq)


start:
   ; Setup tiles on layer 1
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_layer1, 1  ; configure VRAM layer 1
   lda #$61                      ; 4bpp tiles
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

   VERA_SET_ADDR VRAM_sprreg, 0  ; enable sprites
   lda #$01
   sta VERA_data0

   ; load VRAM data from binaries
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

   lda #>(VRAM_sprattr>>4)
   ldx #<(VRAM_sprattr>>4)
   ldy #<spriteattr_fn
   jsr loadvram

   ; Setup interrupts
   jsr init_irq

   ; enable player movement
   jsr player_move
   jsr player_animate

   ; place skull
   lda #1
   ldx #3
   ldy #11
   jsr skull_place
   jsr skull_move

   lda #1
   sta num_fireballs
   jsr fireball_move

mainloop:
   wai
   lda vsync_trig
   beq mainloop

   ; VSYNC has occurred, handle
   inc frame_num
   lda frame_num
   cmp #60
   bne @do_tick
   stz frame_num

@do_tick:
   jsr timer_tick
   jsr joystick_tick
   jsr player_tick
   jsr skull_tick
   jsr fireball_tick

   stz vsync_trig
   bra mainloop  ; loop forever






   brk
