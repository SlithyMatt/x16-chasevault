.ifndef TILELIB_INC
TILELIB_INC = 1

xy2vaddr:   ; Input:
            ;  A: layer
            ;  X: tile display x position
            ;  Y: tile display y position
            ; Output:
            ;  A: VRAM bank
            ;  X/Y: VRAM addr
   jmp @start
@ctrl1:     .byte 0
@map:       .word 0
@xoff:      .word 0
@yoff:      .word 0
@banks:     .byte 0,1
@start:
   cmp #0
   bne @layer1
   sta VERA_ctrl
   VERA_SET_ADDR VRAM_layer0, 1
   jmp @readlayer
@layer1:
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_layer1, 1
@readlayer:
   lda VERA_data ; ignore CTRL0
   lda VERA_data
   sta @ctrl1
   lda VERA_data
   sta @map
   lda VERA_data
   sta @map+1
   lda VERA_data ; ignore TILE_BASE
   lda VERA_data
   lda VERA_data
   sta @xoff
   lda VERA_data
   sta @xoff+1
   lda VERA_data
   sta @yoff
   lda VERA_data
   sta @yoff+1
   lda @ctrl1
   and #$10
   beq @xoff_div8
   clc               ; tiles are 16 pixels wide, xoff >> 4
   ror @xoff+1
   ror @xoff
@xoff_div8:
   clc
   ror @xoff+1
   ror @xoff
   clc
   ror @xoff+1
   ror @xoff
   clc
   ror @xoff+1
   ror @xoff
   txa
   clc
   adc @xoff
   sta @xoff
   bcc @calc_yoff
   lda #1
   sta @xoff+1
@calc_yoff:
   lda @ctrl1
   and #$20
   beq @yoff_div8
   clc               ; tiles are 16 pixels high, yoff >> 4
   ror @yoff+1
   ror @yoff
@yoff_div8:
   clc
   ror @yoff+1
   ror @yoff
   clc
   ror @yoff+1
   ror @yoff
   clc
   ror @yoff+1
   ror @yoff
   tya
   clc
   adc @yoff
   sta @yoff
   bcc @calcaddr
   lda #1
   sta @yoff+1
@calcaddr:  ; address = map_base+(yoff*MAPW+xoff)*2
   lda @ctrl1
   and #$03
   clc
   adc #5
   tax            ; X = log2(MAPW)
@mult_loop:
   txa
   beq @end_mult_loop
   asl @yoff
   rol @yoff+1
   dex
   jmp @mult_loop
@end_mult_loop:   ; yoff = yoff*MAPW
   clc
   lda @yoff
   adc @xoff
   sta @yoff
   lda @yoff+1
   adc @xoff+1
   sta @yoff+1    ; yoff = yoff + xoff
   asl @yoff
   rol @yoff+1    ; yoff = yoff * 2
   asl @map
   rol @map+1
   asl @map
   rol @map+1
   lda #0
   bcc @push_bank
   lda #1
@push_bank:
   pha
   lda @map
   clc
   adc @yoff
   sta @map
   lda @map+1
   adc @yoff+1
   sta @map+1
   ldx #0
   bcc @pull_bank
   ldx #1
@pull_bank:
   pla
   clc
   adc @banks,x
   ldx @map
   ldy @map+1
   rts


pix2tilexy: ; Input:
            ; A: layer
            ; X: display x
            ; Y: display y
            ; Output:
            ; A: layer
            ; X: tile x
            ; Y: tile y
   jmp @start
@ctrl1:     .byte 0
@xoff:      .byte 0
@yoff:      .byte 0
@xshift:    .byte 3
@yshift:    .byte 3
@start:
   pha                     ; push layer
   cmp #0
   bne @layer1
   sta VERA_ctrl
   VERA_SET_ADDR VRAM_layer0, 1
   jmp @readlayer
@layer1:
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_layer1, 1
@readlayer:
   lda VERA_data ; ignore CTRL0
   lda VERA_data
   sta @ctrl1
   lda VERA_data ; ignore MAP_BASE
   lda VERA_data
   lda VERA_data ; ignore TILE_BASE
   lda VERA_data
   lda VERA_data
   sta @xoff
   lda VERA_data
   lda VERA_data
   sta @yoff
   lda VERA_data
@gettw:
   lda @ctrl1
   and #$10
   bne @tw16
   lda @xoff
   and #$07    ; A = xoff % 8
   jmp @calcx
@tw16:
   lda #4
   sta @xshift
   lda @xoff
   and #$0F    ; A = xoff %16
@calcx:
   sta @xoff
   txa
   clc
   sbc @xoff
   bpl @do_xshift
   stz @xoff
   bra @getth
@do_xshift:
   ldx @xshift
@xshift_loop:
   beq @done_xshift
   lsr
   dex
   bra @xshift_loop
@done_xshift:
   sta @xoff
@getth:
   lda @ctrl1
   and #$20
   bne @th16
   lda @yoff
   and #$07    ; A = yoff % 8
   jmp @calcy
@th16:
   lda #4
   sta @yshift
   lda @yoff
   and #$0F    ; A = yoff %16
@calcy:
   sta @yoff
   tya
   clc
   sbc @yoff
   bpl @do_yshift
   stz @yoff
   bra @end
@do_yshift:
   ldy @yshift
@yshift_loop:
   beq @done_yshift
   lsr
   dey
   bra @yshift_loop
@done_yshift:
   sta @yoff
@end:
   pla
   ldx @xoff
   ldy @yoff
   rts

.endif
