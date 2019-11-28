.ifndef LEVELS_INC
LEVELS_INC = 1

.include "x16.inc"
.include "globals.asm"
.include "timer.asm"

LEVEL_X  = 10
LEVEL_Y  = 0

NORTH_ENTRANCE_X = 9
NORTH_ENTRANCE_Y = 1
EAST_ENTRANCE_X = 19
EAST_ENTRANCE_Y = 8
SOUTH_ENTRANCE_X = 9
SOUTH_ENTRANCE_Y = 14
WEST_ENTRANCE_X = 1
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
L_RELEASE_E3 = 10
L_RELEASE_E4 = 11
L_SHOW_FRUIT = 12
L_FRUIT_FRAME  = 13
L_SCATTER      = 14
L_CHASE        = 16
L_VULN         = 18
NUM_BARS       = 19

level_table:   ; table of level data structures
   .word 0
   .word level1,  level2,  level3,  level4
   .word level5,  level6,  level7,  level8,  level9
   .word level10, level11, level12, level13, level14
   .word level15, level16, level17, level18, level19
   .word level20, level21, level22, level23, level24
   .word level25, level26, level27, level28, level29
   .word level30, level31, level32, level33, level34
   .word level35, level36, level37, level38, level39
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
   .byte 71    ; release_e3
   .byte 33    ; release_e4
   .byte 51    ; show_fruit
   .byte BANANA_FRAME ; fruit_frame
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 90    ; vuln_time
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
   .byte 76    ; release_e3
   .byte 35    ; release_e4
   .byte 54    ; show_fruit
   .byte MANGO_FRAME
   .word 270   ; scatter_time
   .word 900   ; chase_time
   .byte 88    ; vuln_time
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
   .byte 71    ; release_e3
   .byte 33    ; release_e4
   .byte 50    ; show_fruit
   .byte GUAVA_FRAME
   .word 270   ; scatter_time
   .word 930  ; chase_time
   .byte 86    ; vuln_time
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
   .byte 71    ; release_e3
   .byte 33    ; release_e4
   .byte 50    ; show_fruit
   .byte GRAPEFRUIT_FRAME
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 84    ; vuln_time
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
   .byte 71    ; release_e3
   .byte 33    ; release_e4
   .byte 50    ; show_fruit
   .byte CARAMBOLA_FRAME
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 82    ; vuln_time
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
   .byte 71    ; release_e3
   .byte 33    ; release_e4
   .byte 50    ; show_fruit
   .byte CHERRY_FRAME
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 80    ; vuln_time
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
   .byte 71    ; release_e3
   .byte 33    ; release_e4
   .byte 50    ; show_fruit
   .byte APPLE_FRAME
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 78    ; vuln_time
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
   .byte 71    ; release_e3
   .byte 33    ; release_e4
   .byte 50    ; show_fruit
   .byte BANANA_FRAME
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 76    ; vuln_time
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level9:
   .byte 100   ; number of pellets
   .byte 1
   .byte 17
   .byte 1
   .byte 10
   .byte 0
   .word 320
   .word 0
   .byte 80    ; release_e3
   .byte 50    ; release_e4
   .byte 60    ; show_fruit
   .byte MANGO_FRAME
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 75    ; vuln_time
   .byte 3     ; number of bars
   .byte 0,8, 9,12, 18,8

