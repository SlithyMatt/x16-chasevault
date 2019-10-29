.ifndef SPRITE_INC
SPRITE_INC = 1

.include "x16.inc"

.ifndef VRAM_SPRITES
VRAM_SPRITES = $0E000
.endif

sprite_frame:     ; A: frame
                  ; X: sprite index
   asl
   asl
   pha
   stz VERA_ctrl
   txa
   asl
   asl
   asl
   sta VERA_addr_low
   txa
   lsr
   lsr
   lsr
   lsr
   lsr
   ora #>VRAM_sprattr
   sta VERA_addr_high
   lda #(^VRAM_sprattr | $10)
   sta VERA_addr_bank
   pla
   clc
   adc #<(VRAM_SPRITES >> 5)
   sta VERA_data
   lda #0
   adc #>(VRAM_SPRITES >> 5)
   sta VERA_data
   rts


sprite_getpos: ; Input:
               ; A: sprite index
               ; Output:
               ; A: tile overlap (n:ne:e:se:s:sw:w:nw)
               ; X: tile x
               ; Y: tile y
   ; TODO: get sprite position, overlap bitmap
   rts

.endif
