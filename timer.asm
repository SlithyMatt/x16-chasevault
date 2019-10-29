.ifndef TIMER_INC
TIMER_INC = 1

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


timer:      .word 0
timervec:   .word $0000

timer_tick:
   lda timer
   bne @dec_timer
   lda timer+1
   bne @dec_timer
   jmp timer_done
@dec_timer:
   dec timer
   bpl @check_timer
   dec timer+1
@check_timer:
   lda timer
   bne timer_done
   lda timer+1
   bne timer_done
   jmp (timervec)
timer_done:
   rts


.endif
