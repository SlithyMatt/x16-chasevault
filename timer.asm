.ifndef TIMER_INC
TIMER_INC = 1

.include "debug.asm"

.macro SET_TIMER ticks, vector
   lda #<ticks
   sta timer
   lda #>ticks
   sta timer+1
   lda #<vector
   sta timervec
   lda #>vector
   sta timervec+1
.endmacro


; timing
frame_num:  .byte 0
timer:      .word 0
timervec:   .word timer_done

timer_tick:
   lda timer
   bne @dec_timer
   lda timer+1
   bne @dec_timer
   jmp timer_done
@dec_timer:
   sec
   lda timer
   sbc #1
   sta timer
   lda timer+1
   sbc #0
   sta timer+1
@check_timer:
   lda timer
   bne timer_done
   lda timer+1
   bne timer_done
   jmp (timervec)
timer_done:
   rts

timer_clear:
   stz timer
   stz timer+1
   lda #<timer_done
   sta timervec
   lda #>timer_done
   sta timervec+1
   rts

timer_flush:
   stz timer
   stz timer+1
   jmp (timervec)

.endif
