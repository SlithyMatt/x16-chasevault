.include "x16.inc"

.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"
   jmp start

.include "filenames.asm"
.include "loadvram.asm"
.include "globals.asm"
.include "timer.asm"
.include "winscreen.asm"

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
   lda VERA_isr
   and #$01
   beq @done_vsync
   sta vsync_trig
@done_vsync:
   jmp (def_irq)


start:

   ; set display to 2x scale
   lda #64
   sta VERA_dc_hscale
   sta VERA_dc_vscale

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

   ; Setup interrupts
   jsr init_irq

   ; request winscreen
   lda #1
   sta winscreen_req

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
   jsr winscreen_tick

   stz vsync_trig
   bra mainloop  ; loop forever

   brk
