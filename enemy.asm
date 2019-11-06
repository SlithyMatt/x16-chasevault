.ifndef ENEMY_INC
ENEMY_INC = 1

.include "tiles.inc"
.include "sprite.asm"
.include "debug.asm"
.include "joystick.asm"
.include "tilelib.asm"

.ifndef PLAYER_IDX
PLAYER_IDX = 1
.endif

enemy_map: .byte 0,0,0,1,2,3

ENEMY1_INIT = $41
ENEMY2_INIT = $63
ENEMY3_INIT = $82
ENEMY4_INIT = $A2

; Enemy status:
;  Bits 7-5: sprite index
;  Bit 4: moving
;  Bit 3: vulnerable
;  Bit 2: eyes only
;  Bit 1-0: Direction (0:R,1:L,2:D,3:U)
enemies:
enemy1:  .byte ENEMY1_INIT
enemy2:  .byte ENEMY2_INIT
enemy3:  .byte ENEMY3_INIT
enemy4:  .byte ENEMY4_INIT
end_enemies:

; last decision points  dir.  prev.
enemy_dps:  ;     X  Y  took  mode
enemy1_dp:  .byte 0, 0, 1,    0
enemy2_dp:  .byte 0, 0, 1,    0
enemy3_dp:  .byte 0, 0, 1,    0
enemy4_dp:  .byte 0, 0, 1,    0
end_enemy_dps:

ENEMY1_TGT_X = 18
ENEMY2_TGT_X = 1
ENEMY3_TGT_X = 19
ENEMY4_TGT_X = 0
ENEMY1_TGT_Y = 0
ENEMY2_TGT_Y = 0
ENEMY3_TGT_Y = 14
ENEMY4_TGT_Y = 14

ENEMY_MIN_X  = 1
ENEMY_MIN_Y  = 3
ENEMY_MAX_X  = 19
ENEMY_MAX_Y  = 12

target_x:   .byte ENEMY1_TGT_X, ENEMY2_TGT_X, ENEMY3_TGT_X, ENEMY4_TGT_X
target_y:   .byte ENEMY1_TGT_Y, ENEMY2_TGT_Y, ENEMY3_TGT_Y, ENEMY4_TGT_Y

body_frames:   .byte  9, 11, 10, 12
vuln_frame:    .byte 13
eye_frames:    .byte 14, 14, 15, 15
eye_flips:     .byte $0, $1, $2, $0

reverse_dir:   .byte $1, $0, $3, $2

ticks_vuln_rem:   .word 0
chase:            .byte 0     ; 0=scatter mode, 1=chase mode
ticks_mode_rem:   .word 420   ; ticks remaining until switch between chase and scatter
scatter_time:     .word 420
chase_time:       .word 1200

enemy_reset:
   stz ticks_vuln_rem
   stz ticks_vuln_rem+1
   lda #ENEMY1_INIT
   sta enemy1
   lda #ENEMY2_INIT
   sta enemy2
   lda #ENEMY3_INIT
   sta enemy3
   lda #ENEMY4_INIT
   sta enemy4
   jsr __enemy_scatter
   rts

__enemy_scatter:
   stz chase
   lda scatter_time
   sta ticks_mode_rem
   lda scatter_time+1
   sta ticks_mode_rem+1
   lda #ENEMY1_TGT_X
   sta target_x
   lda #ENEMY2_TGT_X
   sta target_x+1
   lda #ENEMY3_TGT_X
   sta target_x+2
   lda #ENEMY4_TGT_X
   sta target_x+3
   lda #ENEMY1_TGT_Y
   sta target_y
   lda #ENEMY2_TGT_Y
   sta target_y+1
   lda #ENEMY3_TGT_Y
   sta target_y+2
   lda #ENEMY4_TGT_Y
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
   bne @move
   jmp @end_loop
@move:
   jsr __enemy_move
   plx
   lda enemies,x
   sta @enemy_temp
   phx
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
   jsr __enemy_reverse
   bra @return
