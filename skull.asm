.ifndef SKULL_INC
SKULL_INC = 1

.include "x16.inc"
.include "globals.asm"
.include "sprite.asm"
.include "fireball.asm"

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

skull_frame: ; frame |  flip
   .byte       35,      0  ; east
   .byte       36,      0
   .byte       37,      0
   .byte       36,      1
   .byte       35,      1
   .byte       39,      1
   .byte       38,      0
   .byte       39,      0 ; northeast

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
   and SKULL_EYES_CLEAR
   sta skull
   lda #SKULL_idx
   sta __skull_sprite_idx
   SPRITE_SCREEN_POS __skull_sprite_idx, __skull_pos_x, __skull_pos_y
   lda #PLAYER_idx
   sta __skull_sprite_idx
   SPRITE_SCREEN_POS __skull_sprite_idx, __skull_player_x, __skull_player_y
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
   ; reuse high bytes for dividing lines
   lda __skull_player_y
   lsr
   sta __skull_player_y+1
   lda __skull_player_x
   lsr
   sta __skull_player_x+1
   sec
   lda #0
   sbc __skull_player_x+1
   sta __skull_player_x+1
   ; determine general direction
   lda __skull_player_x
   bpl @check_east_y
   jmp @check_west
@check_east_y:
   lda __skull_player_y
   bmi @check_northeast
   sec
   sbc __skull_player_x
   cmp __skull_player_y+1
   bmi @check_southeast
@look_east:
   lda skull
   ora #SKULL_EYES_EAST
   sta skull
   jmp @check_fireballs
@check_southeast:
   cmp __skull_player_x+1
   bpl @look_southeast
   lda skull
   ora #SKULL_EYES_SOUTH
   sta skull
   jmp @check_fireballs
@look_southeast:
   lda skull
   ora #SKULL_EYES_SOUTHEAST
   sta skull
   jmp @check_fireballs
@check_northeast:
   sec
   sbc __skull_player_x
   cmp __skull_player_y+1
   bpl @look_east
   cmp __skull_player_x+1
   bpl @look_northeast
   lda skull
   ora #SKULL_EYES_NORTH
   sta skull
   jmp @check_fireballs
@look_northeast:
   lda skull
   ora #SKULL_EYES_NORTHEAST
   sta skull
   jmp @check_fireballs
@check_west:
   lda __skull_player_y
   bmi @check_northwest
   sec
   sbc __skull_player_x
   cmp __skull_player_y+1
   bmi @check_southwest
@look_west:
   lda skull
   ora #SKULL_EYES_WEST
   sta skull
   jmp @check_fireballs
@check_southwest:
   cmp __skull_player_x+1
   bpl @look_southwest
   lda skull
   ora #SKULL_EYES_SOUTH
   sta skull
   jmp @check_fireballs
@look_southwest:
   lda skull
   ora #SKULL_EYES_SOUTHWEST
   sta skull
   jmp @check_fireballs
@check_northwest:
   sec
   sbc __skull_player_x
   cmp __skull_player_y+1
   bpl @look_west
   cmp __skull_player_x+1
   bpl @look_northwest
   lda skull
   ora #SKULL_EYES_NORTH
   sta skull
   jmp @check_fireballs
@look_northwest:
   lda skull
   ora #SKULL_EYES_NORTHWEST
   sta skull
@check_fireballs:


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
   ; TODO: clear all fireballs
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

.endif
