.ifndef FIREBALL_INC
FIREBALL_INC = 1

.include "sprite.asm"
.include "debug.asm"

FIREBALL_H_FRAME = 31
FIREBALL_V_FRAME = 30
FIREBALL_D_FRAME = 32

fireball1:
   .byte FIREBALL1_idx
   .byte 0     ; Bits 7-2: TBD | Bit 1: moving | Bit 0: on screen
   .byte 0,0   ; x,y vector

fireball2:
   .byte FIREBALL2_idx
   .byte 0     ; Bits 7-2: TBD | Bit 1: moving | Bit 0: on screen
   .byte 0,0   ; x,y vector

fireball3:
   .byte FIREBALL3_idx
   .byte 0     ; Bits 7-2: TBD | Bit 1: moving | Bit 0: on screen
   .byte 0,0   ; x,y vector

fireball4:
   .byte FIREBALL4_idx
   .byte 0     ; Bits 7-2: TBD | Bit 1: moving | Bit 0: on screen
   .byte 0,0   ; x,y vector

FIREBALL_ON_SCREEN   = $01
FIREBALL_CLEAR       = $FE
FIREBALL_MOVING      = $02
FIREBALL_STOP        = $FD

__fb_start_x: .word 0
__fb_start_y: .word 0

.macro FIREBALL_AIM start_x, start_y   ; Other input: A=index offset, X/Y=vector
   pha
   phx
   asl
   asl
   inc
   tax
   lda fireball1,x
   bit #FIREBALL_ON_SCREEN
   beq :+
   plx
   pla
   bra :++
:  lda start_x
   sta __fb_start_x
   lda start_x+1
   sta __fb_start_x+1
   lda start_y
   sta __fb_start_y
   lda start_y+1
   sta __fb_start_y+1
   plx
   pla
   jsr __fireball_aim
:  nop
.endmacro

__fb_idx: .byte 0

__fireball_aim: ; A: index offset
                ; X/Y: vector
                ; __fb_start_x,__fb_start_y: starting screen position
   pha
   jsr __fb_normalize
   pla
   phx
   asl
   asl
   tax
   lda fireball1,x
   sta __fb_idx
   inx
   lda fireball1,x
   ora #FIREBALL_ON_SCREEN
   sta fireball1,x
   inx
   pla
   sta fireball1,x
   inx
   tya
   sta fireball1,x
   SPRITE_SET_SCREEN_POS __fb_idx, __fb_start_x, __fb_start_y
   rts

__fb_normalize:   ; Input: X/Y: raw vector
                  ; Output: X/Y: normalized vector, magnitude ~= 4
   bra @start
@rawx: .byte 0
@rawy: .byte 0
@start:
   stx @rawx
   sty @rawy
   DEBUG_BYTE @rawx, 0,0
   DEBUG_BYTE @rawy, 0,1
   cpx #0
   bpl @eastern
   jmp @western
@eastern:
   cpy #0
   bpl @southeastern
   jmp @northeastern
@southeastern:
   sec
   lda @rawx
   sbc @rawy
   bne @check_se_east
   ldx #3
   ldy #3
   jmp @return
@check_se_east:
   bmi @check_se_south
   cmp @rawy
   bmi @se_3_2
   sec
   sbc @rawy
   bmi @se_4_1
   ldx #4
   ldy #0
   jmp @return
@se_4_1:
   ldx #4
   ldy #1
   jmp @return
@se_3_2:
   ldx #3
   ldy #2
   jmp @return
@check_se_south:
   lda @rawy
   sec
   sbc @rawx
   cmp @rawx
   bmi @se_2_3
   sec
   sbc @rawx
   bmi @se_1_4
   ldx #0
   ldy #4
   jmp @return
@se_1_4:
   ldx #1
   ldy #4
   jmp @return
@se_2_3:
   ldx #2
   ldy #3
   jmp @return
@northeastern:
   lda #0
   sec
   sbc @rawy
   sta @rawy
   sec
   lda @rawx
   sbc @rawy
   bne @check_ne_east
   ldx #3
   ldy #(256-3)
   jmp @return
