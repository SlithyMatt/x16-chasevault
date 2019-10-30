.ifndef PLAYER_INC
PLAYER_INC = 1

.include "sprite.asm"
.include "timer.asm"
.include "joystick.asm"
.include "enemy.asm"



PELLET         = $00B
POWER_PELLET   = $00C

; state
player:     .byte 0 ; 7-4 (TBD) | 3:2 - direction | 1 - movable | 0 - animated
;                                 0:R,1:L,2:D,3:U
level:      .byte 1
score:      .dword 0
pellets:    .byte 101
keys:       .byte 0

; player animation
player_frames_h: .byte 2,2,1,0,0,1,1,2
player_frames_v: .byte 4,4,3,0,0,3,3,4
player_frames_d: .byte 0,0,3,3,3,4,4,4,5,5,5,6,6,7,7,17

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
   and #$F3             ; clear direction
   ldx #1
   cpx joystick1_right
   bne @check_left
   bra @move
@check_left:
   cpx joystick1_left
   bne @check_down
   ora #$04
   bra @move
@check_down:
   cpx joystick1_down
   bne @check_up
   ora #$08
   bra @move
@check_up:
   cpx joystick1_up
   bne @no_direction
   ora #$0C
   bra @move
@no_direction:
   sta player
   jmp @check_collision
@move:
   sta player
   and #$0C
   lsr
   tax
   lda #0
   jmp (@jmptable,x)
@jmptable:
   .word @move_right
   .word @move_left
   .word @move_down
   .word @move_up
@move_right:
   jsr move_sprite_right
   bra @check_pos
@move_left:
   jsr move_sprite_left
   bra @check_pos
@move_down:
   jsr move_sprite_down
   bra @check_pos
@move_up:
   jsr move_sprite_up
   bra @check_pos
@overlap:   .byte 0
@xpos:      .byte 0
@ypos:      .byte 0
@check_pos:
   lda #0
   ldx #1
   jsr sprite_getpos
   sta @overlap
   stx @xpos
   sty @ypos
   lda #1
   jsr get_tile
   cpx #PELLET
   bne @check_powerpellet
   jmp @eat_pellet
@check_powerpellet:
   cpx #POWER_PELLET
   bne @check_north
   jmp @eat_powerpellet
@check_north:
   lda player
   and #$0C
   tax
   lda @overlap
   bit #$80
   beq @check_east
   cpx #$0C
   bne @check_east
   lda #1
   ldx @xpos
   ldy @ypos
   dey
   jsr get_tile
   cpx #0
   beq @check_east
   jmp @move_down
@check_east:
   lda player
   and #$0C
   tax
   lda @overlap
   bit #$20
   beq @check_south
   cpx #$00
   bne @check_south
   lda #1
   ldx @xpos
   inx
   ldy @ypos
   jsr get_tile
   cpx #0
   beq @check_south
   jmp @move_left
@check_south:
   lda player
   and #$0C
   tax
   lda @overlap
   bit #$08
   beq @check_west
   cpx #$08
   bne @check_west
   lda #1
   ldx @xpos
   ldy @ypos
   iny
   jsr get_tile
   cpx #0
   beq @check_west
   jmp @move_up
@check_west:
   lda player
   and #$0C
   tax
   lda @overlap
   bit #$02
   beq @check_collision
   cpx #$04
   bne @check_collision
   lda #1
   ldx @xpos
   dex
   ldy @ypos
   jsr get_tile
   cpx #0
   beq @check_collision
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
   jmp @loadframe
@vertical:
   lda player_frames_v,x
@loadframe:
   ldx #0
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
   lda #100
   jsr add_score
   jsr make_vulnerable
   rts

add_score:  ; Input:
            ; A: points to add
   clc
   adc score
   sta score
   lda score+1
   adc #0
   sta score+1
   lda score+2
   adc #0
   sta score+2
   lda score+3
   adc #0
   sta score+3
   ; TODO: update score display
   rts

check_collision:
   ; TODO: handle collision
   rts

.endif
