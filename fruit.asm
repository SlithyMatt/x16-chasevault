.ifndef FRUIT_INC
FRUIT_INC = 1

.include "x16.inc"
.include "tiles.inc"
.include "globals.asm"
.include "sprite.asm"
.include "tilelib.asm"
.include "superimpose.asm"

FRUIT_START_X = 9
FRUIT_START_Y = 5

FRUIT_STATUS_X = 12
FRUIT_STATUS_Y = 14

FRUIT_TICK_MOVE = 1

fruit: .byte 0   ; 7:5 (TBD) | 4 - blinking
;                3 - cleared | 2 - moving | 1:0 - direction
;                                           0:R,1:L,2:D,3:U

FRUIT_BLINKING    =  $10
FRUIT_CLEARED     =  $08
FRUIT_MOVING      =  $04
FRUIT_STOP_MASK   =  $FB
FRUIT_DIR         =  $03
FRUIT_DIR_MASK    =  $FC

FRUIT_BLINK_FRAME = 22
FRUIT_BLINK_TICKS = 10
__fruit_blink_ticks: .byte FRUIT_BLINK_TICKS

__fruit_stored_x: .byte FRUIT_START_X
__fruit_stored_y: .byte FRUIT_START_Y

__fruit_status: .byte 0
BANANA_STATUS     = $01
MANGO_STATUS      = $02
GUAVA_STATUS      = $04
GRAPEFRUIT_STATUS = $08
CARAMBOLA_STATUS  = $10
CHERRY_STATUS     = $20
APPLE_STATUS      = $40
ALL_FRUITS        = $7F


__fruit_tile_map:
.byte BANANA
.byte MANGO
.byte GUAVA
.byte GRAPEFRUIT
.byte CARAMBOLA
.byte CHERRY
.byte APPLE

__fruit_bonus_displayed: .byte 0

fruit_tick:
   bra @start
@xpos: .byte 0
@ypos: .byte 0
@dir:  .byte 0
@blocked:   .byte 0  ; bit 3: N, bit 2: S, bit 1: W, bit 0: E
@EAST_BLOCKED = $01
@WEST_BLOCKED = $02
@SOUTH_BLOCKED = $04
@NORTH_BLOCKED = $08
@start:
   lda fruit
   bit #FRUIT_CLEARED
   beq @check_blink
   jmp @return
@check_blink:
   bit #FRUIT_BLINKING
   beq @check_pellets
   dec __fruit_blink_ticks
   beq @clear
   lda #FRUIT_BLINK_FRAME
   ldx #FRUIT_idx
   ldy #0
   jsr sprite_frame
   jmp @return
@clear:
   jsr fruit_clear
   jmp @return
@check_pellets:
   lda pellets
   cmp show_fruit
   bmi @show
   lda #FRUIT_idx
   jsr sprite_disable
   jmp @return
@show:
   lda fruit_frame
   ldx #FRUIT_idx
   ldy #0
   jsr sprite_frame
   lda frame_num
   bit #1            ; only move on even frames
   beq @check_move
   jmp @return
@check_move:
   lda fruit
   bit #FRUIT_MOVING
   bne @steer
   jmp @return
@steer:
   and #FRUIT_DIR
   sta @dir
   lda #FRUIT_idx
   ldx #1
   jsr sprite_getpos
   stx @xpos
   sty @ypos
   cmp #0
   beq @check_block
   jmp @move
@check_block:
   stz @blocked
   lda @dir
   cmp #DIR_RIGHT
   bne @check_going_left
   jmp @check_east
@check_going_left:
   cmp #DIR_LEFT
   beq @check_west
   cmp #DIR_DOWN
   beq @check_south
@check_north:
   ldy @ypos
   dey
   cpy #SPRITE_MIN_Y
   beq @north_blocked
   lda #1
   ldx @xpos
   jsr get_tile
   jsr __fruit_tile_collision
   bcs @north_blocked
   lda #DIR_UP
   sta @dir
   jmp @move
@north_blocked:
   lda @blocked
   ora #@NORTH_BLOCKED
   sta @blocked
   bit #@WEST_BLOCKED
   beq @check_west
   bit #@SOUTH_BLOCKED
   beq @check_south
   jmp @check_east
@check_south:
   ldy @ypos
   iny
   cpy #SPRITE_MAX_Y
   beq @south_blocked
   lda #1
   ldx @xpos
   jsr get_tile
   jsr __fruit_tile_collision
   bcs @south_blocked
   lda #DIR_DOWN
   sta @dir
   jmp @move
@south_blocked:
   lda @blocked
   ora #@SOUTH_BLOCKED
   sta @blocked
   bit #@EAST_BLOCKED
   beq @check_east
   bit #@NORTH_BLOCKED
   beq @check_north
   jmp @check_west
@check_west:
   ldx @xpos
   dex
   cpx #SPRITE_MIN_X
   beq @west_blocked
   lda #1
   ldy @ypos
   jsr get_tile
   jsr __fruit_tile_collision
   bcs @west_blocked
   lda #DIR_LEFT
   sta @dir
   jmp @move
