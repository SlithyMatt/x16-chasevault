.ifndef PLAYER_INC
PLAYER_INC = 1

.include "x16.inc"
.include "tiles.inc"
.include "sprite.asm"
.include "timer.asm"
.include "joystick.asm"
.include "enemy.asm"
.include "debug.asm"
.include "loadvram.asm"
.include "superimpose.asm"
.include "globals.asm"
.include "levels.asm"
.include "wallstub.asm"
.include "fruit.asm"
.include "skull.asm"
.include "bomb.asm"
.include "music.asm"
.include "soundfx.asm"

SCOREBOARD_X   = 11
SCOREBOARD_Y   = 1
LIVES_X = 2
LIVES_Y = 14
KEYS_X   = 6
KEYS_Y   = 14

OFF_WEST_X = 0
OFF_EAST_X = 19
OFF_NORTH_Y = 0
OFF_SOUTH_Y = 14

; player animation
player_frames_h:  .byte 1,2,1,0,3,4,3,0
player_frames_up: .byte  9,10, 9, 8, 9,10, 9, 8
player_frames_dn: .byte  6, 7, 6, 5, 6, 7, 6, 5
player_frames_vf: .byte $0,$0,$0,$0,$1,$1,$1,$0
player_frames_d:  .byte 0,0,3,3,4,4,11,11,12,12,13,13,13,13,22,22
player_index_d:   .byte 0
player_start_frame:  .byte 0,       0,       5,       8
player_start_flip:   .byte NO_FLIP, H_FLIP,  NO_FLIP, NO_FLIP
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
   jmp (@jmp_table,x)
@jmp_table:
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
   jsr check_off
   beq @check_pellet
   jmp @return ; off screen, go to next level
@check_pellet:
   lda #1
   jsr get_tile
   cpx #PELLET
   bne @check_powerpellet
   lda tile_collision
   beq @check_north
   jmp @eat_pellet
@check_powerpellet:
   cpx #POWER_PELLET
   bne @check_key
   lda tile_collision
   beq @check_north
   jmp @eat_powerpellet
@check_key:
   cpx #KEY
   bne @check_north
   lda tile_collision
   beq @check_north
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
   beq @hlock_north
   cpx #HOME_FENCE
   beq @adjust_down
   cpx #PELLET
   bpl @check_east
   bra @adjust_down
@hlock_north:
   ldx @xpos
   ldy @ypos
   dey
   jsr check_hlock
   beq @adjust_down
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
   cpx #BLANK
   beq @check_south
   cpx #VLOCK
   bmi @adjust_left
   beq @vlock_east
   cpx #HOME_FENCE
   beq @adjust_left
   cpx #PELLET
   bpl @check_south
   bra @adjust_left
@vlock_east:
   ldx @xpos
   inx
   ldy @ypos
   jsr check_vlock
   beq @adjust_left
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
   cpx #BLANK
   beq @check_west
   cpx #HLOCK
   bmi @adjust_up
   beq @hlock_south
   cpx #HOME_FENCE
   beq @adjust_up
   cpx #PELLET
   bpl @check_west
   bra @adjust_up
@hlock_south:
   ldx @xpos
   ldy @ypos
   iny
   jsr check_hlock
   beq @adjust_up
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
   cpx #BLANK
   beq @check_collision
   cpx #VLOCK
   bmi @adjust_right
   beq @vlock_west
   cpx #HOME_FENCE
   bne @check_west_pellet
   jmp @adjust_right
@vlock_west:
   ldx @xpos
   dex
   ldy @ypos
   jsr check_vlock
   beq @adjust_right
   jmp @check_collision
@check_west_pellet:
   cpx #PELLET
   bpl @check_collision
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
   beq @check_regenerate
   lda frame_num
   and #$1C
   lsr
   lsr
   tax
   lda player
   bit #$08
   bne @vertical
   lda player_frames_h,x
   bra @check_flip
@vertical:
   bit #$04
   bne @up
   lda player_frames_dn,x
   bra @check_flip
@up:
   lda player_frames_up,x
@check_flip:
   pha
   ldy #0
   lda player
   and #$0C
   cmp #$00
   beq @loadframe
   lsr
   lsr
   bit #$02
   beq @flip_left
   lda player_frames_vf,x
@flip_left:
   tay
@loadframe:
   pla
   ldx #PLAYER_idx
   jsr sprite_frame
@check_regenerate:
   lda regenerate_req
   beq @check_move_req
   stz regenerate_req
   jsr regenerate
   jsr fruit_reset
   bra @return