level10:
   .byte 102   ; number of pellets
   .byte 1     ; new
   .byte 18    ; east neighbor
   .byte 2     ; west neighbor
   .byte 11    ; south neighbor
   .byte 9     ; north neighbor
   .word 320   ; hscroll
   .word 240   ; vscroll
   .byte 80    ; release_e3
   .byte 50    ; release_e4
   .byte 60    ; show_fruit
   .byte GUAVA_FRAME
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 75    ; vuln_time
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level11:
   .byte 102   ; number of pellets
   .byte 1     ; new
   .byte 19    ; east neighbor
   .byte 3     ; west neighbor
   .byte 12    ; south neighbor
   .byte 10    ; north neighbor
   .word 320   ; hscroll
   .word 480   ; vscroll
   .byte 80    ; release_e3
   .byte 50    ; release_e4
   .byte 60    ; show_fruit
   .byte GRAPEFRUIT_FRAME
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 75    ; vuln_time
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level12:
   .byte 102   ; number of pellets
   .byte 1     ; new
   .byte 20    ; east neighbor
   .byte 4     ; west neighbor
   .byte 13    ; south neighbor
   .byte 11    ; north neighbor
   .word 320   ; hscroll
   .word 720   ; vscroll
   .byte 80    ; release_e3
   .byte 50    ; release_e4
   .byte 60    ; show_fruit
   .byte CARAMBOLA_FRAME
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 75    ; vuln_time
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level13:
   .byte 102   ; number of pellets
   .byte 1     ; new
   .byte 21    ; east neighbor
   .byte 5     ; west neighbor
   .byte 14    ; south neighbor
   .byte 12    ; north neighbor
   .word 320   ; hscroll
   .word 960   ; vscroll
   .byte 80    ; release_e3
   .byte 50    ; release_e4
   .byte 60    ; show_fruit
   .byte CHERRY_FRAME
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 75    ; vuln_time
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level14:
   .byte 102   ; number of pellets
   .byte 1     ; new
   .byte 22    ; east neighbor
   .byte 6     ; west neighbor
   .byte 15    ; south neighbor
   .byte 13    ; north neighbor
   .word 320   ; hscroll
   .word 1200  ; vscroll
   .byte 80    ; release_e3
   .byte 50    ; release_e4
   .byte 60    ; show_fruit
   .byte APPLE_FRAME
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 75    ; vuln_time
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level15:
   .byte 102   ; number of pellets
   .byte 1     ; new
   .byte 23    ; east neighbor
   .byte 7     ; west neighbor
   .byte 16    ; south neighbor
   .byte 14    ; north neighbor
   .word 320   ; hscroll
   .word 1440  ; vscroll
   .byte 80    ; release_e3
   .byte 50    ; release_e4
   .byte 60    ; show_fruit
   .byte BANANA_FRAME
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 75    ; vuln_time
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level16:
   .byte 102   ; number of pellets
   .byte 1     ; new
   .byte 24    ; east neighbor
   .byte 8     ; west neighbor
   .byte 0     ; south neighbor
   .byte 15    ; north neighbor
   .word 320   ; hscroll
   .word 1680  ; vscroll
   .byte 80    ; release_e3
   .byte 50    ; release_e4
   .byte 60    ; show_fruit
   .byte MANGO_FRAME
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 75    ; vuln_time
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

__level_fade_out: .byte 0
__level_fade_in:  .byte 0

.macro LOAD_LEVEL_PARAM param ; Input:
                              ;  param: param offset
                              ;  ZP_PTR_1: level params address
                              ; Output:
                              ;  A: value of param
                              ;  Y: param offset
                              ;  ZP_PTR_1: level params address
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
   lda frame_num
   cmp __level_fade_out
   bne @check_fade_in
   lda #7   ; fade to black
   jsr set_bg_palette
   bra @load_curr_scroll
@check_fade_in:
   cmp __level_fade_in
   bne @load_curr_scroll
   lda #14  ; start fade-in
   jsr set_bg_palette
@load_curr_scroll:
   stz VERA_ctrl
   lda #<(VRAM_layer1+6)
   sta VERA_addr_low
   lda #>VRAM_layer1
   sta VERA_addr_high
   lda #(^VRAM_layer1 | $10)
   sta VERA_addr_bank
   lda VERA_data0
   sta @hscroll
   lda VERA_data0
   sta @hscroll+1
   lda VERA_data0
   sta @vscroll
   lda VERA_data0
   sta @vscroll+1
   jsr select_level
   LOAD_LEVEL_PARAM LEVEL_HSCROLL
   sta @level_hscroll
   iny
   lda (ZP_PTR_1),y
   sta @level_hscroll+1
   LOAD_LEVEL_PARAM LEVEL_VSCROLL
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
   bne @scroll_right
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
   lda #15
   jsr set_bg_palette
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
   sta VERA_data0
   lda @hscroll+1
   sta VERA_data0
   lda @vscroll
   sta VERA_data0
   lda @vscroll+1
   sta VERA_data0
@return:
   rts

select_level: ; Output: ZP_PTR_1: level params address
   lda level
   asl
   tax
   lda level_table,x
   sta ZP_PTR_1
   lda level_table+1,x
   sta ZP_PTR_1+1
   rts

