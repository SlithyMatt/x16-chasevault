.ifndef SKULL_INC
SKULL_INC = 1

.include "x16.inc"
.include "globals.asm"
.include "sprite.asm"
.include "fireball.asm"
.include "debug.asm"

skull: .byte 0 ; Bits 7-5 (TBD) | Bit 4: moving | Bits 3-1: eye direction | Bit 0: placed

SKULL_MOVING         = $10
SKULL_STOP           = $EF
SKULL_PLACED         = $01
SKULL_EYES           = $0E
SKULL_EYES_CLEAR     = $F1
SKULL_EYES_EAST      = $00
SKULL_EYES_SOUTHEAST = $02
SKULL_EYES_SOUTH     = $04
SKULL_EYES_SOUTHWEST = $06
SKULL_EYES_WEST      = $08
SKULL_EYES_NORTHWEST = $0A
SKULL_EYES_NORTH     = $0C
SKULL_EYES_NORTHEAST = $0E

__skull_frame: ;  frame |  flip
   .byte          35,      NO_FLIP  ; east
   .byte          36,      NO_FLIP
   .byte          37,      NO_FLIP
   .byte          36,      H_FLIP
   .byte          35,      H_FLIP
   .byte          39,      H_FLIP
   .byte          38,      NO_FLIP
   .byte          39,      NO_FLIP ; northeast

__skull_path:
   .byte DIR_RIGHT, DIR_UP, DIR_RIGHT, DIR_UP, DIR_RIGHT, DIR_RIGHT, DIR_DOWN, DIR_RIGHT
   .byte DIR_DOWN, DIR_DOWN, DIR_DOWN, DIR_LEFT, DIR_DOWN, DIR_LEFT, DIR_LEFT, DIR_UP
   .byte DIR_LEFT, DIR_UP, DIR_LEFT, DIR_UP, DIR_LEFT, DIR_UP, DIR_LEFT, DIR_UP
   .byte DIR_LEFT, DIR_LEFT, DIR_DOWN, DIR_LEFT, DIR_DOWN, DIR_DOWN, DIR_DOWN, DIR_RIGHT
   .byte DIR_DOWN, DIR_RIGHT, DIR_RIGHT, DIR_UP, DIR_RIGHT, DIR_UP, DIR_RIGHT, DIR_UP
__skull_path_end:

__skull_path_idx: .byte 0

SKULL_PATH_LENGTH = __skull_path_end-__skull_path
SKULL_TICK_MOVE   = 1

__skull_sprite_idx: .byte 0
__skull_pos_x: .word 0
__skull_pos_y: .word 0
__skull_player_x: .word 0
__skull_player_y: .word 0

__skull_stored_x: .byte 0
__skull_stored_y: .byte 0

__skull_fb1_x: .byte 0
__skull_fb1_y: .byte 0
__skull_fb2_x: .byte 0
__skull_fb2_y: .byte 0
__skull_fb3_x: .byte 0
__skull_fb3_y: .byte 0
__skull_fb4_x: .byte 0
__skull_fb4_y: .byte 0


skull_tick:
   lda skull
   bit #SKULL_PLACED
   bne @set_pos
   lda #SKULL_idx
   jsr sprite_disable
   jmp @return
@set_pos:
   bit #SKULL_MOVING
   beq @get_vector
   lda frame_num
   and #$03
   bne @get_vector   ; only move every 4 frames
   ldx __skull_path_idx
   inc __skull_path_idx
   lda __skull_path_idx
   cmp #SKULL_PATH_LENGTH
   bne @get_dir
   stz __skull_path_idx
@get_dir:
   lda __skull_path,x
   cmp #DIR_RIGHT
   bne @check_left
   lda #SKULL_idx
   ldx #SKULL_TICK_MOVE
   jsr move_sprite_right
   jmp @get_vector
@check_left:
   cmp #DIR_LEFT
   bne @check_down
   lda #SKULL_idx
   ldx #SKULL_TICK_MOVE
   jsr move_sprite_left
   jmp @get_vector
@check_down:
   cmp #DIR_DOWN
   bne @check_up
   lda #SKULL_idx
   ldx #SKULL_TICK_MOVE
   jsr move_sprite_down
   jmp @get_vector
@check_up:
   cmp #DIR_UP
   bne @get_vector
   lda #SKULL_idx
   ldx #SKULL_TICK_MOVE
   jsr move_sprite_up
@get_vector:
   lda skull
   and #SKULL_EYES_CLEAR
   sta skull
   lda #SKULL_idx
   sta __skull_sprite_idx
   SPRITE_GET_SCREEN_POS __skull_sprite_idx, __skull_pos_x, __skull_pos_y
   lda #PLAYER_idx
   sta __skull_sprite_idx
   SPRITE_GET_SCREEN_POS __skull_sprite_idx, __skull_player_x, __skull_player_y
   sec
   lda __skull_player_x
   sbc __skull_pos_x
   sta __skull_player_x
   lda __skull_player_x+1
   sbc __skull_pos_x+1
   sta __skull_player_x+1
   sec
   lda __skull_player_y
   sbc __skull_pos_y
   sta __skull_player_y
   lda __skull_player_y+1
   sbc __skull_pos_y+1
   sta __skull_player_y+1
   ; divide vectors by 2 to make each component 8-bit
   lsr __skull_player_x+1
   ror __skull_player_x
   lsr __skull_player_y+1
   ror __skull_player_y
   ; reuse high bytes for dividing lines (factor of sin(22.5 deg))
   ; approximation: a = b*sin(22.5) ~= b*0.3827 ~= (b>>1)-(b>>3)
   lda __skull_player_y
   bpl @divy
   lda #0
   sec
   sbc __skull_player_y