@check_move_req:
   lda move_req
   beq @check_refresh_req
   stz move_req
   lda #PLAYER_idx
   ora #$80
   ldx move_x
   ldy move_y
   jsr sprite_setpos
   jsr player_move
   lda player
   and #$0C
   lsr
   lsr
   tay
   lda player_start_frame,y
   phy
   plx
   ldy player_start_flip,x
   ldx #PLAYER_idx
   jsr sprite_frame
   jsr refresh_status
   bra @return
@check_refresh_req:
   lda refresh_req
   beq @return
   stz refresh_req
   jsr refresh_status
@return:
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
   stz VERA_data0
   stz VERA_data0
   jsr sfx_play_pellet
   dec pellets
   lda #10
   jsr add_score
   jsr check_pellet_count
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
   stz VERA_data0
   stz VERA_data0
   jsr sfx_play_pwr_pellet
   dec pellets
   lda #100
   jsr add_score
   lda vuln_time
   jsr make_vulnerable
   lda #1
   sta score_mult
   jsr check_pellet_count
   rts

check_pellet_count:
   lda pellets
   cmp #0
   bne @check_e4
   jsr next_level
   bra @return
@check_e4:
   lda pellets
   cmp release_e4
   bpl @check_e3
   ldx #ENEMY4_idx
   jsr enemy_release
@check_e3:
   lda pellets
   cmp release_e3
   bpl @return
   ldx #ENEMY3_idx
   jsr enemy_release
@return:
   rts

eat_key: ; Input:
         ; X: key x
         ; Y: key y
   lda #1
   jsr xy2vaddr
   stz VERA_ctrl
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   stz VERA_data0
   jsr sfx_play_key_fruit
   inc keys
   lda #200
   jsr add_score
   lda #1
   ldx #KEYS_X
   ldy #KEYS_Y
   jsr xy2vaddr
   stz VERA_ctrl
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   lda keys
   ora #$30
   sta VERA_data0
   rts

check_hlock:   ; Input:
               ;  X: tile x
               ;  Y: tile y
               ; Output:
               ;  Z: cleared if unlocked, set if remaining
   lda keys
   cmp #0
   beq @return
   phx
   phy
   jsr use_key
   ply
   plx
   jsr clear_hlock
   lda #1
@return:
   rts

check_vlock:   ; Input:
               ;  X: tile x
               ;  Y: tile y
               ; Output:
               ;  Z: cleared if unlocked, set if remaining
   lda keys
   cmp #0
   beq @return
   phx
   phy
   jsr use_key
   ply
   plx
   jsr clear_vlock
   lda #1
@return:
   rts

use_key:
   jsr sfx_play_unlock
   dec keys
   lda #1
   ldx #KEYS_X
   ldy #KEYS_Y
   jsr xy2vaddr
   stz VERA_ctrl
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   lda keys
   ora #$30
   sta VERA_data0
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
   sta VERA_data0
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
   SPRITE_GET_SCREEN_POS @index, @p_xpos, @p_ypos
   lda #ENEMY1_idx
   sta @index
@enemy_loop:
   SPRITE_GET_SCREEN_POS @index, @s_xpos, @s_ypos
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
   jmp @return
@next_enemy:
   inc @index
   lda @index
   cmp #(ENEMY4_idx + 1)
   beq @check_fireball
   jmp @enemy_loop
@check_fireball:
   lda #FIREBALL1_idx
   sta @index
@fb_loop:
   jsr fireball_visible
   cmp #0
   beq @next_fb
   SPRITE_GET_SCREEN_POS @index, @s_xpos, @s_ypos
   cmp #0
   beq @next_fb
   SPRITE_CHECK_BOX 4, @p_xpos, @p_ypos, @s_xpos, @s_ypos
   cmp #0
   beq @next_fb
   jsr player_die
   jmp @return
@next_fb:
   inc @index
   lda @index
   cmp #(FIREBALL4_idx + 1)
   beq @check_fruit
   jmp @fb_loop


@check_fruit:
   lda fruit
   bit #FRUIT_BLINKING
   bne @check_bomb
   lda #FRUIT_idx
   sta @index
   SPRITE_GET_SCREEN_POS @index, @s_xpos, @s_ypos
   cmp #0
   beq @check_bomb
   SPRITE_CHECK_BOX 4, @p_xpos, @p_ypos, @s_xpos, @s_ypos
   cmp #0
   beq @check_bomb
   jsr eat_fruit
@check_bomb:
   jsr bomb_armed
   cmp #0
   beq @return
   lda #BOMB_idx
   sta @index
   SPRITE_GET_SCREEN_POS @index, @s_xpos, @s_ypos
   cmp #0
   beq @return
   SPRITE_CHECK_BOX 4, @p_xpos, @p_ypos, @s_xpos, @s_ypos
   cmp #0
   beq @return
   jsr light_bomb
@return:
   rts


