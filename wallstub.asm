.ifndef WALLSTUB_INC
WALLSTUB_INC = 1

__wallstub_table:
   ; right, no flip
   ; Tile:  1        2        3        4
   .byte $02,$04, $09,$00, $03,$00, $04,$00
   ;        5        6        7        8
   .byte $04,$08, $08,$04, $05,$0C, $03,$00
   ; right, H-flip
   .byte $02,$04, $02,$04, $03,$04, $04,$04
   .byte $05,$04, $08,$04, $05,$0C, $08,$04
   ; right, V-flip
   .byte $02,$08, $09,$08, $03,$08, $04,$08
   .byte $04,$00, $08,$04, $05,$04, $03,$08
   ; right, H/V-flip
   .byte $02,$08, $09,$0C, $03,$0C, $04,$0C
   .byte $05,$0C, $08,$04, $05,$04, $08,$0C
   ; left, no flip
   .byte $02,$00, $02,$00, $03,$00, $04,$00
   .byte $05,$00, $08,$00, $05,$08, $08,$00
   ; left, H-flip
   .byte $02,$00, $09,$04, $03,$04, $04,$04
   .byte $04,$08, $08,$00, $03,$04, $03,$04
   ; left, V-flip
   .byte $02,$08, $02,$08, $03,$04, $04,$08
   .byte $05,$08, $08,$08, $05,$00, $08,$08
   ; left, H/V-flip
   .byte $02,$08, $09,$0C, $03,$0C, $04,$0C
   .byte $04,$04, $08,$08, $05,$00, $03,$0C
   ; down, no flip
   .byte $01,$00, $02,$00, $04,$08, $09,$00
   .byte $05,$00, $07,$0C, $01,$00, $05,$00
   ; down, H-flip
   .byte $01,$04, $02,$04, $04,$0C, $09,$04
   .byte $05,$04, $07,$0C, $01,$04, $05,$04
   ; down, V-flip
   .byte $01,$08, $02,$08, $04,$08, $04,$08
   .byte $02,$08, $07,$08, $07,$08, $05,$00
   ; down, H/V-flip
   .byte $01,$0C, $02,$0C, $04,$0C, $04,$0C
   .byte $02,$0C, $07,$0C, $07,$0C, $05,$04
   ; up, no flip
   .byte $01,$00, $02,$00, $04,$00, $04,$00
   .byte $02,$00, $07,$00, $07,$00, $05,$08
   ; up, H-flip
   .byte $01,$04, $02,$04, $04,$04, $04,$04
   .byte $02,$04, $07,$04, $07,$04, $05,$0C
   ; up, V-flip
   .byte $01,$08, $02,$08, $04,$00, $09,$08
   .byte $05,$08, $07,$00, $07,$00, $05,$08
   ; up, H/V-flip
   .byte $01,$0C, $02,$0C, $04,$04, $09,$0C
   .byte $05,$0C, $07,$04, $01,$0C, $05,$0C

__wallstub_dir: .byte 0
__wallstub_tile: .word 0
__wallstub_po: .byte 0

make_wall_stub:   ; Input:
                  ;  A: 0=right, 1=left, 2=down, 3=up
                  ;  X: tile x
                  ;  Y: tile y
   bra @start
@bank: .byte 0
@high: .byte 0
@low:  .byte 0
@start:
   asl
   asl
   asl
   asl
   asl
   sta __wallstub_dir
   lda #1
   jsr xy2vaddr
   stz VERA_ctrl
   ora #$10
   sta @bank
   sta VERA_addr_bank
   stx @low
   stx VERA_addr_low
   sty @high
   sty VERA_addr_high
   lda VERA_data0
   dec
   sta __wallstub_tile
   lda VERA_data0
   sta __wallstub_tile+1
   and #$F0
   sta __wallstub_po
   lda __wallstub_tile+1
   and #$0C
   asl
   ora __wallstub_tile
   ora __wallstub_dir
   asl
   tax
   lda __wallstub_table,x
   sta __wallstub_tile
   lda __wallstub_table+1,x
   ora __wallstub_po
   sta __wallstub_tile+1
   lda @bank
   sta VERA_addr_bank
   ldx @low
   stx VERA_addr_low
   ldy @high
   sty VERA_addr_high
   lda __wallstub_tile
   sta VERA_data0
   lda __wallstub_tile+1
   sta VERA_data0
   rts

.endif
