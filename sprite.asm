.ifndef SPRITE_INC
SPRITE_INC = 1

.include "x16.inc"
.include "tilelib.asm"
.include "debug.asm"
.include "globals.asm"

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
                  ; Y: flip (0: none, 1: H, 2: V, 3: H&V)
   asl
   asl
   pha
   txa
   jsr __sprattr
   pla
   clc
   adc #<(VRAM_SPRITES >> 5)
   sta VERA_data0
   lda #0
   adc #>(VRAM_SPRITES >> 5)
   sta VERA_data0
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   tya
   ora #$0C
   sta VERA_data0
   rts

tile_collision: .byte 0

sprite_getpos: ; Input:
               ; A: sprite index
               ; X: tile layer (0,1)
               ; Output:
               ; A: tile overlap (n:ne:e:se:s:sw:w:nw)
               ; X: tile x
               ; Y: tile y
               ; tile_collision: 1 if sprite collided, 0 otherwise
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
   stz tile_collision
   stz @overlap
   ldx #4
   stx @halfwidth
   stx @halfheight
   jsr __sprattr
   lda VERA_data0 ; ignore
   lda VERA_data0 ; ignore
   lda VERA_data0
   sta @xpos
   lda VERA_data0
   sta @xpos+1
   lda VERA_data0
   sta @ypos
   lda VERA_data0
   sta @ypos+1
   lda VERA_data0 ; ignore
   lda VERA_data0
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
   sec
   sbc @halfwidth
   sta @xpos+1
   cpx @xpos+1
   bmi @test_north   ; entire width of sprite inside tile
   beq @test_north
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
   sec
   sbc @halfheight
   sta @ypos+1
   cpy @ypos+1
   bmi @return       ; entire height of sprite inside tile
   beq @return
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
   dec @halfwidth
   dec @halfwidth
   dec @halfwidth
   dec @halfheight
   dec @halfheight
   dec @halfheight
   txa
   sec
   sbc @xpos+1
   cmp @halfwidth
   bpl @pull_output
   tya
   sec
   sbc @ypos+1
   cmp @halfheight
   bpl @pull_output
   lda #1
   sta tile_collision
@pull_output:
   lda @overlap
   ply
   plx
   rts

move_sprite_right:   ; A: sprite index
                     ; X: pixels
   bra @start
@xpos: .word 0
@start:
   pha
   phx
   jsr __sprattr
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   sta @xpos
   lda VERA_data0
   sta @xpos+1
   plx
   txa
   clc
   adc @xpos
   sta @xpos
   lda @xpos+1
   adc #0
   sta @xpos+1
   pla
   jsr __sprattr
   lda VERA_data0
   lda VERA_data0
   lda @xpos
   sta VERA_data0
   lda @xpos+1
   sta VERA_data0
   rts

move_sprite_left:    ; A: sprite index
                     ; X: pixels
   bra @start
@xpos: .word 0
@pixels: .byte 0
@start:
   pha
   stx @pixels
   jsr __sprattr
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   sta @xpos
   lda VERA_data0
   sta @xpos+1
   lda @xpos
   sec
   sbc @pixels
   sta @xpos
   lda @xpos+1
   sbc #0
   bmi @return
   sta @xpos+1
   pla
   jsr __sprattr
   lda VERA_data0
   lda VERA_data0
   lda @xpos
   sta VERA_data0
   lda @xpos+1
   sta VERA_data0
@return:
   rts

move_sprite_down:   ; A: sprite index
                     ; X: pixels
   bra @start
@ypos: .word 0
@start:
   pha
   phx
   jsr __sprattr
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   sta @ypos
   lda VERA_data0
   sta @ypos+1
   plx
   txa
   clc
   adc @ypos
   sta @ypos
   lda @ypos+1
   adc #0
   sta @ypos+1
   pla
   jsr __sprattr
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   lda @ypos
   sta VERA_data0
   lda @ypos+1
   sta VERA_data0
   rts

move_sprite_up:   ; A: sprite index
                  ; X: pixels
   bra @start
