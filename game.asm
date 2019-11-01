.ifndef GAME_INC
GAME_INC = 1

.include "x16.inc"
.include "player.asm"
.include "timer.asm"
.include "joystick.asm"
.include "superimpose.asm"
.include "debug.asm"

; timing
frame_num:  .byte 0

init_game:
   ; TODO: Disable mouse
   jsr regenerate
   rts

game_tick:        ; called after every VSYNC detected (60 Hz)
   inc frame_num
   lda frame_num
   cmp #60
   bne @tick
   lda #0
   sta frame_num
@tick:
   jsr timer_tick
   jsr joystick_tick
   jsr player_tick
   jsr enemy_tick
   ; TODO add other tick handlers

   lda pellets
   bne @end
   jsr complete_level
@end:
   rts


complete_level:
   ; TODO remove remaining barriers
   ; TODO announce
   ; TODO add score
   rts


.endif
