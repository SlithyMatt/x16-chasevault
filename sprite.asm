.ifndef SPRITE_INC
SPRITE_INC = 1

.include "x16.inc"
.include "tilelib.asm"
.include "debug.asm"

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
                  ; Y: flip (0: none, 1: H, 2: V, 3: H&V)
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
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda VERA_data
   tya
   ora #$0C
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
@vars:
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
   ldx #(@start-@vars-1)
@init:
   stz @vars,x
   dex
   bpl @init
   ldx #4
   stx @halfwidth
   stx @halfheight
   jsr __sprattr
   lda VERA_data ; ignore
   lda VERA_data ; ignore
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
   lda VERA_data
   lda VERA_data
   lda VERA_data
   sta @xpos
   lda VERA_data
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
   lda VERA_data
   lda VERA_data
   lda @xpos
   sta VERA_data
   lda @xpos+1
   sta VERA_data
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
   lda VERA_data
   lda VERA_data
   lda VERA_data
   sta @xpos
   lda VERA_data
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
   lda VERA_data
   lda VERA_data
   lda @xpos
   sta VERA_data
   lda @xpos+1
   sta VERA_data
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
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda VERA_data
   sta @ypos
   lda VERA_data
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
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda @ypos
   sta VERA_data
   lda @ypos+1
   sta VERA_data
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
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda VERA_data
   sta @ypos
   lda VERA_data
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
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda VERA_data
   lda @ypos
   sta VERA_data
   lda @ypos+1
   sta VERA_data
@return:
   rts

; Macro: SPRITE_SCREEN_POS
; Input:
;  idx_addr: address of byte containing sprite index
;  xpos_addr: address of writable word
;  ypos_addr: address of writable word
; Output:
;  A: z-depth (0=disabled)
;  xpos_addr: address of word containing sprite X position
;  ypos_addr: address of word containing sprite Y position
.macro SPRITE_SCREEN_POS idx_addr, xpos_addr, ypos_addr
   lda idx_addr
   jsr __sprite_screen_pos
   plx
   stx ypos_addr+1
   plx
   stx ypos_addr
   plx
   stx xpos_addr+1
   plx
   stx xpos_addr
.endmacro

__sprite_screen_pos: ; Input: A: sprite index
                     ; Output:
                     ;  A: z-depth
                     ;  Stack: <x,>x,<y,>y
   bra @start
@sp: .word 0
@start:
   plx
   stx @sp
   plx
   stx @sp+1
   jsr __sprattr
   lda VERA_data  ; ignore
   lda VERA_data  ; ignore
   lda VERA_data
   pha
   lda VERA_data
   pha
   lda VERA_data
   pha
   lda VERA_data
   pha
   lda VERA_data
   and #$0C
   lsr
   lsr
   ldx @sp+1
   phx
   ldx @sp
   phx
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
   lda y2_addr+1
   pha
   lda y2_addr
   pha
   lda x2_addr+1
   pha
   lda x2_addr
   pha
   lda y1_addr+1
   pha
   lda y1_addr
   pha
   lda x1_addr+1
   pha
   lda x1_addr
   pha
   lda #max
   jsr __sprite_check_box
.endmacro

__sprite_check_box:  ; Input:
                     ;  A: Max pixels in either direction between positions
                     ;  Stack: >y2,<y2,>x2,<x2,>y1,<y1,>x1,<x1
                     ; Output:
                     ;  A: 0=outside box; 1: inside box
   bra @start
@max:    .byte 0
@x1:     .word 0
@y1:     .word 0
@x2:     .word 0
@y2:     .word 0
@minx:   .word 0
@miny:   .word 0
@maxx:   .word 0
@maxy:   .word 0
@sp:     .word 0
@start:
   plx
   stx @sp
   plx
   stx @sp+1
   sta @max
   ldx #0
@pull_loop:
   pla
   sta @x1,x
   inx
   cpx #8
   bne @pull_loop
   sec
   lda @x2
   sbc @max
   sta @minx
   lda @x2+1
   sbc #0
   sta @minx+1
   sec
   lda @y2
   sbc @max
   sta @miny
   lda @y2+1
   sbc #0
   sta @miny+1
   inc @max
   clc
   lda @x2
   adc @max
   sta @maxx
   lda @x2+1
   adc #0
   sta @maxx+1
   clc
   lda @y2
   adc @max
   sta @maxy
   lda @y2+1
   adc #0
   sta @maxy+1
   lda @x1
   cmp @minx
   lda @x1+1
   sbc @minx+1
   bmi @outside
   lda @y1
   cmp @miny
   lda @y1+1
   sbc @miny+1
   bmi @outside
   lda @maxx
   cmp @x1
   lda @maxx+1
   sbc @x1+1
   bmi @outside
   lda @maxy
   cmp @y1
   lda @maxy+1
   sbc @y1+1
   bmi @outside
   lda #1
   bra @return
@outside:
   lda #0
   bra @return
@return:
   ldx @sp+1
   phx
   ldx @sp
   phx
   rts


.endif