@check_ne_east:
   bmi @check_ne_north
   cmp @rawy
   bmi @ne_3_2
   sec
   sbc @rawy
   bmi @ne_4_1
   ldx #4
   ldy #0
   jmp @return
@ne_4_1:
   ldx #4
   ldy #(256-1)
   jmp @return
@ne_3_2:
   ldx #3
   ldy #(256-2)
   jmp @return
@check_ne_north:
   lda @rawy
   sec
   sbc @rawx
   cmp @rawx
   bmi @ne_2_3
   sec
   sbc @rawx
   bmi @ne_1_4
   ldx #0
   ldy #(256-4)
   jmp @return
@ne_1_4:
   ldx #1
   ldy #(256-4)
   jmp @return
@ne_2_3:
   ldx #2
   ldy #(256-3)
   jmp @return
@western:
   sec
   lda #0
   sbc @rawx
   sta @rawx
   cpy #0
   bpl @southwestern
   jmp @northwestern
@southwestern:
   sec
   lda @rawx
   sbc @rawy
   bne @check_sw_west
   ldx #(256-3)
   ldy #3
   jmp @return
@check_sw_west:
   bmi @check_sw_south
   cmp @rawy
   bmi @sw_3_2
   sec
   sbc @rawy
   bmi @sw_4_1
   ldx #(256-4)
   ldy #0
   jmp @return
@sw_4_1:
   ldx #(256-4)
   ldy #1
   jmp @return
@sw_3_2:
   ldx #(256-3)
   ldy #2
   jmp @return
@check_sw_south:
   lda @rawy
   sec
   sbc @rawx
   cmp @rawx
   bmi @sw_2_3
   sec
   sbc @rawx
   bmi @sw_1_4
   ldx #0
   ldy #4
   jmp @return
@sw_1_4:
   ldx #(256-1)
   ldy #4
   jmp @return
@sw_2_3:
   ldx #(256-2)
   ldy #3
   jmp @return
@northwestern:
   lda #0
   sec
   sbc @rawy
   sta @rawy
   sec
   lda @rawx
   sbc @rawy
   bne @check_nw_west
   ldx #(256-3)
   ldy #(256-3)
   jmp @return
@check_nw_west:
   bmi @check_nw_north
   cmp @rawy
   bmi @nw_3_2
   sec
   sbc @rawy
   bmi @nw_4_1
   ldx #(256-4)
   ldy #0
   jmp @return
@nw_4_1:
   ldx #(256-4)
   ldy #(256-1)
   jmp @return
@nw_3_2:
   ldx #(256-3)
   ldy #(256-2)
   jmp @return
@check_nw_north:
   lda @rawy
   sec
   sbc @rawx
   cmp @rawx
   bmi @nw_2_3
   sec
   sbc @rawx
   bmi @nw_1_4
   ldx #0
   ldy #(256-4)
   jmp @return
@nw_1_4:
   ldx #(256-1)
   ldy #(256-4)
   jmp @return
@nw_2_3:
   ldx #(256-2)
   ldy #(256-3)
@return:
   rts

fireball_tick:
   bra @start
@offset: .byte 0
@status: .byte 0
@move_x: .byte 0
@move_y: .byte 0
@frame: .byte 0
@index: .byte 0
@flip:  .byte 0
@start:
   stz @offset
@loop:
   lda @offset
   cmp num_fireballs
   bne @get_params
   jmp @return
@get_params:
   inc @offset
   asl
   asl
   tax
   lda fireball1,x
   sta @index
   inx
   lda fireball1,x
   sta @status
   bit #FIREBALL_ON_SCREEN
   bne @check_vector
   lda @index
   jsr sprite_disable
   bra @loop
@check_vector:
   inx
   lda fireball1,x
   sta @move_x
   inx
   lda fireball1,x
   sta @move_y
   DEBUG_BYTE @move_x, 3,0
   DEBUG_BYTE @move_y, 3,1
   lda @move_x
   cmp #4
   bne @check_west
   lda #FIREBALL_H_FRAME
   sta @frame
   stz @flip
   jmp @set_frame
