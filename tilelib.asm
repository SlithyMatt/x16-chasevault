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
            ; A: bit 4: layer; bits 3,2: x (9:8), bits 1,0: y (9:8)
            ; X: display x (7:0)
            ; Y: display y (7:0)
            ; Output:
            ; A: bits 7-4: TILEW/2, bits 3-0: TILEH/2
            ; X: tile x
            ; Y: tile y
   jmp @start
@ctrl1:     .byte 0
@xoff:      .word 0
@yoff:      .word 0
@xshift:    .byte 3
@yshift:    .byte 3
@start:
   pha                     ; push A params
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
   sec
   sbc @xoff
   php
   plx
   sta @xoff
   pla
   pha
   and #$0C
   lsr
   lsr
   phx
   plp
   sbc #0
   bpl @do_xshift
   stz @xoff
   stz @xoff+1
   bra @getth
@do_xshift:
   sta @xoff+1
   ldx @xshift
@xshift_loop:
   beq @done_xshift
   lsr @xoff+1
   ror @xoff
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
   sec
   sbc @yoff
   php
   plx
   sta @xoff
   pla
   pha
   and #$03
   phx
   plp
   sbc #0
   bpl @do_yshift
   stz @yoff
   stz @yoff+1
   bra @end
@do_yshift:
   ldy @yshift
@yshift_loop:
   beq @done_yshift
   lsr @yoff+1
   ror @yoff
   dey
   bra @yshift_loop
@done_yshift:
   sta @yoff
@end:
   pla
   and #$30
   bit #$20
   beq @ret_th8
   ora #$08
   bra @ret_tw
@ret_th8:
   ora #$04
@ret_tw:
   bit #$10
   beq @ret_tw8
   and #$0F
   ora #$80
   bra @return
@ret_tw8:
   and #$0F
   ora #$40
@return:
   ldx @xoff
   ldy @yoff
   rts


get_tile:   ; Input:
            ; A: layer
            ; X: tile display x position
            ; Y: tile display y position
            ; Output:
            ; A: layer
            ; X: tile entry 0
            ; Y: tile entry 1
   pha
   jsr xy2vaddr
   stz VERA_ctrl
   ora #$10
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   ldx VERA_data
   ldy VERA_data
   pla
   rts

.endif
