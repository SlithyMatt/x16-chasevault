.ifndef IRQ_INC
IRQ_INC = 1

.include "game.asm"

def_irq: .word $0000

init_irq:
   sei
   lda IRQVec
   sta def_irq
   lda IRQVec+1
   sta def_irq+1
   lda #<handle_irq
   sta IRQVec
   lda #>handle_irq
   sta IRQVec+1
   cli
   rts



handle_irq:
   ; check for VSYNC
   lda VERA_isr
   and #$01
   beq @done_vsync
   jsr game_tick

@done_vsync:

   jmp (def_irq)




.endif
