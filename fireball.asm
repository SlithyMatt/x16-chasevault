.ifndef FIREBALL_INC
FIREBALL_INC = 1

.include "sprite.asm"

FIREBALL_TICK_MOVE = 4

FIREBALL_H_FRAME = 31
FIREBALL_V_FRAME = 30
FIREBALL_D_FRAME = 32


; TODO - delete
FIREBALL_TEST_X_MIN = 56
FIREBALL_TEST_X_MIN_H = 112
FIREBALL_TEST_X_MAX_H = 192
FIREBALL_TEST_X_MAX = 248
FIREBALL_TEST_Y_MIN = 16
FIREBALL_TEST_Y_MIN_V = 72
FIREBALL_TEST_Y_MAX_V = 152
FIREBALL_TEST_Y_MAX = 208

fireball_idx: .byte 0
fireball_xpos: .word 0
fireball_ypos: .word 0

fireball_move:
   sta fireball_idx
   SPRITE_SCREEN_POS fireball_idx, fireball_xpos, fireball_ypos
   lda fireball_xpos
   cmp #<FIREBALL_TEST_X_MIN
   bne @check_xmax
   lda fireball_xpos+1
   cmp #>FIREBALL_TEST_X_MIN
   bne @check_xmax
   lda fireball_ypos
   cmp #<FIREBALL_TEST_Y_MIN_V
   bne @check_ymin
   lda fireball_ypos+1
   cmp #>FIREBALL_TEST_Y_MIN_V
   bne @check_ymin
   lda #FIREBALL_D_FRAME
   ldx fireball_idx
   ldy #2
   jsr sprite_frame
   jmp @move_ne
@check_ymin:

@check_xmax:

@move_ne:
   lda fireball_idx
   ldx #FIREBALL_TICK_MOVE
   jsr move_sprite_up
   jsr move_sprite_right
   bra @return

@return:
   rts

fireball_tick:
   lda #FIREBALL1_idx
   jsr fireball_move
   lda #FIREBALL2_idx
   jsr fireball_move
   lda #FIREBALL3_idx
   jsr fireball_move
   lda #FIREBALL4_idx
   jsr fireball_move
@return:
   rts


.endif
