.include "x16.inc"

.org $080D
.segment "STARTUP"
.segment "INIT"
.segment "ONCE"
.segment "CODE"
   jmp start

.include "filenames.asm"
.include "loadbank.asm"
.include "irq.asm"
.include "globals.asm"
.include "music.asm"

.macro PRINT_STRING str_arg
   .scope
         jmp end_string
      string_begin: .byte str_arg
      end_string:
         lda #<string_begin
         sta ZP_PTR_1
         lda #>string_begin
         sta ZP_PTR_1+1
         ldx #(end_string-string_begin)
         ldy #0
      loop:
         lda (ZP_PTR_1),y
         jsr CHROUT
         iny
         dex
         bne loop
   .endscope
.endmacro

.macro PRINT_CR
   lda #$0D
   jsr CHROUT
.endmacro

start:

   PRINT_STRING "playing music.bin"
   PRINT_CR
   PRINT_STRING "press spacebar to stop playback"
   PRINT_CR

   ; store additional binaries to banked RAM
   jsr loadbank

   ; setup interrupts
   jsr init_irq


mainloop:
   wai
   lda vsync_trig
   beq mainloop
   jsr GETIN
   cmp #$20
   bne @continue
   jsr stop_music
   PRINT_CR
   bra @exit
@continue:
   jsr music_tick
   stz vsync_trig
   bra mainloop
@exit:
   rts
