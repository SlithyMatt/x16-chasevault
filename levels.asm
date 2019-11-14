.ifndef LEVELS_INC
LEVELS_INC = 1

.include "x16.inc"
.include "globals.asm"
.include "timer.asm"

LEVEL_X  = 10
LEVEL_Y  = 0

NORTH_ENTRANCE_X = 9
NORTH_ENTRANCE_Y = 0
EAST_ENTRANCE_X = 19
EAST_ENTRANCE_Y = 8
SOUTH_ENTRANCE_X = 9
SOUTH_ENTRANCE_Y = 14
WEST_ENTRANCE_X = 0
WEST_ENTRANCE_Y = 8

HSCROLL_STEP = 5
VSCROLL_STEP = 4

NUM_PELLETS = 0
NEW_LEVEL = 1
EAST_NEIGHBOR = 2
WEST_NEIGHBOR = 3
SOUTH_NEIGHBOR = 4
NORTH_NEIGHBOR = 5
LEVEL_HSCROLL = 6
LEVEL_VSCROLL = 8
NUM_BARS = 10

level_table:   ; BCD-indexed table of level data structures
   .word 0
   .word level1, level2, level3, level4, level5, level6, level7, level8, level9
   .word $a,$b,$c,$d,$e,$f
   .word level10, level11, level12, level13, level14
   .word level15, level16, level17, level18, level19
   .word $1a,$1b,$1c,$1d,$1e,$1f
   .word level20, level21, level22, level23, level24
   .word level25, level26, level27, level28, level29
   .word $2a,$2b,$2c,$2d,$2e,$2f
   .word level30, level31, level32, level33, level34
   .word level35, level36, level37, level38, level39
   .word $3a,$3b,$3c,$3d,$3e,$3f
   .word level40, level41, level42, level43, level44
   .word level45, level46, level47, level48, level49

level1:
   .byte 102   ; number of pellets
   .byte 0     ; new
   .byte 9     ; east neighbor
   .byte 0     ; west neighbor
   .byte 2     ; south neighbor
   .byte 0     ; north neighbor
   .word 0     ; hscroll
   .word 0     ; yscroll
   .byte 2     ; number of bars
   .byte 9,11, 18,8  ; x,y coordinates of each bar tile

level2:
   .byte 108   ; number of pellets
   .byte 1
   .byte 10
   .byte 0
   .byte 3
   .byte 1
   .word 0
   .word 240
   .byte 3     ; number of bars
   .byte 9,12, 18,8, 9,2

level3:
   .byte 102   ; number of pellets
   .byte 1
   .byte 11
   .byte 0
   .byte 4
   .byte 2
   .word 0
   .word 480
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level4:
   .byte 102   ; number of pellets
   .byte 1
   .byte 12
   .byte 0
   .byte 5
   .byte 3
   .word 0
   .word 720
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level5:
   .byte 102   ; number of pellets
   .byte 1
   .byte 13
   .byte 0
   .byte 6
   .byte 4
   .word 0
   .word 960
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level6:
   .byte 102   ; number of pellets
   .byte 1
   .byte 14
   .byte 0
   .byte 7
   .byte 5
   .word 0
   .word 1200
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level7:
   .byte 102   ; number of pellets
   .byte 1
   .byte 15
   .byte 0
   .byte 8
   .byte 6
   .word 0
   .word 1440
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level8:
   .byte 102   ; number of pellets
   .byte 1
   .byte 16
   .byte 0
   .byte 0
   .byte 7
   .word 0
   .word 1680
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level9:
   .byte 102   ; number of pellets
   .byte 1
   .byte 17
   .byte 1
   .byte 10
   .byte 0
   .word 320
   .word 0
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level10:
   .byte 102   ; number of pellets
   .byte 1
   .byte 18
   .byte 2
   .byte 11
   .byte 9
   .word 320
   .word 240
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level11:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level12:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level13:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level14:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level15:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level16:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level17:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level18:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level19:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level20:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level21:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level22:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level23:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level24:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level25:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level26:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level27:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level28:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level29:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level30:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level31:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level32:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level33:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level34:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level35:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level36:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level37:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level38:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level39:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level40:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level41:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level42:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level43:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level44:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level45:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level46:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level47:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level48:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level49:
   .byte 102   ; number of pellets
   .byte 2     ; number of bars
   .byte 9,11, 18,8

__level_changing: .byte 0

.macro LOAD_LEVEL_PARAM param ; Input:
                              ;  param: param offset
                              ; Output:
                              ;  A: value of param
                              ;  Y: param offset
                              ;  ZP_PTR_1: level params address
   lda level
   asl
   tax
   lda level_table,x
   sta ZP_PTR_1
   lda level_table+1,x
   sta ZP_PTR_1+1
   ldy #param
   lda (ZP_PTR_1),y
.endmacro

level_tick:
   bra @start
@hscroll: .word 0
@vscroll: .word 0
@level_hscroll: .word 0
@level_vscroll: .word 0
@start:
   lda __level_changing
   bne @scroll
   jmp @return
