.include "x16.inc"

.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"
   jmp start

.include "filenames.asm"
.include "loadvram.asm"
.include "fireball.asm"
.include "globals.asm"

START_RECORDING = 10
STOP_RECORDING = 78

record:    .byte 1
frame_num: .byte 0

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
   ; Disable layer 1
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_layer1, 1  ; configure VRAM layer 1
   stz VERA_data0

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

   ; enable fireballs
   lda #FIREBALL_H_FRAME
   ldx #FIREBALL1_idx
   ldy #0
   jsr sprite_frame

   lda #FIREBALL_V_FRAME
   ldx #FIREBALL2_idx
   ldy #0
   jsr sprite_frame

   lda #FIREBALL_H_FRAME
   ldx #FIREBALL3_idx
   ldy #1
   jsr sprite_frame

   lda #FIREBALL_V_FRAME
   ldx #FIREBALL4_idx
   ldy #2
   jsr sprite_frame

mainloop:
   wai
   lda vsync_trig
   beq mainloop

   ; VSYNC has occurred, handle
   lda record
   beq @do_tick
   inc frame_num
   lda frame_num
   cmp #START_RECORDING
   bne @check_stop
   lda #2
   sta GIF_ctrl ; start recording gif
@check_stop:
   cmp #STOP_RECORDING
   bne @do_tick
   stz GIF_ctrl ; stop recording gif
   stz record

@do_tick:
   jsr fireball_tick

   stz vsync_trig
   bra mainloop  ; loop forever






   brk
