.ifndef FRUIT_INC
FRUIT_INC = 1

FRUIT_START_X = 9
FRUIT_START_Y = 5

fruit: .byte 0 ; 7:3 (TBD) | 2 - moving | 1:0 - direction
;                                         0:R,1:L,2:D,3:U

FRUIT_MOVING   =  $04
FRUIT_DIR      =  $03

fruit_tick:
   lda pellets
   cmp show_fruit
   bmi @check_move
   jmp @return
@check_move:


@return:
   rts

.endif
