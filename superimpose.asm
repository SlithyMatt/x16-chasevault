.ifndef SUPERIMPOSE_INC
SUPERIMPOSE_INC = 1

.include "x16.inc"
.include "tilelib.asm"

ASCII_SPACE = $20

.macro SUPERIMPOSE str_arg, x_arg, y_arg
   .scope
         jmp end_string
      string_begin: .asciiz str_arg
      end_string:
         lda #<string_begin
         sta ZP_PTR_1
         lda #>string_begin
         sta ZP_PTR_1+1
         lda #<__superimpose_string
         sta ZP_PTR_2
         lda #>__superimpose_string
         sta ZP_PTR_2+1
         ldx #(end_string-string_begin-1)
         ldy #0
      loop:
         lda (ZP_PTR_1),y
         sta (ZP_PTR_2),y
         iny
         dex
         bne loop
         lda #1
         ldx #x_arg
         ldy #y_arg
         jsr xy2vaddr
         sta __superimpose_bank
         lda #$10
         ora __superimpose_bank
         sta __superimpose_bank
         lda #(end_string-string_begin-1)
         jsr __superimpose
   .endscope
.endmacro

.macro SUPERIMPOSE_RESTORE vaddr, length
   .if (.paramcount > 0)
      lda #(^vaddr | $10)
      sta __superimpose_bank
      ldx #<vaddr
      ldy #>vaddr
   .else
      ldx __superimpose_address
      ldy __superimpose_address+1
   .endif
   .if (.paramcount > 1)
      lda #length
   .else
      lda __superimpose_length
   .endif
   jsr __superimpose_restore
.endmacro


.macro __superimpose_args2veraloop
   stz VERA_ctrl
   lda __superimpose_bank
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   ldy #0               ; Y = tilemap address offset
   lda __superimpose_length
   clc
   adc __superimpose_length
   tax                  ; X = 2 x string length
   lda #<__superimpose_clipboard
   sta ZP_PTR_1         ; ZP_PTR_1 = clipboard
   lda #>__superimpose_clipboard
   sta ZP_PTR_1+1
.endmacro

__superimpose_clipboard:
.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

__superimpose_string:
.byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

__superimpose_length:
.byte 0

__superimpose_bank:
.byte 0

__superimpose_address:
.word 0

__superimpose: ; A: string length (max = 20)
               ; X/Y: tilemap address
               ; __superimpose_bank: tilemap bank
               ; __superimpose_string: string to superimpose
   sta __superimpose_length
   stx __superimpose_address
   sty __superimpose_address+1
   __superimpose_args2veraloop
@readloop:              ; store tiles to clipboard
   txa
   beq @write
   lda VERA_data0
   sta (ZP_PTR_1),y
   iny
   dex
   jmp @readloop
@write:
   lda __superimpose_address+1
   sta VERA_addr_high
   lda __superimpose_address
   sta VERA_addr_low
   lda #<__superimpose_string
   sta ZP_PTR_1         ; ZP_PTR_1 = string
   lda #>__superimpose_string
   sta ZP_PTR_1+1
   ldx __superimpose_length   ; X = string length
   ldy #0               ; Y = string index
@writeloop:             ; write character tiles to tilemap
   txa
   beq @end
   lda (ZP_PTR_1),y
   cmp #ASCII_SPACE
   bne @store_char
   lda #0               ; replace spaces with blank tiles
@store_char:
   sta VERA_data0        ; store character tile
   lda #0
   sta VERA_data0        ; store tile control (PO 0, no flip)
   iny
   dex
   jmp @writeloop
@end:
   rts

__superimpose_restore:  ; A: string length (max = 20)
                        ; X/Y: tilemap address (bank 0 assumed)
                        ; __superimpose_bank: tilemap bank
   sta __superimpose_length
   __superimpose_args2veraloop
@loop:
   txa
   beq @end
   lda (ZP_PTR_1),y
   sta VERA_data0
   iny
   dex
   jmp @loop
@end:
   rts

.endif