clear_bars:
   jsr select_level
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
   sta VERA_data0
   lda #>BLANK
   sta VERA_data0
   ply
   plx
   bra @loop
@return:
   rts

level_east:
   jsr select_level
   LOAD_LEVEL_PARAM EAST_NEIGHBOR
   sta level
   jsr level_transition
   lda #WEST_ENTRANCE_X
   sta move_x
   lda #WEST_ENTRANCE_Y
   sta move_y
   rts

level_west:
   jsr select_level
   LOAD_LEVEL_PARAM WEST_NEIGHBOR
   sta level
   jsr level_transition
   lda #EAST_ENTRANCE_X
   sta move_x
   lda #EAST_ENTRANCE_Y
   sta move_y
   rts

level_south:
   jsr select_level
   LOAD_LEVEL_PARAM SOUTH_NEIGHBOR
   sta level
   jsr level_transition
   lda #NORTH_ENTRANCE_X
   sta move_x
   lda #NORTH_ENTRANCE_Y
   sta move_y
   rts

level_north:
   jsr select_level
   LOAD_LEVEL_PARAM NORTH_NEIGHBOR
   sta level
   jsr level_transition
   lda #SOUTH_ENTRANCE_X
   sta move_x
   lda #SOUTH_ENTRANCE_Y
   sta move_y
   rts

level_restore:
   bra @start
@hscroll: .word 0
@vscroll: .word 0
@source: .byte 0,0,0
@dest:   .byte 0,0,0
@start:
   jsr select_level
   LOAD_LEVEL_PARAM NUM_PELLETS
   sta pellets
   LOAD_LEVEL_PARAM LEVEL_HSCROLL
   sta @hscroll
   iny
   lda (ZP_PTR_1),y
   sta @hscroll+1
   LOAD_LEVEL_PARAM LEVEL_VSCROLL
   sta @vscroll
   iny
   lda (ZP_PTR_1),y
   sta @vscroll+1
   ; dest VRAM = VRAM_TILEMAP + hscroll/8 + 16*vscroll
   lsr @hscroll+1
   ror @hscroll
   lsr @hscroll+1
   ror @hscroll
   lsr @hscroll+1
   ror @hscroll
   asl @vscroll
   rol @vscroll+1
   asl @vscroll
   rol @vscroll+1
   asl @vscroll
   rol @vscroll+1
   asl @vscroll
   rol @vscroll+1
   clc
   lda #<VRAM_TILEMAP
   adc @hscroll
   sta @dest
   lda #>VRAM_TILEMAP
   adc @hscroll+1
   sta @dest+1
   lda #(^VRAM_TILEMAP | $10)
   adc #0
   sta @dest+2
   clc
   lda @dest
   adc @vscroll
   sta @dest
   lda @dest+1
   adc @vscroll+1
   sta @dest+1
   lda @dest+2
   adc #0
   sta @dest+2
   ; source = start screen, to reuse as backup buffer
   lda #<VRAM_STARTSCRN
   sta @source
   lda #>VRAM_STARTSCRN
   sta @source+1
   lda #(^VRAM_STARTSCRN | $10)
   sta @source+2
   ldy #15
@row_loop:
   ; set VERA port 1 to dest
   lda #1
   sta VERA_ctrl
   lda @dest
   sta VERA_addr_low
   lda @dest+1
   sta VERA_addr_high
   lda @dest+2
   sta VERA_addr_bank
   ; set VERA port 0 to source
   stz VERA_ctrl
   lda @source
   sta VERA_addr_low
   lda @source+1
   sta VERA_addr_high
   lda @source+2
   sta VERA_addr_bank
   ldx #40
@cell_loop:
   lda VERA_data0
   sta VERA_data1
   dex
   bne @cell_loop
   dey
   beq @return
   clc
   lda @source
   adc #$80
   sta @source
   lda @source+1
   adc #0
   sta @source+1
   lda @source+2
   adc #0
   sta @source+2
   clc
   lda @dest+1
   adc #1
   sta @dest+1
   lda @dest+2
   adc #0
   sta @dest+2
   jmp @row_loop
@return:
   rts

