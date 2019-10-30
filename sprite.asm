.ifndef SPRITE_INC
SPRITE_INC = 1

.include "x16.inc"
.include "tilelib.asm"

.ifndef VRAM_SPRITES
VRAM_SPRITES = $0E000
.endif

__sprattr:  ; A: sprite index
   stz VERA_ctrl
   pha
   asl
   asl
   asl
   sta VERA_addr_low
   pla
   lsr
   lsr
   lsr
   lsr
   lsr
   ora #>VRAM_sprattr
   sta VERA_addr_high
   lda #(^VRAM_sprattr | $10)
   sta VERA_addr_bank
   rts

sprite_frame:     ; A: frame
                  ; X: sprite index
   asl
   asl
   pha
   txa
   jsr __sprattr
   pla
   clc
   adc #<(VRAM_SPRITES >> 5)
   sta VERA_data
   lda #0
   adc #>(VRAM_SPRITES >> 5)
   sta VERA_data
   rts


sprite_getpos: ; Input:
               ; A: sprite index
               ; X: tile layer (0,1)
               ; Output:
               ; A: tile overlap (n:ne:e:se:s:sw:w:nw)
               ; X: tile x
               ; Y: tile y
   bra @start
@xpos:         .word 0
@ypos:         .word 0
@halfwidth:    .byte 4
@halfheight:   .byte 4
@tilew:        .byte 0
@tileh:        .byte 0
@overlap:      .byte 0
@start:
   cpx #1
   php
   jsr __sprattr
   lda VERA_data
   sta @xpos
   lda VERA_data
   sta @xpos+1
   lda VERA_data
   sta @ypos
   lda VERA_data
   sta @ypos+1
   lda VERA_data ; ignore
   lda VERA_data
   bit #$10
   beq @check_high_width
   asl @halfwidth
@check_high_width:
   bit #$20
   beq @check_height
   asl @halfwidth
   asl @halfwidth
@check_height:
   bit #$40
   beq @check_high_height
   asl @halfheight
@check_high_height:
   bit #$80
   beq @calc_center
   asl @halfheight
   asl @halfheight
@calc_center:
   lda @xpos
   clc
   adc @halfwidth
   sta @xpos
   tax
   lda @xpos+1
   adc #0
   sta @xpos+1
   lda @ypos
   clc
   adc @halfheight
   sta @ypos
   tay
   lda @ypos+1
   adc #0
   sta @ypos+1
   lda @xpos+1
   asl
   asl
   ora @ypos+1
   plp
   bne @get_tile
   ora #$10
@get_tile:
   jsr pix2tilexy
   phx
   phy
   pha
   and #$F0
   lsr
   lsr
   lsr
   sta @tilew
   ; TODO handle sprites wider than tiles
   dec
   and @xpos         ; A = xpos % TILEW
   tax
   cmp @halfwidth
   bmi @west         ; overlaps to west
   lda @tilew
   clc
   sbc @halfwidth
   sta @xpos+1
   cpx @xpos+1
   bmi @test_north   ; entire width of sprite inside tile
   lda @overlap
   ora #$20          ; overlaps to east
   sta @overlap
   bra @test_north
@west:
   lda @overlap
   ora #$02
   sta @overlap
@test_north:
   pla
   and #$0F
   asl
   sta @tileh
   ; TODO handle sprites taller than tiles
   dec
   and @ypos         ; A = ypos % TILEH
   tay
   cmp @halfheight
   bmi @north        ; overlaps to north
   lda @tileh
   clc
   sbc @halfheight
   sta @ypos+1
   cpy @ypos+1
   bmi @return       ; entire height of sprite inside tile
   lda @overlap
   ora #$08          ; overlaps to south
   sta @overlap
   bra @test_se
@north:
   lda @overlap
   ora #$80
   sta @overlap
   and #$A0
   cmp #$A0
   bne @test_se
   lda @overlap
   ora #$40
   sta @overlap   ; overlaps NE
   bra @return
@test_se:
   lda @overlap
   and #$28
   cmp #$28
   bne @test_sw
   lda @overlap
   ora #$10
   sta @overlap   ; overlaps SE
   bra @return
@test_sw:
   lda @overlap
   and #$0A
   cmp #$0A
   bne @test_nw
   lda @overlap
   ora #$04
   sta @overlap   ; overlaps SW
   bra @return
@test_nw:
   lda @overlap
   and #$82
   cmp #$82
   bne @return
   lda @overlap
   ora #$01
   sta @overlap   ; overlaps NW
@return:
   lda @overlap
   ply
   plx
   rts

move_sprite_right:   ; A: sprite index
   bra @start
@xpos: .word 0
@start:
   jsr __sprattr
   lda VERA_data
   lda VERA_data
   lda VERA_data
   sta @xpos
   lda VERA_data
   sta @xpos+1
   lda @xpos
   clc
   adc #1
   sta @xpos
   lda @xpos+1
   adc #0
   sta @xpos+1
   jsr __sprattr
   lda VERA_data
   lda VERA_data
   lda @xpos
   sta VERA_data
   lda @xpos+1
   sta VERA_data
   rts

move_sprite_left:   ; A: sprite index
   bra @start
@xpos: .word 0
@start:
   jsr __sprattr
   lda VERA_data
   lda VERA_data
   lda VERA_data
   sta @xpos
   lda VERA_data
   sta @xpos+1
   lda @xpos
   clc
   sbc #1
   sta @xpos
   lda @xpos+1
   sbc #0
   bmi @return
   sta @xpos+1
   jsr __sprattr
   lda VERA_data
   lda VERA_data
   lda @xpos
   sta VERA_data
   lda @xpos+1
   sta VERA_data
@return:
   rts

move_sprite_down:   ; A: sprite index
   bra @start
@ypos: .word 0
@start:
   jsr __sprattr
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda VERA_data
   sta @ypos
   lda VERA_data
   sta @ypos+1
   lda @ypos
   clc
   adc #1
   sta @ypos
   lda @ypos+1
   adc #0
   sta @ypos+1
   jsr __sprattr
   lda VERA_data
   lda VERA_data
   lda @ypos
   sta VERA_data
   lda @ypos+1
   sta VERA_data
   rts

move_sprite_up:   ; A: sprite index
   bra @start
@ypos: .word 0
@start:
   jsr __sprattr
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda VERA_data
   sta @ypos
   lda VERA_data
   sta @ypos+1
   lda @ypos
   clc
   sbc #1
   sta @ypos
   lda @ypos+1
   sbc #0
   bmi @return
   sta @ypos+1
   jsr __sprattr
   lda VERA_data
   lda VERA_data
   lda @ypos
   sta VERA_data
   lda @ypos+1
   sta VERA_data
@return:
   rts


.endif
