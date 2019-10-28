.ifndef GAME_INC
GAME_INC = 1

.ifndef VRAM_SPRITES
VRAM_SPRITES = $0E000
.endif

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

.macro SET_SPRITE_FRAME sprite ; frame in A
   asl
   asl
   tax
   lda #0
   sta VERA_ctrl
   VERA_SET_ADDR (VRAM_sprattr + (sprite << 3)), 1
   txa
   clc
   adc #<(VRAM_SPRITES >> 5)
   sta VERA_data
   lda #0
   adc #>(VRAM_SPRITES >> 5)
   sta VERA_data
.endmacro

; timing
frame_num:  .byte 0
timer:      .word 0
timervec:   .word $0000

; state
player:     .byte 0 ; 7-4 (TBD) | 3:2 - direction | 1 - movable | 0 - animated
;                                 0:R,1:L,2:U,3:D
level:      .byte 1
score:      .dword 0
pellets:    .byte 101
keys:       .byte 0

; player animation
player_frames_h: .byte 2,2,1,0,0,1,1,2
player_frames_v: .byte 4,4,3,0,0,3,3,4

init_game:
   SET_TIMER 60, readygo
   rts

game_tick:        ; called after every VSYNC detected (60 Hz)
   inc frame_num
   lda frame_num
   cmp #60
   bne @timer_svc
   lda #0
   sta frame_num
@timer_svc:
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
   lda player
   ora #$03
   sta player
   jmp timer_done

player_tick:
   lda player
   and #$02
   beq @check_animate
   ; TODO: handle movement
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
   SET_SPRITE_FRAME 0
@done_animate:
   ; TODO: other maintenance
   rts


.endif
