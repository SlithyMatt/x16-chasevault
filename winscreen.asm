.ifndef WINSCREEN_INC
WINSCREEN_INC = 1

.include "x16.inc"
.include "globals.asm"
.include "levels.asm"
.include "fruit.asm"
.include "music.asm"

WS_MAX_SCROLL = 704

__ws_scroll:  .word 320
__ws_reqd:    .byte 0
__ws_delay:   .byte 120

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
   ; Setup tiles on layer 1
   lda #$12                      ; 64x32 map of 4bpp tiles
   sta VERA_L1_config
   lda #((VRAM_STARTSCRN >> 9) & $FF)
   sta VERA_L1_mapbase
   lda #((((VRAM_TILES >> 11) & $3F) << 2) | $03)  ; 16x16 tiles
   sta VERA_L1_tilebase
   lda __ws_scroll               ; initial scroll position on screen
   sta VERA_L1_hscroll_l
   lda __ws_scroll+1
   sta VERA_L1_hscroll_h
   stz VERA_L1_vscroll_l
   stz VERA_L1_vscroll_h
   lda #7                        ; blackout background
   sta BITMAP_PO
   jmp @return
@check_scroll:
   dec __ws_delay
   bne @return
   lda #5
   sta __ws_delay
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
   lda __ws_scroll
   sta VERA_L1_hscroll_l
   lda __ws_scroll+1
   sta VERA_L1_hscroll_h
@return:
   rts

.endif
