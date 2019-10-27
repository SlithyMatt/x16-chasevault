.ifndef VSYNC_INC
VSYNC_INC = 1

vsync_trig: .byte 0

check_vsync:
   lda vsync_trig
   beq @done

   ; VSYNC has occurred, handle


   lda #0
   sta vsync_trig
@done:
   rts

.endif