@ypos: .word 0
@pixels: .byte 0
@start:
   pha
   stx @pixels
   jsr __sprattr
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   sta @ypos
   lda VERA_data0
   sta @ypos+1
   lda @ypos
   sec
   sbc @pixels
   sta @ypos
   lda @ypos+1
   sbc #0
   bmi @return
   sta @ypos+1
   pla
   jsr __sprattr
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   lda @ypos
   sta VERA_data0
   lda @ypos+1
   sta VERA_data0
@return:
   rts

; Macro: SPRITE_GET_SCREEN_POS
; Input:
;  idx_addr: address of byte containing sprite index
;  xpos_addr: address of writable word
;  ypos_addr: address of writable word
; Output:
;  A: z-depth (0=disabled)
;  xpos_addr: address of word containing sprite X position
;  ypos_addr: address of word containing sprite Y position
.macro SPRITE_GET_SCREEN_POS idx_addr, xpos_addr, ypos_addr
   lda idx_addr
   jsr __sprite_get_screen_pos
   ldx __sprite_sp_x
   stx xpos_addr
   ldx __sprite_sp_x+1
   stx xpos_addr+1
   ldx __sprite_sp_y
   stx ypos_addr
   ldx __sprite_sp_y+1
   stx ypos_addr+1
.endmacro

__sprite_sp_x: .word 0
__sprite_sp_y: .word 0

__sprite_get_screen_pos:   ; Input: A: sprite index
                           ; Output:
                           ;  A: z-depth
                           ;  __sprite_sp_x: sprite X position
                           ;  __sprite_sp_y: sprite Y position
   jsr __sprattr
   lda VERA_data0  ; ignore
   lda VERA_data0  ; ignore
   lda VERA_data0
   sta __sprite_sp_x
   lda VERA_data0
   sta __sprite_sp_x+1
   lda VERA_data0
   sta __sprite_sp_y
   lda VERA_data0
   sta __sprite_sp_y+1
   lda VERA_data0
   and #$0C
   lsr
   lsr
   rts


; Macro: SPRITE_CHECK_BOX
; Input:
;  max: Maximum pixels in either direction between positions
;  x1_addr: address of word containing X coordinate of position 1
;  y1_addr: address of word containing Y coordinate of position 1
;  x2_addr: address of word containing X coordinate of position 2
;  y2_addr: address of word containing Y coordinate of position 2
; Output:
;  A: 0=outside box; 1: inside box
.macro SPRITE_CHECK_BOX max, x1_addr, y1_addr, x2_addr, y2_addr
   lda x1_addr
   sta __sprite_cb_x1
   lda x1_addr+1
   sta __sprite_cb_x1+1
   lda y1_addr
   sta __sprite_cb_y1
   lda y1_addr+1
   sta __sprite_cb_y1+1
   lda x2_addr
   sta __sprite_cb_x2
   lda x2_addr+1
   sta __sprite_cb_x2+1
   lda y2_addr
   sta __sprite_cb_y2
   lda y2_addr+1
   sta __sprite_cb_y2+1
   lda #max
   jsr __sprite_check_box
.endmacro

__sprite_cb_x1:     .word 0
__sprite_cb_y1:     .word 0
__sprite_cb_x2:     .word 0
__sprite_cb_y2:     .word 0

__sprite_check_box:  ; Input:
                     ;  A: Max pixels in either direction between positions
                     ;  __sprite_cb_x1: X coordinate of position 1
                     ;  __sprite_cb_y1: X coordinate of position 1
                     ;  __sprite_cb_x2: X coordinate of position 2
                     ;  __sprite_cb_y1: X coordinate of position 2
                     ; Output:
                     ;  A: 0=outside box; 1: inside box
   bra @start
