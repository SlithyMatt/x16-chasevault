.ifndef WINSCREEN_INC
WINSCREEN_INC = 1

.include "x16.inc"
.include "globals.asm"
.include "levels.asm"
.include "fruit.asm"

WS_MAX_SCROLL = 704

__ws_scroll:  .word 320
__ws_reqd:    .byte 0

winscreen_tick:
   lda winscreen_req
   bne @start
   jmp @return
@start:
   lda __ws_reqd
   bne @check_scroll
   inc __ws_reqd
   lda #PLAYER_idx
   jsr sprite_disable
   jsr bomb_clear
   jsr fruit_clear
   stz VERA_ctrl
   VERA_SET_ADDR VRAM_layer1, 1
   lda #$61                      ; 4bpp tiles
   sta VERA_data0
   lda #$31                      ; 64x32 map of 16x16 tiles
   sta VERA_data0
   lda #((VRAM_STARTSCRN >> 2) & $FF)
   sta VERA_data0
   lda #((VRAM_STARTSCRN >> 10) & $FF)
   sta VERA_data0
   lda #((VRAM_TILES >> 2) & $FF)
   sta VERA_data0
   lda #((VRAM_TILES >> 10) & $FF)
   sta VERA_data0
   lda __ws_scroll               ; initial scroll position on screen
   sta VERA_data0
   lda __ws_scroll+1
   sta VERA_data0
   lda #0
   sta VERA_data0
   sta VERA_data0
   lda #7                        ; blackout background
   jsr set_bg_palette
   jmp @return
@check_scroll:
   clc
   lda __ws_scroll
   adc #1
   sta __ws_scroll
   lda __ws_scroll+1
   adc #0
   sta __ws_scroll+1
   lda __ws_scroll
   cmp #<WS_MAX_SCROLL
   bne @scroll
   lda __ws_scroll+1
   cmp #>WS_MAX_SCROLL
   bne @scroll
   stz winscreen_req
   jsr stop_music_loop
   jmp @return
@scroll:
   stz VERA_ctrl
   lda #<(VRAM_layer1+6)
   sta VERA_addr_low
   lda #>VRAM_layer1
   sta VERA_addr_high
   lda #(^VRAM_layer1 | $10)
   sta VERA_addr_bank
   lda __ws_scroll
   sta VERA_data0
   lda __ws_scroll+1
   sta VERA_data0
@return:
   rts

.endif
