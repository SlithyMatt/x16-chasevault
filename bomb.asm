.ifndef BOMB_INC
BOMB_INC = 1

.include "x16.inc"
.include "globals.asm"
.include "sprite.asm"

BOMB_INIT_FRAME = 33
BOMB_LIT_FRAME  = 34
BOMB_BLINK_FRAME = 22

bomb: .byte 0  ; Bits 7-3 (TBD) | Bit 2: blinked | Bit 1: lit | Bit 0: placed

BOMB_PLACED    = $01
BOMB_LIT       = $02
BOMB_BLINKED   = $04

bomb_state_ticks: .byte 0

BOMB_LIT_TICKS = 70
BOMB_BLINK_TICKS = 10

__bomb_stored_x: .byte 0
__bomb_stored_y: .byte 0

bomb_tick:
@start:
   lda bomb
   bit #BOMB_PLACED
   bne @show
   lda #BOMB_idx
   jsr sprite_disable
   jmp @return
@show:
   bit #BOMB_LIT
   bne @show_lit
   bit #BOMB_BLINKED
   beq @show_init_frame
   jmp @show_blinked
@show_init_frame:
   lda #BOMB_INIT_FRAME
   ldx #BOMB_idx
   ldy #0
   jsr sprite_frame
   jmp @return
@show_lit:
   dec bomb_state_ticks
   bne @show_lit_frame
   jmp @blink
@show_lit_frame:
   lda #BOMB_LIT_FRAME
   ldx #BOMB_idx
   ldy #0
   jsr sprite_frame
   lda frame_num
   and #$06
   tax
   lda #BOMB_idx
   jmp (@jmp_table,x)
@jmp_table:
.word @move_up
.word @move_down
.word @move_right
.word @move_left
@move_up:
   ldx #1
   jsr move_sprite_right
   lda #BOMB_idx
   ldx #1
   jsr move_sprite_up
   jmp @return
@move_down:
   ldx #2
   jsr move_sprite_down
   jmp @return
@move_right:
   ldx #1
   jsr move_sprite_up
   lda #BOMB_idx
   ldx #1
   jsr move_sprite_right
   jmp @return
@move_left:
   ldx #2
   jsr move_sprite_left
   jmp @return
@blink:
   lda #BOMB_BLINK_TICKS
   sta bomb_state_ticks
   lda bomb
   eor #BOMB_LIT
   ora #BOMB_BLINKED
   sta bomb
@show_blinked:
   dec bomb_state_ticks
   beq @clear
   lda #BOMB_BLINK_FRAME
   ldx #BOMB_idx
   ldy #0
   jsr sprite_frame
   jmp @return
@clear:
   jsr bomb_clear
@return:
   rts


bomb_clear:
   stz bomb
   stz bomb_state_ticks
   rts

bomb_place: ; A: tile layer index
            ; X: tile x
            ; Y: tile y
   clc
   ror
   ror
   ora #BOMB_idx
   jsr sprite_setpos
   lda bomb
   ora #BOMB_PLACED
   sta bomb
   rts

bomb_light:
   lda bomb
   ora #BOMB_LIT
   sta bomb
   lda #BOMB_LIT_TICKS
   sta bomb_state_ticks
   rts

bomb_armed: ; Output: A - 0=not armed, 1=armed
   lda bomb
   bit #BOMB_PLACED
   beq @not_armed
   bit #BOMB_LIT
   bne @not_armed
   bit #BOMB_BLINKED
   bne @not_armed
   lda #1
   bra @return
@not_armed:
   lda #0
@return:
   rts

bomb_store_pos:
   lda #BOMB_idx
   ldx #1
   jsr sprite_getpos
   stx __bomb_stored_x
   sty __bomb_stored_y
   rts

bomb_restore_pos:
   lda #($80 | BOMB_idx)
   ldx __bomb_stored_x
   ldy __bomb_stored_y
   jsr sprite_setpos
   rts

.endif
