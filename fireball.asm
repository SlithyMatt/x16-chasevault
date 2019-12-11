.ifndef FIREBALL_INC
FIREBALL_INC = 1

.include "sprite.asm"

FIREBALL_TICK_MOVE = 4

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
   bit FIREBALL_ON_SCREEN
   beq :+
   plx
   pla
   bra :++
   lda start_x
   sta __fb_start_x
   lda start_x+1
   sta __fb_start_x+1
   lda start_y
   sta __fb_start_y
   lda start_y+1
   sta __fb_start_y+1
:  plx
   pla
   jsr __fireball_aim
:  nop
.endmacro

__fb_idx: .byte 0

__fireball_aim: ; A: index offset
                ; X/Y: vector
                ; __fb_start_x,__fb_start_y: starting screen position
   phx
   asl
   asl
   tax
   lda fireball1,x
   sta __fb_idx
   inx
   lda fireball1,x
   ora #(FIREBALL_ON_SCREEN | FIREBALL_MOVING)
   sta fireball1,x
   inx
   pla
   sta fireball1,x
   inx
   tya
   sta fireball1,x
   SPRITE_SET_SCREEN_POS __fb_idx, __fb_start_x, __fb_start_y
   rts

fireball_tick:

@return:
   rts


.endif