@scatter:
   jsr __enemy_scatter
   jsr __enemy_reverse
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
   cpx #(end_enemies-enemies)
   bne @loop
   rts

__enemy_reverse:
   ldx #0
@loop:
   lda enemies,x
   and #$03
   tay
   lda reverse_dir,y
   tay
   lda enemies,x
   and #$FC
   sta enemies,x
   tya
   ora enemies,x
   sta enemies,x
   inx
   cpx #(end_enemies-enemies)
   bne @loop
   rts

__enemy_move:  ; X: enemy offset (0-3)
   bra @start
@offset:    .byte 0
@enemy:     .byte 0
@last_x:    .byte 0
@last_y:    .byte 0
@target_x:  .byte 0
@target_y:  .byte 0
@diff_x:    .byte 0
@diff_y:    .byte 0
@index:     .byte 0
@last_dir:  .byte 0
@blocked:   .byte 0  ; bit 3: N, bit 2: S, bit 1: W, bit 0: E
@start:
   stx @offset
   lda enemies,x
   sta @enemy
   and #$03
   sta @last_dir
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
   ldx #1
   jsr sprite_getpos
   stx @last_x
   sty @last_y
   cmp #0
   beq @check_current
   jmp @continue
@check_current:
   stz @blocked
   lda @last_dir
   ldx @last_x
   ldy @last_y
   bit #$02
   bne @check_vertical
   bit #$01
   bne @check_west
   cpx #ENEMY_MAX_X
   beq @east_blocked
   inx
   lda #1
   jsr get_tile
   cpx #BLANK
   beq @continue
   cpx #HBAR
   bpl @continue
@east_blocked:
   lda @blocked
   ora #$01
   sta @blocked
   bra @calc_dir
@check_west:
   cpx #ENEMY_MIN_X
   beq @west_blocked
   dex
   lda #1
   jsr get_tile
   cpx #BLANK
   beq @continue
   cpx #HBAR
   bpl @continue
@west_blocked:
   lda @blocked
   ora #$02
   sta @blocked
   bra @calc_dir
@check_vertical:
   bit #$01
   bne @check_up
   cpy #ENEMY_MAX_Y
   beq @south_blocked
   iny
   lda #1
   jsr get_tile
   cpx #BLANK
   beq @continue
   cpx #HBAR
   bpl @continue
@south_blocked:
   lda @blocked
   ora #$04
   sta @blocked
   bra @calc_dir
@check_up:
   cpy #ENEMY_MIN_Y
   beq @north_blocked
   dey
   lda #1
   jsr get_tile
   cpx #BLANK
   beq @continue
   cpx #HBAR
   bpl @continue
@north_blocked:
   lda @blocked
   ora #$08
   sta @blocked
   bra @calc_dir
@continue:
   lda @last_dir  ; continue in last direction until fully into next tile
   asl
   tax
   lda @index
   jmp (@jmptable,x)
@calc_dir:
   sec
   lda @target_x
   sbc @last_x
   sta @diff_x
   sec
   lda @target_y
   sbc @last_y
   sta @diff_y
   bpl @check_sw
   jmp @north
@check_sw:
   lda @diff_x
   bmi @southwest
@southeast:
   cmp @diff_y
   bmi @se_south
@se_east:
   lda @blocked
   cmp #$0D
   beq @se_east_deadend
   lda @last_dir
   cmp #$01
   beq @se_south
   lda @blocked
   bit #$01
   bne @se_east_check_south
   ldx @last_x
   cpx #ENEMY_MAX_X
   beq @se_east_blocked
   inx
   ldy @last_y
   lda #1
   jsr get_tile
   cpx #BLANK
   bne @se_east_check_wall
   jmp @set_right
@se_east_check_wall:
   cpx #HBAR
   bmi @se_east_blocked
   jmp @set_right
@se_east_deadend:
   jmp @set_left
@se_east_blocked:
   lda @blocked
   ora #$01
   sta @blocked
