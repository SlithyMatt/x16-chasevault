.ifndef GAME_INC
GAME_INC = 1

.include "x16.inc"
.include "player.asm"
.include "timer.asm"
.include "joystick.asm"
.include "superimpose.asm"


; timing
frame_num:  .byte 0

; state
level:      .byte 1
score:      .dword 0
pellets:    .byte 101
keys:       .byte 0

init_game:
   SET_TIMER 60, readygo
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
   ; TODO add other tick handlers
   rts

readygo:
   SUPERIMPOSE "ready?", 7, 9
   SET_TIMER 30, @readyoff
   jmp timer_done
@readyoff:
   SUPERIMPOSE_RESTORE
   SET_TIMER 15, @go
   jmp timer_done
@go:
   SUPERIMPOSE "go!", 8, 9
   SET_TIMER 30, @gooff
   jmp timer_done
@gooff:
   SUPERIMPOSE_RESTORE
   jsr player_animate
   jmp timer_done

.endif