@divy:
   lsr
   pha
   lsr
   lsr
   sta __skull_player_y+1
   pla
   sec
   sbc __skull_player_y+1
   sta __skull_player_y+1
   lda __skull_player_x
   bpl @divx
   lda #0
   sec
   sbc __skull_player_x
@divx:
   lsr
   pha
   lsr
   lsr
   sta __skull_player_x+1
   pla
   sec
   sbc __skull_player_x+1
   sta __skull_player_x+1
   ; determine general direction
   lda __skull_player_x
   bpl @check_east_y
   jmp @check_west
@check_east_y:
   lda __skull_player_y
   bmi @check_northeast
   cmp __skull_player_x+1
   bmi @look_east
   lda __skull_player_x
   cmp __skull_player_y+1
   bpl @look_southeast
   jmp @look_south
@look_east:
   lda skull
   ora #SKULL_EYES_EAST
   sta skull
   jmp @set_frame
@look_southeast:
   lda skull
   ora #SKULL_EYES_SOUTHEAST
   sta skull
   jmp @set_frame
@check_northeast:
   sec
   lda #0
   sbc __skull_player_y
   cmp __skull_player_x+1
   bmi @look_east
   lda __skull_player_x
   cmp __skull_player_y+1
   bpl @look_northeast
   jmp @look_north
@look_northeast:
   lda skull
   ora #SKULL_EYES_NORTHEAST
   sta skull
   jmp @set_frame
@check_west:
   lda __skull_player_y
   bmi @check_northwest
   lda #0
   sec
   sbc __skull_player_x
   cmp __skull_player_y+1
   bpl @check_southwest
@look_south:
   lda skull
   ora #SKULL_EYES_SOUTH
   sta skull
   jmp @set_frame
@check_southwest:
   lda __skull_player_y
   cmp __skull_player_x+1
   bpl @look_southwest
@look_west:
   lda skull
   ora #SKULL_EYES_WEST
   sta skull
   jmp @set_frame
@look_southwest:
   lda skull
   ora #SKULL_EYES_SOUTHWEST
   sta skull
   jmp @set_frame
@check_northwest:
   lda #0
   sec
   sbc __skull_player_x
   cmp __skull_player_y+1
   bmi @look_north
   lda #0
   sec
   sbc __skull_player_y
   cmp __skull_player_x+1
   bmi @look_west
@look_northwest:
   lda skull
   ora #SKULL_EYES_NORTHWEST
   sta skull
   jmp @set_frame
@look_north:
   lda skull
   ora #SKULL_EYES_NORTH
   sta skull
@set_frame:
   lda skull
   and #SKULL_EYES
   tax
   lda __skull_frame,x
   inx
   ldy __skull_frame,x
   ldx #SKULL_idx
   jsr sprite_frame
   ; set all fireball vectors
   lda __skull_player_x
   sta __skull_fb1_x
   sta __skull_fb3_x
   sec
   sbc #16
   sta __skull_fb4_x
   clc
   adc #32
   sta __skull_fb2_x
   lda __skull_player_y
   sta __skull_fb2_y
   sta __skull_fb3_y
   sta __skull_fb4_y
   sec
   sbc #16
   sta __skull_fb1_y
   ldx #0
@fireball_loop:
   cpx num_fireballs
   beq @return
   phx
   txa
   pha
   asl
   tax
   lda __skull_fb1_x,x
   ldy __skull_fb1_y,x
   tax
   pla
   FIREBALL_AIM __skull_pos_x, __skull_pos_y
   plx
   inx
   jmp @fireball_loop
@return:
   rts

skull_place:   ; A: tile layer index
               ; X: tile x
               ; Y: tile y
   clc
   ror
   ror
   ora #SKULL_idx
   jsr sprite_setpos
   lda skull
   ora #SKULL_PLACED
   sta skull
   rts

skull_clear:
   stz skull
   stz __skull_path_idx
   jsr fireball_clear
   rts

skull_move:
   lda skull
   ora #SKULL_MOVING
   sta skull
   rts

skull_stop:
   lda skull
   and #SKULL_STOP
   sta skull
   rts

skull_store_pos:
   lda #SKULL_idx
   ldx #1
   jsr sprite_getpos
   stx __skull_stored_x
   sty __skull_stored_y
   rts

skull_restore_pos:
   lda #($80 | SKULL_idx)
   ldx __skull_stored_x
   ldy __skull_stored_y
   jsr sprite_setpos
   rts

.endif
