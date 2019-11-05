.ifndef PLAYER_INC
PLAYER_INC = 1

.include "x16.inc"
.include "sprite.asm"
.include "timer.asm"
.include "joystick.asm"
.include "enemy.asm"
.include "debug.asm"
.include "loadvram.asm"
.include "superimpose.asm"

HLOCK          = $00B
VLOCK          = $00C
PELLET         = $00D
POWER_PELLET   = $00E
KEY            = $010

; sprite indices
PLAYER_idx     = 1
ENEMY1_idx     = 2
ENEMY2_idx     = 3
ENEMY3_idx     = 4
ENEMY4_idx     = 5
FRUIT_idx      = 6

ACTIVE_ENEMY_L = $0E400
ACTIVE_ENEMY_H = $0E600
VULN_ENEMY     = $0E680

SCOREBOARD_X   = 10
SCOREBOARD_Y   = 1

TICK_MOVEMENT  = 1


; --------- Global Variables ---------

player:     .byte 0 ; 7-4 (TBD) | 3:2 - direction | 1 - movable | 0 - animated
;                                 0:R,1:L,2:D,3:U
lives:      .byte 4
level:      .byte 1
score:      .dword 0    ; BCD
pellets:    .byte 101
keys:       .byte 0
score_mult: .byte 1

; player animation
player_frames_h:  .byte 2,2,1,0,0,1,1,2
player_frames_v:  .byte 4,4,3,0,0,3,3,4
player_frames_d:  .byte 0,0,3,3,3,4,4,4,5,5,5,6,6,7,7,17
player_index_d:   .byte 0

; --------- Subroutines ---------

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
@start:
   lda player
   bit #$02             ; check for movable
   bne @check_right
   jmp @check_animate
@check_right:
   ldx #1
   cpx joystick1_right
   bne @check_left
   and #$F3
   bra @move
@check_left:
   cpx joystick1_left
   bne @check_down
   and #$F3
   ora #$04
   bra @move
@check_down:
   cpx joystick1_down
   bne @check_up
   and #$F3
   ora #$08
   bra @move
@check_up:
   cpx joystick1_up
   bne @no_direction
   and #$F3
   ora #$0C
   bra @move
@no_direction:
   sta player
   jsr player_freeze
   jmp @check_collision
@move:
   sta player
   jsr player_animate
   lda player
   and #$0C
   lsr
   tax
   lda #PLAYER_idx
   jmp (@jmptable,x)
@jmptable:
   .word @move_right
   .word @move_left
   .word @move_down
   .word @move_up
@move_right:
   ldx #TICK_MOVEMENT
   jsr move_sprite_right
   bra @check_pos
@move_left:
   ldx #TICK_MOVEMENT
   jsr move_sprite_left
   bra @check_pos
@move_down:
   ldx #TICK_MOVEMENT
   jsr move_sprite_down
   bra @check_pos
@move_up:
   ldx #TICK_MOVEMENT
   jsr move_sprite_up
   bra @check_pos
@overlap:   .byte 0
@xpos:      .byte 0
@ypos:      .byte 0
@check_pos:
   lda #PLAYER_idx
   ldx #1
   jsr sprite_getpos
   sta @overlap
   stx @xpos
   sty @ypos
   ;CORNER_DEBUG
   lda #1
   jsr get_tile
   cpx #PELLET
   bne @check_powerpellet
   jmp @eat_pellet
@check_powerpellet:
   cpx #POWER_PELLET
   bne @check_key
   jmp @eat_powerpellet
@check_key:
   cpx #KEY
   bne @check_north
   jmp @eat_key
@check_north:
   lda player
   and #$0C
   tax
   lda @overlap
   bit #$80
   beq @check_east
   lda #1
   ldx @xpos
   ldy @ypos
   dey
   jsr get_tile
   cpx #0
   beq @check_east
   cpx #HLOCK
   bmi @adjust_down
   cpx #PELLET
   bpl @check_east
   lda keys
   beq @adjust_down
   ; TODO: handle key unlock
   bra @check_east
@adjust_down:
   lda #PLAYER_idx
   jmp @move_down
