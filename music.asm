.ifndef MUSIC_INC
MUSIC_INC = 1

OPM_DELAY_REG   = 2
OPM_DONE_REG    = 4

__music_delay: .byte 0

.macro INC_MUSIC_PTR
   clc
   lda MUSIC_PTR
   adc #2
   sta MUSIC_PTR
   lda MUSIC_PTR+1
   adc #0
   sta MUSIC_PTR+1
.endmacro

init_music:
   stz __music_delay
   lda #<RAM_WIN
   sta MUSIC_PTR
   lda #>RAM_WIN
   sta MUSIC_PTR+1
   rts

music_tick:
   lda __music_delay
   beq @load
   dec __music_delay
   bra @return
@load:
   lda #MUSIC_BANK
   sta RAM_BANK
@loop:
   ldy #0
   lda (MUSIC_PTR),y
   iny
   cmp #OPM_DELAY_REG
   beq @delay
   cmp #OPM_DONE_REG
   beq @done
   bra @write
@delay:
   lda (MUSIC_PTR),y
   sta __music_delay
   INC_MUSIC_PTR
   bra @return
@done:
   jsr init_music
   bra @return
@write:
   sta YM_reg
   lda (MUSIC_PTR),y
   sta YM_data
   INC_MUSIC_PTR
   bra @loop
@return:
   rts

.endif