@check_west:
   cmp #(256-4)
   bne @check_south
   lda #FIREBALL_H_FRAME
   sta @frame
   lda #H_FLIP
   sta @flip
   jmp @set_frame
@check_south:
   lda @move_y
   cmp #4
   bne @check_north
   lda #FIREBALL_V_FRAME
   sta @frame
   stz @flip
   jmp @set_frame
@check_north:
   cmp #(256-4)
   bne @check_se
   lda #FIREBALL_V_FRAME
   sta @frame
   lda #V_FLIP
   sta @flip
   jmp @set_frame
@check_se:
   lda @move_x
   bmi @check_sw
   lda @move_y
   bmi @northeast
   lda #FIREBALL_D_FRAME
   sta @frame
   stz @flip
   jmp @set_frame
@northeast:
   lda #FIREBALL_D_FRAME
   sta @frame
   lda #V_FLIP
   sta @flip
   jmp @set_frame
@check_sw:
   lda @move_y
   bmi @northwest
   lda #FIREBALL_D_FRAME
   sta @frame
   lda #H_FLIP
   sta @flip
   jmp @set_frame
@northwest:
   lda #FIREBALL_D_FRAME
   sta @frame
   lda #HV_FLIP
   sta @flip
@set_frame:
   lda @frame
   ldx @index
   ldy @flip
   jsr sprite_frame
   lda @status
   bit #FIREBALL_MOVING
   bne @move
   jmp @loop
@move:
   ldx @move_x
   bmi @move_left
   lda @index
   jsr move_sprite_right
   lda @index
   ldx #1
   jsr sprite_getpos
   cpx #SPRITE_MAX_X
   beq @off
   bra @move_down
@move_left:
   sec
   lda #0
   sbc @move_x
   tax
   lda @index
   jsr move_sprite_left
   lda @index
   ldx #1
   jsr sprite_getpos
   cpx #SPRITE_MIN_X
   beq @off
@move_down:
   ldx @move_y
   bmi @move_up
   lda @index
   jsr move_sprite_down
   lda @index
   ldx #1
   jsr sprite_getpos
   cpy #SPRITE_MAX_Y
   beq @off
   jmp @loop
@move_up:
   sec
   lda #0
   sbc @move_y
   tax
   lda @index
   jsr move_sprite_up
   lda @index
   ldx #1
   jsr sprite_getpos
   cpy #SPRITE_MIN_Y
   beq @off
   jmp @loop
@off:
   lda @offset
   dec
   jsr fireball_offscreen
   jmp @loop
@return:
   rts

fireball_visible: ; Input:  A: sprite index
                  ; Output: A: 0=not visible, 1=visible
   sec
   sbc #FIREBALL1_idx
   asl
   asl
   inc
   tax
   lda fireball1,x
   and #FIREBALL_ON_SCREEN
   rts

fireball_offscreen:  ; A: index offset
   asl
   asl
   inc
   tax
   lda fireball1,x
   and #FIREBALL_CLEAR
   sta fireball1,x
   rts

fireball_stop:
   ldx #1
   lda fireball1,x
   and #FIREBALL_STOP
   sta fireball1,x
   lda fireball2,x
   and #FIREBALL_STOP
   sta fireball2,x
   lda fireball3,x
   and #FIREBALL_STOP
   sta fireball3,x
   lda fireball4,x
   and #FIREBALL_STOP
   sta fireball4,x
   rts


fireball_move:
   ldx #1
   lda fireball1,x
   ora #FIREBALL_MOVING
   sta fireball1,x
   lda fireball2,x
   ora #FIREBALL_MOVING
   sta fireball2,x
   lda fireball3,x
   ora #FIREBALL_MOVING
   sta fireball3,x
   lda fireball4,x
   ora #FIREBALL_MOVING
   sta fireball4,x
   rts

fireball_clear:
   ldx #1
   stz fireball1,x
   stz fireball2,x
   stz fireball3,x
   stz fireball4,x
   rts

.endif