@se_east_check_south:
   bit #$04
   beq @se_south
   jmp @se_south_check_east
@se_south:
   lda @blocked
   cmp #$07
   beq @se_south_deadend
   lda @last_dir
   cmp #$03
   beq @se_east
   lda @blocked
   bit #$04
   bne @se_south_check_east
   ldy @last_y
   cpy #ENEMY_MAX_Y
   beq @se_south_blocked
   iny
   ldx @last_x
   lda #1
   jsr get_tile
   cpx #BLANK
   bne @se_south_check_wall
   jmp @set_down
@se_south_check_wall:
   cpx #HBAR
   bmi @se_south_blocked
   jmp @set_down
@se_south_deadend:
   jmp @set_up
@se_south_blocked:
   lda @blocked
   ora #$04
   sta @blocked
@se_south_check_east:
   bit #$01
   beq @se_east
   lda @last_dir
   cmp #$02
   beq @sw_west
   jmp @ne_north
@southwest:
   lda @diff_x
   bpl @sw_south
   sec
   lda #0
   sbc @diff_x
   cmp @diff_y
   bpl @sw_west
@sw_south:
   lda @blocked
   cmp #$07
   beq @sw_south_deadend
   lda @last_dir
   cmp #$03
   beq @sw_west
   lda @blocked
   bit #$04
   bne @sw_south_check_west
   ldy @last_y
   cpy #ENEMY_MAX_Y
   beq @sw_south_blocked
   iny
   ldx @last_x
   lda #1
   jsr get_tile
   cpx #BLANK
   bne @sw_south_check_wall
   jmp @set_down
@sw_south_check_wall:
   cpx #HBAR
   bmi @sw_south_blocked
   jmp @set_down
@sw_south_deadend:
   jmp @set_up
@sw_south_blocked:
   lda @blocked
   ora #$04
   sta @blocked
@sw_south_check_west:
   bit #$02
   beq @sw_west
   jmp @sw_west_check_south
@sw_west:
   lda @blocked
   cmp #$0E
   beq @sw_west_deadend
   lda @blocked
   bit #$02
   bne @sw_west_check_south
   ldx @last_x
   cpx #ENEMY_MIN_X
   beq @sw_west_blocked
   dex
   ldy @last_y
   lda #1
   jsr get_tile
   cpx #BLANK
   bne @sw_west_check_wall
   jmp @set_left
@sw_west_check_wall:
   cpx #HBAR
   bmi @sw_west_blocked
   jmp @set_left
@sw_west_deadend:
   jmp @set_right
@sw_west_blocked:
   lda @blocked
   ora #$02
   sta @blocked
@sw_west_check_south:
   bit #$04
   beq @sw_south
   lda @last_dir
   cmp #$02
   beq @se_east
   jmp @ne_north
@north:
   lda @diff_x
   bpl @northeast
   jmp @northwest
@northeast:
   lda @diff_y
   bpl @ne_east
   sec
   lda #0
   sbc @diff_y
   cmp @diff_x
   bmi @ne_east
@ne_north:
   lda @blocked
   cmp #$0B
   beq @ne_north_deadend
   lda @last_dir
   cmp #$02
   beq @ne_east
   lda @blocked
   bit #$08
   bne @ne_north_check_east
   ldy @last_y
   cpy #ENEMY_MIN_Y
   beq @ne_north_blocked
   dey
   ldx @last_x
   lda #1
   jsr get_tile
   cpx #BLANK
   bne @ne_north_check_wall
   jmp @set_up
@ne_north_check_wall:
   cpx #HBAR
   bmi @ne_north_blocked
   jmp @set_up
@ne_north_deadend:
   jmp @set_down
@ne_north_blocked:
   lda @blocked
   ora #$08
   sta @blocked
@ne_north_check_east:
   bit #$01
   beq @ne_east
   jmp @ne_east_check_north
