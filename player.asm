.ifndef PLAYER_INC
PLAYER_INC = 1

.include "sprite.asm"
.include "timer.asm"
.include "joystick.asm"

; state
player:     .byte 0 ; 7-4 (TBD) | 3:2 - direction | 1 - movable | 0 - animated
;                                 0:R,1:L,2:D,3:U

; player animation
player_frames_h: .byte 2,2,1,0,0,1,1,2
player_frames_v: .byte 4,4,3,0,0,3,3,4
player_frames_d: .byte 0,0,3,3,3,4,4,4,5,5,5,6,6,7,7,17

player_move:
   lda player
   ora #$02
   sta player
   rts

player_stop:
   lda player
   and #$FD
   sta player
   jsr player_freeze
   rts

player_animate:
   lda player
   ora #$01
   sta player
   rts

player_freeze:
   lda player
   and #$FE
   sta player
   rts

player_tick:
   lda player
   bit #$02             ; check for movable
   beq @check_animate
   and #$F3             ; clear direction
   ldx #1
   cpx joystick1_right
   bne @check_left
   bra @move
@check_left:
   cpx joystick1_left
   bne @check_down
   ora #$04
   bra @move
@check_down:
   cpx joystick1_down
   bne @check_up
   ora #$08
   bra @move
@check_up:
   cpx joystick1_up
   bne @check_animate
   ora #$0C
@move:
   ; TODO move player sprite, if possible
   ; TODO handle collision
@check_animate:
   lda player
   and #$01
   beq @done_animate
   lda frame_num
   and #$1C
   lsr
   lsr
   tax
   lda player
   and #$08
   bne @vertical
   lda player_frames_h,x
   jmp @loadframe
@vertical:
   lda player_frames_v,x
@loadframe:
   ldx #0
   jsr sprite_frame
@done_animate:
   ; TODO: other maintenance
   rts



.endif