@west_blocked:
   lda @blocked
   ora #@WEST_BLOCKED
   sta @blocked
   bit #@SOUTH_BLOCKED
   beq @check_south
   bit #@EAST_BLOCKED
   beq @check_east
   jmp @check_north
@check_east:
   ldx @xpos
   inx
   cpx #SPRITE_MAX_X
   beq @east_blocked
   lda #1
   ldy @ypos
   jsr get_tile
   jsr __fruit_tile_collision
   bcs @east_blocked
   lda #DIR_RIGHT
   sta @dir
   jmp @move
@east_blocked:
   lda @blocked
   ora #@EAST_BLOCKED
   sta @blocked
   bit #@NORTH_BLOCKED
   bne @eb_check_west
   jmp @check_north
@eb_check_west:
   bit #@WEST_BLOCKED
   beq @check_west
   jmp @check_south
@move:
   lda fruit
   and #FRUIT_DIR_MASK
   ora @dir
   sta fruit
   lda #FRUIT_idx
   ldx #FRUIT_TICK_MOVE
   ldy @dir
   cpy #DIR_RIGHT
   beq @move_right
   cpy #DIR_LEFT
   beq @move_left
   cpy #DIR_DOWN
   beq @move_down
@move_up:
   jsr move_sprite_up
   bra @return
@move_down:
   jsr move_sprite_down
   bra @return
@move_left:
   jsr move_sprite_left
   bra @return
@move_right:
   jsr move_sprite_right
@return:
   rts

fruit_reset:
   lda #($80 | FRUIT_idx)
   ldx #FRUIT_START_X
   ldy #FRUIT_START_Y
   jsr sprite_setpos
   stz fruit
   rts

fruit_move:
   lda fruit
   ora #FRUIT_MOVING
   sta fruit
   rts

fruit_stop:
   lda fruit
   and #FRUIT_STOP_MASK
   sta fruit
   rts

fruit_blink:
   lda fruit
   ora #FRUIT_BLINKING
   sta fruit
   lda #FRUIT_BLINK_TICKS
   sta __fruit_blink_ticks
   rts

fruit_clear:
   lda #FRUIT_idx
   jsr sprite_disable
   lda fruit
   ora #FRUIT_CLEARED
   sta fruit
   rts

fruit_store_pos:
   lda #FRUIT_idx
   ldx #1
   jsr sprite_getpos
   cpx #SPRITE_MIN_X
   bmi @return
   cpx #SPRITE_MAX_X
   bpl @return
   cpy #SPRITE_MIN_Y
   bmi @return
   cpy #SPRITE_MAX_Y
   bpl @return
   stx __fruit_stored_x
   sty __fruit_stored_y
@return:
   rts

fruit_restore_pos:
   lda #($80 | FRUIT_idx)
   ldx __fruit_stored_x
   ldy __fruit_stored_y
   jsr sprite_setpos
   rts

fruit_status: ; A: 0=do not add current fruit, 1=add current fruit
   bra @start
@mask:   .byte 0
@start:
   cmp #0
   beq @check_status
   lda #BANANA_STATUS
   sta @mask
   lda fruit_frame
   sec
   sbc #BANANA_FRAME
   tax
@mask_loop:
   cpx #0
   beq @add_status
   asl @mask
   dex
   bra @mask_loop
@add_status:
   lda __fruit_status
   ora @mask
   sta __fruit_status
@check_status:
   lda #BANANA_STATUS
   sta @mask
   ldy #0
   lda #<__fruit_tile_map
   sta ZP_PTR_1
   lda #>__fruit_tile_map
   sta ZP_PTR_1+1
@status_loop:
   lda __fruit_status
   bit @mask
   beq @push_blank
   lda (ZP_PTR_1),y
   pha
   bra @next_status
@push_blank:
   lda #BLANK
   pha
@next_status:
   iny
   asl @mask
   cpy #7
   bmi @status_loop
   lda #1
   ldx #FRUIT_STATUS_X
   ldy #FRUIT_STATUS_Y
   jsr xy2vaddr
   stz VERA_ctrl
   ora #$20
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   ldx #7
@tile_loop:
   cpx #0
   beq @check_bonus
   pla
   sta VERA_data0
   dex
   bra @tile_loop
@check_bonus:
   lda __fruit_status
   cmp #ALL_FRUITS
   bne __fruit_status_return
   lda __fruit_bonus_displayed
   bne __fruit_status_return
   SUPERIMPOSE "bonus!", 7, 9
   lda #1
   sta paused
   sta refresh_req
   sta __fruit_bonus_displayed
   clc
   adc max_lives
   sta max_lives
   sta lives
   SET_TIMER 45, __fruit_bonus_done
__fruit_status_return:
   rts


__fruit_tile_collision: ; Input: X: tile index (low byte)
                        ; Output: C: set if fruit collides
   cpx #HOME_FENCE
   beq @collision
   cpx #BLANK
   beq @clear
   cpx #PELLET
   bpl @clear
@collision:
   sec
   bra @return
@clear:
   clc
@return:
   rts

__fruit_bonus_done:
   SUPERIMPOSE_RESTORE
   stz __fruit_bonus_displayed
   stz __fruit_status
   stz paused
   lda #1
   sta refresh_req
   rts

.endif