@ne_east:
   lda @blocked
   cmp #$0D
   beq @ne_east_deadend
   lda @last_dir
   cmp #$01
   beq @ne_north
   lda @blocked
   bit #$01
   bne @ne_east_check_north
   ldx @last_x
   cpx #ENEMY_MAX_X
   beq @ne_east_blocked
   inx
   ldy @last_y
   lda #1
   jsr get_tile
   cpx #BLANK
   bne @ne_east_check_wall
   jmp @set_right
@ne_east_deadend:
   jmp @set_left
@ne_east_check_wall:
   cpx #HBAR
   bmi @ne_east_blocked
   jmp @set_right
@ne_east_blocked:
   lda @blocked
   ora #$01
   sta @blocked
@ne_east_check_north:
   bit #$08
   beq @ne_north
   lda @last_dir
   cmp #$00
   beq @se_south
   jmp @nw_north
@northwest:
   lda @diff_x
   cmp @diff_y
   bmi @nw_north
@nw_west:
   lda @blocked
   cmp #$0E
   beq @nw_west_deadend
   lda @last_dir
   cmp #$00
   beq @nw_north
   lda @blocked
   bit #$02
   bne @nw_west_check_north
   ldx @last_x
   cpx #ENEMY_MIN_X
   beq @nw_west_blocked
   dex
   ldy @last_y
   lda #1
   jsr get_tile
   cpx #BLANK
   bne @nw_west_check_wall
   jmp @set_left
@nw_west_check_wall:
   cpx #HBAR
   bmi @nw_west_blocked
   jmp @set_left
@nw_west_deadend:
   jmp @set_right
@nw_west_blocked:
   lda @blocked
   ora #$02
   sta @blocked
@nw_west_check_north:
   bit #$08
   beq @nw_north
   lda @last_dir
   cmp #$03
   beq @ne_east
   jmp @sw_south
@east_last_ditch:
   jmp @ne_east
@nw_north:
   lda @blocked
   cmp #$0B
   beq @nw_north_deadend
   lda @last_dir
   cmp #$02
   beq @nw_west
   lda @blocked
   bit #$08
   bne @nw_north_check_west
   ldy @last_y
   cpy #ENEMY_MIN_Y
   beq @nw_north_blocked
   dey
   ldx @last_x
   lda #1
   jsr get_tile
   cpx #BLANK
   bne @nw_north_check_wall
   jmp @set_up
@nw_north_check_wall:
   cpx #HBAR
   bmi @nw_north_blocked
   jmp @set_up
@nw_north_deadend:
   jmp @set_down
@nw_north_blocked:
   lda @blocked
   ora #$08
   sta @blocked
@nw_north_check_west:
   bit #$02
   beq @nw_west
   lda @last_dir
   cmp #$03
   beq @ne_east
   jmp @sw_south
@set_right:
   lda #0
   bra @set
@set_left:
   lda #1
   bra @set
@set_down:
   lda #2
   bra @set
@set_up:
   lda #3
@set:
   sta @last_dir
   lda @enemy
   and #$FC
   ora @last_dir
   ldx @offset
   sta enemies,x
   jmp @continue
@jmptable:
.word @move_right
.word @move_left
.word @move_down
.word @move_up
@move_right:
   ldx #TICK_MOVEMENT
   jsr move_sprite_right
   bra @return
@move_left:
   ldx #TICK_MOVEMENT
   jsr move_sprite_left
   bra @return
@move_down:
   ldx #TICK_MOVEMENT
   jsr move_sprite_down
   bra @return
@move_up:
   ldx #TICK_MOVEMENT
   jsr move_sprite_up
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

enemy_release: ; X: sprite index
   ldy enemy_map,x
   lda enemies,y
   ora #$10
   sta enemies,y
   rts

enemy_stop:    ; X: sprite index
   ldy enemy_map,x
   lda enemies,y
   and #$EF
   sta enemies,y
   rts

enemy_eaten: ; X: sprite index
   ldy enemy_map,x
   lda enemies,y
   and #$F7
   ora #$04
   sta enemies,y
   rts

.endif
