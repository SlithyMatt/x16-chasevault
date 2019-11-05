.ifndef ENEMY_INC
ENEMY_INC = 1

enemy_map: .byte 0,0,0,1,2,3

; Enemy status:
;  Bits 7-5: sprite index
;  Bit 4: moving
;  Bit 3: vulnerable
;  Bit 2: eyes only
;  Bit 1-0: Direction (0:R,1:L,2:D,3:U)
enemies:
enemy1:  .byte $41
enemy2:  .byte $63
enemy3:  .byte $82
enemy4:  .byte $A3
end_enemies:

body_frames:   .byte  9, 11, 10, 12
vuln_frame:    .byte 13
eye_frames:    .byte 14, 14, 15, 15
eye_flips:     .byte $0, $1, $2, $0

ticks_vuln_rem:   .word 0

make_vulnerable: ; A: 15ths of seconds (0 to 17 seconds)
   sta ticks_vuln_rem
   asl ticks_vuln_rem
   rol ticks_vuln_rem+1
   asl ticks_vuln_rem
   rol ticks_vuln_rem+1
   ldx #0
@loop:
   lda enemies,x
   bit #$04
   bne @end_loop
   ora #$08
   sta enemies,x
@end_loop:
   inx
   cpx #(end_enemies-enemies)
   bne @loop
   rts

enemy_tick:
   ;DEBUG_BYTE ticks_vuln_rem,0,0
   ldx #0
   lda ticks_vuln_rem+1
   cmp #0
   bne @dec_ticks
   lda ticks_vuln_rem
   beq @loop
@dec_ticks:
   sec
   lda ticks_vuln_rem
   sbc #1
   sta ticks_vuln_rem
   lda ticks_vuln_rem+1
   sbc #0
   sta ticks_vuln_rem+1
   bra @loop
@enemy_temp: .byte 0
@sprite_idx: .byte 0
@loop:
   phx
   lda enemies,x
   sta @enemy_temp
   lsr
   lsr
   lsr
   lsr
   lsr
   sta @sprite_idx
   lda @enemy_temp
   bit #$10
   beq @set_frame
   ; TODO: move
@set_frame:
   lda @enemy_temp
   bit #$08
   beq @check_eyes
   lda ticks_vuln_rem+1
   bne @check_ending
   lda ticks_vuln_rem
   bne @check_ending
   lda @enemy_temp
   and #$F7
   sta @enemy_temp
   bra @normal
@check_ending:
   lda ticks_vuln_rem+1
   bne @vulnerable
   lda ticks_vuln_rem
   cmp #90
   bcs @vulnerable
   bit #$08
   bne @normal    ; flash to normal frame every 8 ticks for last 1.5 seconds
@vulnerable:
   lda vuln_frame
   ldx @sprite_idx
   ldy #0
   jsr sprite_frame
   jmp @end_loop
@check_eyes:
   lda @enemy_temp
   bit #$04
   beq @normal
   and #$03
   tax
   lda eye_frames,x
   ldy eye_flips,x
   ldx @sprite_idx
   jsr sprite_frame
   jmp @end_loop
@normal:
   lda @enemy_temp
   and #$03
   tax
   lda body_frames,x
   ldx @sprite_idx
   ldy #0
   jsr sprite_frame
@end_loop:
   plx
   lda @enemy_temp
   sta enemies,x
   inx
   cpx #(end_enemies-enemies)
   beq @return
   jmp @loop
@return:
   rts

enemy_check_vuln: ; Input: X: sprite index
                  ; Output: A: 0=not vulnerable, 1=vulnerable
   ldy enemy_map,x
   lda enemies,y
   and #$08
   lsr
   lsr
   lsr
   rts

enemy_check_eyes: ; Input: X: sprite index
                  ; Output: A: 0=full body, 1=eyes only
   ldy enemy_map,x
   lda enemies,y
   and #$04
   lsr
   lsr
   rts

enemy_eaten: ; X: sprite index
   ldy enemy_map,x
   lda enemies,y
   and #$F7
   ora #$04
   sta enemies,y
   rts

.endif