eat_fruit:
   jsr fruit_blink
   jsr sfx_play_key_fruit
   lda #200       ; Add 500 to score
   jsr add_score
   lda #200
   jsr add_score
   lda #100
   jsr add_score
   lda #1
   jsr fruit_status
   rts

eat_enemy:  ; X: enemy sprite index
   jsr enemy_eaten
   jsr sfx_play_ghost
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

check_off:  ; Input:
            ;  A: overlap
            ;  X: sprite tile X
            ;  Y: sprite tile Y
            ; Output:
            ;  Z: 0=still on screen; 1=off screen
   cmp #0
   bne @on_screen
   cpx #OFF_EAST_X
   bne @check_west
   jsr level_east
   bra @disable
@check_west:
   cpx #OFF_WEST_X
   bne @check_south
   jsr level_west
   bra @disable
@check_south:
   cpy #OFF_SOUTH_Y
   bne @check_north
   jsr level_south
   bra @disable
@check_north:
   cpy #OFF_NORTH_Y
   bne @on_screen
   jsr level_north
@disable:
   jsr player_stop
   lda #PLAYER_idx
   jsr sprite_disable
   jsr fruit_reset
   jsr enemy_clear
   jsr bomb_clear
   jsr skull_clear
   lda #1
   bra @return
@on_screen:
   lda #0
@return:
   rts

refresh_status:
   lda #0
   jsr add_score
   lda #1
   ldx #LIVES_X
   ldy #LIVES_Y
   jsr xy2vaddr
   stz VERA_ctrl
   ora #$40
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   lda lives
   ora #$30
   sta VERA_data0
   lda keys
   ora #$30
   sta VERA_data0
   lda #0
   jsr fruit_status
   rts


; --------- Timer Handlers ---------

player_die:
   jsr player_stop
   jsr enemy_stop
   jsr skull_stop
   jsr fireball_stop
   jsr fruit_stop
   jsr stop_music
   jsr sfx_play_death
   stz player_index_d
   SET_TIMER 10, @animation
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
   SET_TIMER 4, @animation
   jmp timer_done
@animation_done:
   dec lives
   bne @regenerate
   jsr refresh_status
   SET_TIMER 30, game_over
   bra @return
@regenerate:
   SET_TIMER 60, regenerate
@return:
   jmp timer_done

regenerate:
   jsr fruit_store_pos
   jsr skull_store_pos
   jsr fireball_clear
   jsr bomb_store_pos
   lda #>(VRAM_sprattr>>4)
   ldx #<(VRAM_sprattr>>4)
   ldy #<spriteattr_fn
   jsr loadvram            ; reset sprites
   jsr fruit_restore_pos
   jsr skull_restore_pos
   jsr bomb_restore_pos
   jsr refresh_status
   SET_TIMER 60, readygo
   jsr enemy_reset
   jsr start_music
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
   jsr fruit_move
   jsr skull_move
   jsr fireball_move
   ldx #ENEMY1_idx   ; release first two enemies immediately
   jsr enemy_release
   ldx #ENEMY2_idx
   jsr enemy_release
   jmp timer_done

game_over:
   SUPERIMPOSE "game over", 5, 9
   SET_TIMER 60, @continue
   jmp timer_done
@continue:
   SUPERIMPOSE_RESTORE
   SUPERIMPOSE "continue?", 5, 9
   lda #1
   sta continue_prompt
   jmp timer_done

continue:
   SUPERIMPOSE_RESTORE
   jsr level_restore
   lda max_lives
   sta lives
   SET_TIMER 1, regenerate
   rts

next_level:
   jsr enemy_clear
   jsr skull_clear
   jsr fireball_clear
   jsr fruit_stop
   jsr player_stop
   SET_TIMER 15, @level_up
   rts
@level_up:
   SUPERIMPOSE "complete!", 5, 9
   lda level
   cmp #48
   beq @win
   SET_TIMER 30, @update_level
   jmp timer_done
@win:
   jsr stop_music
   SET_TIMER 2, @win_music
   lda #1
   sta winscreen_req
   jmp timer_done
@win_music:
   lda #WIN_MUSIC_BANK
   sta music_bank
   jsr start_music
   jmp timer_done
@update_level:
   SUPERIMPOSE_RESTORE
   jsr clear_bars
   jsr sfx_play_bars
   jsr fruit_blink
   jsr player_move
   jmp timer_done

light_bomb:
   jsr bomb_light
   SET_TIMER BOMB_LIT_TICKS, @detonated
   jsr fireball_clear
   jsr enemy_stop
   rts
@detonated:
   jsr sfx_play_bomb
   jsr enemy_clear
   jsr skull_clear
   jsr fireball_clear
   jmp timer_done



.endif
