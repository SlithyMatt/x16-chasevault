.ifndef DEBUG_INC
DEBUG_INC = 1

.macro CORNER_DEBUG
   pha
   phx
   phy
   phy
   phx
   ldx #0
   ldy #0
   jsr debug
   pla
   ldx #0
   ldy #1
   jsr debug
   pla
   ldx #0
   ldy #2
   jsr debug
   ply
   plx
   pla
.endmacro

.macro DEBUG_BYTE addr, xpos, ypos
   pha
   phx
   phy
   lda addr
   .ifnblank x
      ldx #xpos
   .else
      ldx #0
   .endif
   .ifnblank y
      ldy #ypos
   .else
      ldy #2
   .endif
   jsr debug
   ply
   plx
   pla
.endmacro


.macro DEBUG_WORD word, xpos, ypos
   DEBUG_BYTE word+1, xpos, ypos
   DEBUG_BYTE word, xpos+1, ypos
.endmacro




.include "tilelib.asm"

debug:   ; A: value to display
         ; X: tile x
         ; Y: tile y
   pha
   lda #1
   jsr xy2vaddr
   stz VERA_ctrl
   ora #$10
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   pla
   tax
   lsr
   lsr
   lsr
   lsr
   cmp #$0A
   bmi @tile1
   clc
   adc #7
@tile1:
   adc #$30
   sta VERA_data
   stz VERA_data
   txa
   and #$0F
   cmp #$0A
   bmi @tile2
   clc
   adc #7
@tile2:
   adc #$30
   sta VERA_data
   stz VERA_data
   rts

.endif
