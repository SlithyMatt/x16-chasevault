.ifndef ENEMY_INC
ENEMY_INC = 1

.include "sprite.asm"
.include "debug.asm"
.include "joystick.asm"

.ifndef PLAYER_IDX
PLAYER_IDX = 1
.endif

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

ENEMY1_TGT_X = 18
ENEMY2_TGT_X = 1
ENEMY3_TGT_X = 19
ENEMY4_TGT_X = 0
ENEMY1_TGT_Y = 0
ENEMY2_TGT_Y = 0
ENEMY3_TGT_Y = 14
ENEMY4_TGT_Y = 14

target_x:   .byte ENEMY1_TGT_X, ENEMY2_TGT_X, ENEMY3_TGT_X, ENEMY4_TGT_X
target_y:   .byte ENEMY1_TGT_Y, ENEMY2_TGT_Y, ENEMY3_TGT_Y, ENEMY4_TGT_Y

body_frames:   .byte  9, 11, 10, 12
vuln_frame:    .byte 13
eye_frames:    .byte 14, 14, 15, 15
eye_flips:     .byte $0, $1, $2, $0

ticks_vuln_rem:   .word 0
chase:            .byte 0     ; 0=scatter mode, 1=chase mode
ticks_mode_rem:   .word 420   ; ticks remaining until switch between chase and scatter
scatter_time:     .word 420
chase_time:       .word 1200

enemy_reset:
   stz ticks_vuln_rem
   stz ticks_vuln_rem+1
   jsr __enemy_scatter
   rts

__enemy_scatter:
   stz chase
   lda scatter_time
   sta ticks_mode_rem
   lda scatter_time+1
   sta ticks_mode_rem+1
   lda ENEMY1_TGT_X
   sta target_x
   lda ENEMY2_TGT_X
   sta target_x+1
   lda ENEMY3_TGT_X
   sta target_x+2
   lda ENEMY4_TGT_X
   sta target_x+3
   lda ENEMY1_TGT_Y
   sta target_y
   lda ENEMY2_TGT_Y
   sta target_y+1
   lda ENEMY3_TGT_Y
   sta target_y+2
   lda ENEMY4_TGT_Y
   sta target_y+3
   rts

enemy_set_mode_times:   ; Input:
                        ; A: scatter time, 15ths of seconds (0 to 17 seconds)
                        ; X/Y: chase time, ticks (0 to 1091-14/15 seconds)
   sta scatter_time
   asl scatter_time
   rol scatter_time+1
   asl scatter_time
   rol scatter_time+1
   stx chase_time
   sty chase_time+1
   rts

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
   lda ticks_vuln_rem+1
   cmp #0
   bne @dec_ticks
   lda ticks_vuln_rem
   beq @mode_tick
@dec_ticks:
   sec
   lda ticks_vuln_rem
   sbc #1
   sta ticks_vuln_rem
   lda ticks_vuln_rem+1
   sbc #0
   sta ticks_vuln_rem+1
   bra @start_loop
@enemy_temp: .byte 0
@sprite_idx: .byte 0
@mode_tick:
   jsr __enemy_mode_tick
@start_loop:
   ldx #0
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
   beq @move
@move:
   jsr __enemy_move
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

__enemy_mode_tick:
   lda ticks_mode_rem+1
   cmp #0
   bne @dec_ticks
   lda ticks_mode_rem
   beq @change_mode
   @dec_ticks:
   sec
   lda ticks_mode_rem
   sbc #1
   sta ticks_mode_rem
   lda ticks_mode_rem+1
   sbc #0
   sta ticks_mode_rem+1
   bra @return
@change_mode:
   lda chase
   bne @scatter
   lda #1
   sta chase
   lda chase_time
   sta ticks_mode_rem
   lda chase_time+1
   sta ticks_mode_rem+1
   jsr __enemy_chase_targets
@scatter:
   jsr __enemy_scatter
@return:
   rts

__enemy_chase_targets:
bra @start
@enemy:     .byte 0
@target_x:  .byte 0
@target_y:  .byte 0
@index:     .byte 0
@player_x:  .byte 0
@player_y:  .byte 0
@start:
   ldx #0
@loop:
   phx
   lda enemies,x
   sta @enemy
   and #$E0
   lsr
   lsr
   lsr
   lsr
   lsr
   sta @index
   lda #PLAYER_idx
   ldx #1
   jsr sprite_getpos
   stx @player_x
   sty @player_y
   ; TODO calc target position
@end_loop:
   plx
   inx
   cpx #4
   bne @loop
   rts

__enemy_move:  ; X: enemy offset (0-3)
   bra @start
@enemy:     .byte 0
@target_x:  .byte 0
@target_y:  .byte 0
@index:     .byte 0
@start:
   lda enemies,x
   sta @enemy
   lda target_x,x
   sta @target_x
   lda target_y,x
   sta @target_y
   lda #$E0
   and @enemy
   lsr
   lsr
   lsr
   lsr
   lsr
   sta @index
   ; TODO move towards target
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