@check_east:
   lda player
   and #$0C
   tax
   lda @overlap
   bit #$20
   beq @check_south
   lda #1
   ldx @xpos
   inx
   ldy @ypos
   jsr get_tile
   cpx #0
   beq @check_south
   cpx #HLOCK
   bmi @adjust_left
   cpx #PELLET
   bpl @check_south
   lda keys
   beq @adjust_left
   ; TODO: handle key unlock
   bra @check_south
@adjust_left:
   lda #PLAYER_idx
   jmp @move_left
@check_south:
   lda player
   and #$0C
   tax
   lda @overlap
   bit #$08
   beq @check_west
   lda #1
   ldx @xpos
   ldy @ypos
   iny
   jsr get_tile
   cpx #0
   beq @check_west
   cpx #HLOCK
   bmi @adjust_up
   cpx #PELLET
   bpl @check_west
   lda keys
   beq @adjust_up
   ; TODO: handle key unlock
   bra @check_west
@adjust_up:
   lda #PLAYER_idx
   jmp @move_up
@check_west:
   lda player
   and #$0C
   tax
   lda @overlap
   bit #$02
   beq @check_collision
   lda #1
   ldx @xpos
   dex
   ldy @ypos
   jsr get_tile
   cpx #0
   beq @check_collision
   cpx #HLOCK
   bmi @adjust_right
   cpx #PELLET
   bpl @check_collision
   lda keys
   beq @adjust_right
   ; TODO: handle key unlock
   bra @check_collision
@adjust_right:
   lda #PLAYER_idx
   jmp @move_right
@eat_pellet:
   ldx @xpos
   ldy @ypos
   jsr eat_pellet
   bra @check_collision
@eat_powerpellet:
   ldx @xpos
   ldy @ypos
   jsr eat_powerpellet
   bra @check_collision
@eat_key:
   ldx @xpos
   ldy @ypos
   jsr eat_key
@check_collision:
   jsr check_collision
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
   bra @check_flip
@vertical:
   lda player_frames_v,x
@check_flip:
   pha
   ldy #0
   lda player
   and #$0C
   cmp #$0C
   beq @loadframe
   lsr
   lsr
   tay
@loadframe:
   pla
   ldx #PLAYER_idx
   jsr sprite_frame
@done_animate:
   ; TODO: other maintenance
   rts

eat_pellet: ; Input:
            ; X: pellet x
            ; Y: pellet y
   lda #1
   jsr xy2vaddr
   stz VERA_ctrl
   ora #$10
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   stz VERA_data
   stz VERA_data
   dec pellets
   lda #10
   jsr add_score
   rts

eat_powerpellet:  ; Input:
                  ; X: pellet x
                  ; Y: pellet y
   lda #1
   jsr xy2vaddr
   stz VERA_ctrl
   ora #$10
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   stz VERA_data
   stz VERA_data
   dec pellets
   lda #100
   jsr add_score
   lda #90 ; 6 seconds, TODO: reduce over with level upgrades
   jsr make_vulnerable
   lda #1
   sta score_mult
   rts

eat_key: ; Input:
         ; X: key x
         ; Y: key y
   lda #1
   jsr xy2vaddr
   stz VERA_ctrl
   ora #$10
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   stz VERA_data
   stz VERA_data
   inc keys
   lda #200
   jsr add_score
   ; TODO - update key count on display
   rts

add_score:  ; A: points to add
   bra @start
@vars:
@bin: .byte 0
@bcd: .word 0
@score_tiles: .byte $30,$30,$30,$30,$30,$30,$30,$30
@start:
   sta @bin
   stz @bcd
   stz @bcd+1
   lda #$30
   sta @score_tiles
   sta @score_tiles+1
   sta @score_tiles+2
   sta @score_tiles+3
   sta @score_tiles+4
   sta @score_tiles+5
   sta @score_tiles+6
   sta @score_tiles+7
   sed         ; Start BCD mode
   ldx #8
@bin2bcd_loop:
   asl @bin
   lda @bcd
   adc @bcd
   sta @bcd
   lda @bcd+1
   adc @bcd+1
   sta @bcd+1
   dex
   bne @bin2bcd_loop
   clc
   lda @bcd
   adc score
   sta score
   lda @bcd+1
   adc score+1
   sta score+1
   lda score+2
   adc #0
   sta score+2
   lda score+3
   adc #0
   sta score+3
   cld         ; End BCD mode
   ldx #0
   ldy #6