level_transition:
   ; start fade of background
   lda #14
   jsr set_bg_palette
   ; set fade out and in frame numbers
   clc
   lda frame_num
   adc #15
   cmp #60
   bmi @set_fade_in
   sec
   sbc #60
@set_fade_in:
   sta __level_fade_out
   clc
   adc #30
   cmp #60
   bmi @load_params
   sec
   sbc #60
@load_params:
   sta __level_fade_in
   jsr select_level
   LOAD_LEVEL_PARAM NUM_PELLETS
   sta pellets
   LOAD_LEVEL_PARAM L_RELEASE_E3
   sta release_e3
   LOAD_LEVEL_PARAM L_RELEASE_E4
   sta release_e4
   LOAD_LEVEL_PARAM L_SHOW_FRUIT
   sta show_fruit
   LOAD_LEVEL_PARAM L_FRUIT_FRAME
   sta fruit_frame
   LOAD_LEVEL_PARAM L_SCATTER
   sta scatter_time
   iny
   lda (ZP_PTR_1),y
   sta scatter_time+1
   LOAD_LEVEL_PARAM L_CHASE
   sta chase_time
   iny
   lda (ZP_PTR_1),y
   sta chase_time+1
   LOAD_LEVEL_PARAM NEW_LEVEL
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
   jsr level_backup
   lda #1
   sta regenerate_req
   jmp timer_done
@move:
   jsr level_backup
   lda #1
   sta move_req
   jmp timer_done

level_backup:
   bra @start
@hscroll: .word 0
@vscroll: .word 0
@source: .byte 0,0,0
@dest:   .byte 0,0,0
@start:
   jsr select_level
   LOAD_LEVEL_PARAM LEVEL_HSCROLL
   sta @hscroll
   iny
   lda (ZP_PTR_1),y
   sta @hscroll+1
   iny
   lda (ZP_PTR_1),y
   sta @vscroll
   iny
   lda (ZP_PTR_1),y
   sta @vscroll+1
   ; source VRAM = VRAM_TILEMAP + hscroll/8 + 16*vscroll
   lsr @hscroll+1
   ror @hscroll
   lsr @hscroll+1
   ror @hscroll
   lsr @hscroll+1
   ror @hscroll
   asl @vscroll
   rol @vscroll+1
   asl @vscroll
   rol @vscroll+1
   asl @vscroll
   rol @vscroll+1
   asl @vscroll
   rol @vscroll+1
   clc
   lda #<VRAM_TILEMAP
   adc @hscroll
   sta @source
   lda #>VRAM_TILEMAP
   adc @hscroll+1
   sta @source+1
   lda #(^VRAM_TILEMAP | $10)
   adc #0
   sta @source+2
   clc
   lda @source
   adc @vscroll
   sta @source
   lda @source+1
   adc @vscroll+1
   sta @source+1
   lda @source+2
   adc #0
   sta @source+2
   ; dest = start screen, to reuse as backup buffer
   lda #<VRAM_STARTSCRN
   sta @dest
   lda #>VRAM_STARTSCRN
   sta @dest+1
   lda #(^VRAM_STARTSCRN | $10)
   sta @dest+2
   ldy #15
@row_loop:
   ; set VERA port 1 to dest
   lda #1
   sta VERA_ctrl
   lda @dest
   sta VERA_addr_low
   lda @dest+1
   sta VERA_addr_high
   lda @dest+2
   sta VERA_addr_bank
   ; set VERA port 0 to source
   stz VERA_ctrl
   lda @source
   sta VERA_addr_low
   lda @source+1
   sta VERA_addr_high
   lda @source+2
   sta VERA_addr_bank
   ldx #40
@cell_loop:
   lda VERA_data0
   sta VERA_data1
   dex
   bne @cell_loop
   dey
   beq @return
   clc
   lda @source+1
   adc #1
   sta @source+1
   lda @source+2
   adc #0
   sta @source+2
   clc
   lda @dest
   adc #$80
   sta @dest
   lda @dest+1
   adc #0
   sta @dest+1
   lda @dest+2
   adc #0
   sta @dest+2
   jmp @row_loop
@return:
   rts

set_bg_palette: ; A: palette offset
   pha
   stz VERA_ctrl
   VERA_SET_ADDR $F2007, 0
   pla
   sta VERA_data0
   rts

.endif
