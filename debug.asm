.ifndef DEBUG_INC
DEBUG_INC = 1

debug:   ; A: value to display
         ; X: tile x
         ; Y: tile y
   pha
   lda #1
   jsr xy2vaddr
   stz VERA_ctrl
   ora #$20
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
   txa
   and #$0F
   cmp #$0A
   bmi @tile2
   clc
   adc #7
@tile2:
   adc #$30
   sta VERA_data
   rts

.endif