@tile_loop:
   lda score,x
   lsr
   lsr
   lsr
   lsr
   ora @score_tiles,y
   sta @score_tiles,y
   lda score,x
   and #$0F
   ora @score_tiles+1,y
   sta @score_tiles+1,y
   dey
   dey
   inx
   cpx #4
   bne @tile_loop
   lda #1
   ldx #SCOREBOARD_X
   ldy #SCOREBOARD_Y
   jsr xy2vaddr
   stz VERA_ctrl
   ora #$20
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   ldx #0
@vram_loop:
   lda @score_tiles,x
   sta VERA_data
   inx
   cpx #8
   bne @vram_loop
@return:
   rts

check_collision:
   bra @start
@p_xpos: .word 0
@p_ypos: .word 0
@s_xpos: .word 0
@s_ypos: .word 0
@index: .byte 0
@start:
   lda #PLAYER_idx
   sta @index
   SPRITE_SCREEN_POS @index, @p_xpos, @p_ypos
   lda #ENEMY1_idx
   sta @index
@enemy_loop:
   SPRITE_SCREEN_POS @index, @s_xpos, @s_ypos
   cmp #0
   bne @check_box
   jmp @next_enemy
@check_box:
   SPRITE_CHECK_BOX 4, @p_xpos, @p_ypos, @s_xpos, @s_ypos
   cmp #0
   beq @next_enemy
   ldx @index
   jsr enemy_check_vuln
   cmp #0
   beq @check_eyes
   ldx @index
   jsr eat_enemy
   bra @next_enemy
@check_eyes:
   ldx @index
   jsr enemy_check_eyes
   cmp #0
   beq @die
   bra @next_enemy
@die:
   jsr player_die
   bra @return
@next_enemy:
   inc @index
   lda @index
   cmp #(ENEMY4_idx + 1)
   beq @check_fruit
   jmp @enemy_loop
@check_fruit:
   lda #FRUIT_idx
   sta @index
   SPRITE_SCREEN_POS @index, @s_xpos, @s_ypos
   cmp #0
   beq @return
   SPRITE_CHECK_BOX 4, @p_xpos, @p_ypos, @s_xpos, @s_ypos
   cmp #0
   beq @return
   jsr eat_fruit
@return:
   rts


eat_fruit:
   ; TODO: disappear fruit
   lda #200       ; Add 500 to score
   jsr add_score
   jsr add_score
   lda #100
   jsr add_score
   ; TODO: add icon to achievement tray
   ; TODO: level-specific result
   rts

eat_enemy:  ; X: enemy sprite index
   jsr enemy_eaten
   ldx score_mult
@score:
   lda #200
   phx
   jsr add_score
   plx
   dex
   cpx #0
   bne @score
   inc score_mult
   rts


; --------- Timer Handlers ---------

player_die:
   jsr player_stop
   stz player_index_d
   SET_TIMER 5, @animation
   lda player
   ora #$80
   sta player
   rts
@animation:
   ldx player_index_d
   lda player_frames_d,x
   ldx #PLAYER_idx
   ldy #0
   jsr sprite_frame
   inc player_index_d
   ldx #(player_index_d-player_frames_d)
   cpx player_index_d
   beq @animation_done
   SET_TIMER 3, @animation
   jmp timer_done
@animation_done:
   dec lives
   bne @regenerate
   SET_TIMER 30, game_over
   bra @return
@regenerate:
   SET_TIMER 30, regenerate
@return:
   jmp timer_done

regenerate:
   lda #>(VRAM_sprattr>>4)
   ldx #<(VRAM_sprattr>>4)
   ldy #<spriteattr_fn
   jsr loadvram            ; reset sprites
   lda #1
   ldx #2
   ldy #14
   jsr xy2vaddr
   stz VERA_ctrl
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   lda lives
   clc
   adc #$30
   sta VERA_data
   SET_TIMER 60, readygo
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
   jsr player_move
   jmp timer_done

game_over:
   SUPERIMPOSE "game over", 5, 9
   ; TODO: prompt for continue/exit
   jmp timer_done
   lda #1




.endif
