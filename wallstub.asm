.ifndef WALLSTUB_INC
WALLSTUB_INC = 1

__wallstub_table:
   ; right, no flip
   ; Tile:  0        1        2        3
   .byte $00,$00, $02,$04, $09,$00, $03,$00
   ;        4        5        6        7
   .byte $04,$00, $04,$08, $08,$04, $05,$0C
   ;        8        9        A        B
   .byte $03,$00, $09,$00, $0A,$00, $0B,$00
   ;        C        D        E        F
   .byte $0C,$00, $0D,$00, $0E,$00, $0F,$00
   ; right, H-flip
   .byte $00,$00, $02,$04, $02,$04, $03,$04
   .byte $04,$04, $05,$04, $08,$04, $05,$0C
   .byte $08,$04, $09,$04, $0A,$04, $0B,$04
   .byte $0C,$04, $0D,$04, $0E,$04, $0F,$04
   ; right, V-flip
   .byte $00,$00, $02,$08, $09,$08, $03,$08
   .byte $04,$08, $04,$00, $08,$04, $05,$04
   .byte $03,$08, $09,$08, $0A,$08, $0B,$08
   .byte $0C,$08, $0D,$08, $0E,$08, $0F,$08
   ; right, H/V-flip
   .byte $00,$00, $02,$08, $09,$0C, $03,$0C
   .byte $04,$0C, $05,$0C, $08,$04, $05,$04
   .byte $08,$0C, $09,$0C, $0A,$0C, $0B,$0C
   .byte $0C,$0C, $0D,$0C, $0E,$0C, $0F,$0C
   ; left, no flip
   .byte $00,$00, $02,$00, $02,$00, $03,$00
   .byte $04,$00, $05,$00, $08,$00, $05,$08
   .byte $08,$00, $09,$00, $0A,$00, $0B,$00
   .byte $0C,$00, $0D,$00, $0E,$00, $0F,$00
   ; left, H-flip
   .byte $00,$00, $02,$00, $09,$04, $03,$04
   .byte $04,$04, $04,$08, $08,$00, $03,$04
   .byte $03,$04, $09,$04, $0A,$04, $0B,$04
   .byte $0C,$04, $0D,$04, $0E,$04, $0F,$04
   ; left, V-flip
   .byte $00,$00, $02,$08, $02,$08, $03,$04
   .byte $04,$08, $05,$08, $08,$08, $05,$00
   .byte $08,$08, $09,$08, $0A,$08, $0B,$08
   .byte $0C,$08, $0D,$08, $0E,$08, $0F,$08
   ; left, H/V-flip
   .byte $00,$00, $02,$08, $09,$0C, $03,$0C
   .byte $04,$0C, $04,$04, $08,$08, $05,$00
   .byte $03,$0C, $09,$0C, $0A,$0C, $0B,$0C
   .byte $0C,$0C, $0D,$0C, $0E,$0C, $0F,$0C
   ; down, no flip
   .byte $00,$00, $01,$00, $02,$00, $04,$08
   .byte $09,$00, $05,$00, $07,$08, $01,$00
   .byte $05,$00, $09,$00, $0A,$00, $0B,$00
   .byte $0C,$00, $0D,$00, $0E,$00, $0F,$00
   ; down, H-flip
   .byte $00,$00, $01,$04, $02,$04, $04,$0C
   .byte $09,$04, $05,$04, $07,$0C, $01,$04
   .byte $05,$04, $09,$04, $0A,$04, $0B,$04
   .byte $0C,$04, $0D,$04, $0E,$04, $0F,$04
   ; down, V-flip
   .byte $00,$00, $01,$08, $02,$08, $04,$08
   .byte $04,$08, $02,$08, $07,$08, $07,$08
   .byte $05,$00, $09,$08, $0A,$08, $0B,$08
   .byte $0C,$08, $0D,$08, $0E,$08, $0F,$08
   ; down, H/V-flip
   .byte $00,$00, $01,$0C, $02,$0C, $04,$0C
   .byte $04,$0C, $02,$0C, $07,$0C, $07,$0C
   .byte $05,$04, $09,$0C, $0A,$0C, $0B,$0C
   .byte $0C,$0C, $0D,$0C, $0E,$0C, $0F,$0C
   ; up, no flip
   .byte $00,$00, $01,$00, $02,$00, $04,$00
   .byte $04,$00, $02,$00, $07,$00, $07,$00
   .byte $05,$08, $09,$00, $0A,$00, $0B,$00
   .byte $0C,$00, $0D,$00, $0E,$00, $0F,$00
   ; up, H-flip
   .byte $00,$00, $01,$04, $02,$04, $04,$04
   .byte $04,$04, $02,$04, $07,$04, $07,$04
   .byte $05,$0C, $09,$04, $0A,$04, $0B,$04
   .byte $0C,$04, $0D,$04, $0E,$04, $0F,$04
   ; up, V-flip
   .byte $00,$00, $01,$08, $02,$08, $04,$00
   .byte $09,$08, $05,$08, $07,$00, $07,$00
   .byte $05,$08, $09,$08, $0A,$08, $0B,$08
   .byte $0C,$08, $0D,$08, $0E,$08, $0F,$08
   ; up, H/V-flip
   .byte $00,$00, $01,$0C, $02,$0C, $04,$04
   .byte $09,$0C, $05,$0C, $07,$04, $01,$0C
   .byte $05,$0C, $09,$0C, $0A,$0C, $0B,$0C
   .byte $0C,$0C, $0D,$0C, $0E,$0C, $0F,$0C

__wallstub_dir: .byte 0
__wallstub_tile: .word 0
__wallstub_po: .byte 0

make_wall_stub:   ; Input:
                  ;  A: 0=right, 1=left, 2=down, 3=up
                  ;  X: tile x
                  ;  Y: tile y
   asl
   asl
   asl
   asl
   asl
   asl
   sta __wallstub_dir
   jsr xy2vaddr
   phx
   stz VERA_ctrl
   ora #$10
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   lda VERA_data
   sta __wallstub_tile
   lda VERA_data
   sta __wallstub_tile+1
   and #$F0
   sta __wallstub_po
   lda __wallstub_tile+1
   and #$0C
   asl
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
   plx
   stx VERA_addr_low
   sty VERA_addr_high
   lda __wallstub_tile
   sta VERA_data
   lda __wallstub_tile+1
   sta VERA_data
   rts

.endif