@max:    .byte 0
@minx:   .word 0
@miny:   .word 0
@maxx:   .word 0
@maxy:   .word 0
@start:
   sta @max
   ldx #0
   sec
   lda __sprite_cb_x2
   sbc @max
   sta @minx
   lda __sprite_cb_x2+1
   sbc #0
   sta @minx+1
   sec
   lda __sprite_cb_y2
   sbc @max
   sta @miny
   lda __sprite_cb_y2+1
   sbc #0
   sta @miny+1
   inc @max
   clc
   lda __sprite_cb_x2
   adc @max
   sta @maxx
   lda __sprite_cb_x2+1
   adc #0
   sta @maxx+1
   clc
   lda __sprite_cb_y2
   adc @max
   sta @maxy
   lda __sprite_cb_y2+1
   adc #0
   sta @maxy+1
   lda __sprite_cb_x1
   cmp @minx
   lda __sprite_cb_x1+1
   sbc @minx+1
   bmi @outside
   lda __sprite_cb_y1
   cmp @miny
   lda __sprite_cb_y1+1
   sbc @miny+1
   bmi @outside
   lda @maxx
   cmp __sprite_cb_x1
   lda @maxx+1
   sbc __sprite_cb_x1+1
   bmi @outside
   lda @maxy
   cmp __sprite_cb_y1
   lda @maxy+1
   sbc __sprite_cb_y1+1
   bmi @outside
   lda #1
   bra @return
@outside:
   lda #0
   bra @return
@return:
   rts

sprite_disable:   ; A: sprite index
   jsr __sprattr
   lda #<(VRAM_TILES >> 5)
   sta VERA_data0  ; set to black tile
   lda #>(VRAM_TILES >> 5)
   sta VERA_data0
   lda VERA_data0  ; leave position alone
   lda VERA_data0
   lda VERA_data0
   lda VERA_data0
   stz VERA_data0  ; disable
   rts

sprite_set_po: ;  A: sprite index
               ;  X: palette offset
   jsr __sprattr
   lda VERA_data0 ; ignore
   lda VERA_data0 ; ignore
   lda VERA_data0 ; ignore
   lda VERA_data0 ; ignore
   lda VERA_data0 ; ignore
   lda VERA_data0 ; ignore
   lda VERA_data0 ; ignore
   txa
   ora #$50
   sta VERA_data0
   rts

sprite_setpos: ; A: Bit 7: tile layer, Bits 6-0: sprite index
               ; X: tile x
               ; Y: tile y
   bra @start
@xpos: .word 0
@ypos: .word 0
@start:
   pha
   stx @xpos
   stz @xpos+1
   asl @xpos
   rol @xpos+1
   asl @xpos
   rol @xpos+1
   asl @xpos
   rol @xpos+1
   sty @ypos
   stz @ypos+1
   asl @ypos
   rol @ypos+1
   asl @ypos
   rol @ypos+1
   asl @ypos
   rol @ypos+1
   and #$80
   bne @layer1
   lda VERA_L0_tilebase
   bra @get_regs
@layer1:
   lda VERA_L1_tilebase
@get_regs:
   pha
   bit #$02
   beq @check_tilew
   asl @ypos
   rol @ypos+1
@check_tilew:
   pla
   bit #$01
   beq @move_sprite
   asl @xpos
   rol @xpos+1
@move_sprite:
   pla
   and #$7F
   jsr __sprattr
   lda VERA_data0 ; ignore
   lda VERA_data0
   lda @xpos
   sta VERA_data0
   lda @xpos+1
   sta VERA_data0
   lda @ypos
   sta VERA_data0
   lda @ypos+1
   sta VERA_data0
   rts


.macro SPRITE_SET_SCREEN_POS index_addr, xpos_addr, ypos_addr
                           ; Input:
                           ;  idx_addr: address of byte containing sprite index
                           ;  xpos_addr: address of word containing X position
                           ;  ypos_addr: address of word containing Y position
   lda index_addr
   jsr __sprattr
   lda VERA_data0 ; use current frame for now
   lda VERA_data0
   lda xpos_addr
   sta VERA_data0
   lda xpos_addr+1
   sta VERA_data0
   lda ypos_addr
   sta VERA_data0
   lda ypos_addr+1
   sta VERA_data0
.endmacro

.endif
