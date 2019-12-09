.ifndef FIREBALL_INC
FIREBALL_INC = 1

.include "sprite.asm"

FIREBALL_TICK_MOVE = 2

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
   bne @check_ymin
   lda fireball_xpos+1
   cmp #>FIREBALL_TEST_X_MIN
   bne @check_ymin
   lda fireball_ypos
   cmp #<FIREBALL_TEST_Y_MIN_V
   bne @move_n
   lda fireball_ypos+1
   cmp #>FIREBALL_TEST_Y_MIN_V
   bne @move_n
   bra @move_ne
@move_n:
   lda #FIREBALL_V_FRAME
   ldx fireball_idx
   ldy #2
   jsr sprite_frame
   lda fireball_idx
   ldx #FIREBALL_TICK_MOVE
   jsr move_sprite_up
   jmp @return
@move_ne:
   lda #FIREBALL_D_FRAME
   ldx fireball_idx
   ldy #2
   jsr sprite_frame
   lda fireball_idx
   ldx #FIREBALL_TICK_MOVE
   jsr move_sprite_up
   lda fireball_idx
   ldx #FIREBALL_TICK_MOVE
   jsr move_sprite_right
   jmp @return
@check_ymin:
   lda fireball_ypos
   cmp #<FIREBALL_TEST_Y_MIN
   bne @check_xmax
   lda fireball_ypos+1
   cmp #>FIREBALL_TEST_Y_MIN
   bne @check_xmax
   lda fireball_xpos
   cmp #<FIREBALL_TEST_X_MAX_H
   bne @move_e
   lda fireball_xpos+1
   cmp #>FIREBALL_TEST_X_MAX_H
   bne @move_e
   bra @move_se
@move_e:
   lda #FIREBALL_H_FRAME
   ldx fireball_idx
   ldy #0
   jsr sprite_frame
   lda fireball_idx
   ldx #FIREBALL_TICK_MOVE
   jsr move_sprite_right
   jmp @return
@move_se:
   lda #FIREBALL_D_FRAME
   ldx fireball_idx
   ldy #0
   jsr sprite_frame
   lda fireball_idx
   ldx #FIREBALL_TICK_MOVE
   jsr move_sprite_down
   lda fireball_idx
   ldx #FIREBALL_TICK_MOVE
   jsr move_sprite_right
   jmp @return
@check_xmax:
   lda fireball_xpos
   cmp #<FIREBALL_TEST_X_MAX
   bne @check_ymax
   lda fireball_xpos+1
   cmp #>FIREBALL_TEST_X_MAX
   bne @check_ymax
   lda fireball_ypos
   cmp #<FIREBALL_TEST_Y_MAX_V
   bne @move_s
   lda fireball_ypos+1
   cmp #>FIREBALL_TEST_Y_MAX_V
   bne @move_s
   bra @move_sw
@move_s:
   lda #FIREBALL_V_FRAME
   ldx fireball_idx
   ldy #0
   jsr sprite_frame
   lda fireball_idx
   ldx #FIREBALL_TICK_MOVE
   jsr move_sprite_down
   jmp @return
@move_sw:
   lda #FIREBALL_D_FRAME
   ldx fireball_idx
   ldy #1
   jsr sprite_frame
   lda fireball_idx
   ldx #FIREBALL_TICK_MOVE
   jsr move_sprite_down
   lda fireball_idx
   ldx #FIREBALL_TICK_MOVE
   jsr move_sprite_left
   jmp @return
@check_ymax:
   lda fireball_ypos
   cmp #<FIREBALL_TEST_Y_MAX
   bne @check_ne
   lda fireball_ypos+1
   cmp #>FIREBALL_TEST_Y_MAX
   bne @check_ne
   lda fireball_xpos
   cmp #<FIREBALL_TEST_X_MIN_H
   bne @move_w
   lda fireball_xpos+1
   cmp #>FIREBALL_TEST_X_MIN_H
   bne @move_w
   bra @move_nw
@move_w:
   lda #FIREBALL_H_FRAME
   ldx fireball_idx
   ldy #1
   jsr sprite_frame
   lda fireball_idx
   ldx #FIREBALL_TICK_MOVE
   jsr move_sprite_left
   jmp @return
@move_nw:
   lda #FIREBALL_D_FRAME
   ldx fireball_idx
   ldy #3
   jsr sprite_frame
   lda fireball_idx
   ldx #FIREBALL_TICK_MOVE
   jsr move_sprite_up
   lda fireball_idx
   ldx #FIREBALL_TICK_MOVE
   jsr move_sprite_left
   jmp @return
@check_ne:
   sec
   lda fireball_xpos
   sbc #<FIREBALL_TEST_X_MIN_H
   lda fireball_xpos+1
   sbc #>FIREBALL_TEST_X_MIN_H
   bpl @check_se
   sec
   lda fireball_ypos
   sbc #<FIREBALL_TEST_Y_MIN_V
   lda fireball_ypos+1
   sbc #>FIREBALL_TEST_Y_MIN_V
   bpl @move_nw
   jmp @move_ne
@check_se:
   sec
   lda fireball_ypos
   sbc #<FIREBALL_TEST_Y_MIN_V
   lda fireball_ypos+1
   sbc #>FIREBALL_TEST_Y_MIN_V
   bpl @jmp_move_sw
   jmp @move_se
@jmp_move_sw:
   jmp @move_sw
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