@scroll:
   stz VERA_ctrl
   lda #<(VRAM_layer1+6)
   sta VERA_addr_low
   lda #>VRAM_layer1
   sta VERA_addr_high
   lda #(^VRAM_layer1 | $10)
   sta VERA_addr_bank
   lda VERA_data
   sta @hscroll
   lda VERA_data
   sta @hscroll+1
   lda VERA_data
   sta @vscroll
   lda VERA_data
   sta @vscroll+1
   LOAD_LEVEL_PARAM LEVEL_HSCROLL
   sta @level_hscroll
   iny
   lda (ZP_PTR_1),y
   sta @level_hscroll+1
   iny
   lda (ZP_PTR_1),y
   sta @level_vscroll
   iny
   lda (ZP_PTR_1),y
   sta @level_vscroll+1
   sec
   lda @level_hscroll
   sbc @hscroll
   sta @level_hscroll
   lda @level_hscroll+1
   sbc @hscroll+1
   sta @level_hscroll+1
   bmi @scroll_left
   beq @check_h_eq
   bra @scroll_right
@check_h_eq:
   lda @level_hscroll
   bne @scroll_left
   sec
   lda @level_vscroll
   sbc @vscroll
   sta @level_vscroll
   lda @level_vscroll+1
   sbc @vscroll+1
   sta @level_vscroll+1
   bmi @scroll_up
   beq @check_v_eq
   bra @scroll_down
@check_v_eq:
   lda @level_vscroll
   bne @scroll_down
   stz __level_changing
   bra @return
@scroll_left:
   sec
   lda @hscroll
   sbc #HSCROLL_STEP
   sta @hscroll
   lda @hscroll+1
   sbc #0
   sta @hscroll+1
   bra @set_scroll
@scroll_right:
   clc
   lda @hscroll
   adc #HSCROLL_STEP
   sta @hscroll
   lda @hscroll+1
   adc #0
   sta @hscroll+1
   bra @set_scroll
@scroll_up:
   sec
   lda @vscroll
   sbc #VSCROLL_STEP
   sta @vscroll
   lda @vscroll+1
   sbc #0
   sta @vscroll+1
   bra @set_scroll
@scroll_down:
   clc
   lda @vscroll
   adc #VSCROLL_STEP
   sta @vscroll
   lda @vscroll+1
   adc #0
   sta @vscroll+1
   bra @set_scroll
@set_scroll:
   stz VERA_ctrl
   lda #<(VRAM_layer1+6)
   sta VERA_addr_low
   lda #>VRAM_layer1
   sta VERA_addr_high
   lda #(^VRAM_layer1 | $10)
   sta VERA_addr_bank
   lda @hscroll
   sta VERA_data
   lda @hscroll+1
   sta VERA_data
   lda @vscroll
   sta VERA_data
   lda @vscroll+1
   sta VERA_data
@return:
   rts

clear_bars:
   LOAD_LEVEL_PARAM NUM_BARS
   tax               ; X = number of bars
   iny
   bra @loop
@xpos: .byte 0
@ypos: .byte 0
@loop:
   cpx #0
   beq @return
   lda (ZP_PTR_1),y
   sta @xpos
   iny
   lda (ZP_PTR_1),y
   sta @ypos
   iny
   dex
   phx
   phy
   lda #1
   ldx @xpos
   ldy @ypos
   jsr xy2vaddr
   stz VERA_ctrl
   ora #$10
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   lda #<BLANK
   sta VERA_data
   lda #>BLANK
   sta VERA_data
   ply
   plx
   bra @loop
@return:
   rts

level_east:
   LOAD_LEVEL_PARAM EAST_NEIGHBOR
   sta level
   jsr level_transition
   lda #WEST_ENTRANCE_X
   sta move_x
   lda #WEST_ENTRANCE_Y
   sta move_y
   rts

level_west:
   LOAD_LEVEL_PARAM WEST_NEIGHBOR
   sta level
   jsr level_transition
   lda #EAST_ENTRANCE_X
   sta move_x
   lda #EAST_ENTRANCE_Y
   sta move_y
   rts

level_south:
   LOAD_LEVEL_PARAM SOUTH_NEIGHBOR
   sta level
   jsr level_transition
   lda #NORTH_ENTRANCE_X
   sta move_x
   lda #NORTH_ENTRANCE_Y
   sta move_y
   rts

level_north:
   LOAD_LEVEL_PARAM NORTH_NEIGHBOR
   sta level
   jsr level_transition
   lda #SOUTH_ENTRANCE_X
   sta move_x
   lda #SOUTH_ENTRANCE_Y
   sta move_y
   rts

level_transition:
   LOAD_LEVEL_PARAM NUM_PELLETS
   sta pellets
   iny
   lda (ZP_PTR_1),y ; new level?
   beq @req_move
   lda #0
   sta (ZP_PTR_1),y
   SET_TIMER 64, @regenerate
   bra @start_transition
@req_move:
   SET_TIMER 64, @move
@start_transition:
   lda #1
   sta __level_changing
   rts
@regenerate:
   lda #1
   sta regenerate_req
   jmp timer_done
@move:
   lda #1
   sta move_req
   jmp timer_done

.endif
