.ifndef LEVELS_INC
LEVELS_INC = 1

LEVEL_X  = 10
LEVEL_Y  = 0

.include "globals.asm"

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
   .byte 9     ; east neighbor
   .byte 0     ; west neighbor
   .byte 2     ; south neighbor
   .byte 0     ; north neighbor
   .byte 2     ; number of bars
   .byte 9,11, 18,8  ; x,y coordinates of each bar tile

level2:
   .byte 102   ; number of pellets
   .byte 10
   .byte 0
   .byte 3
   .byte 1
   .byte 3     ; number of bars
   .byte 9,11, 18,8, 9,2

level3:
   .byte 102   ; number of pellets
   .byte 11
   .byte 0
   .byte 4
   .byte 2
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level4:
   .byte 102   ; number of pellets
   .byte 12
   .byte 0
   .byte 5
   .byte 3
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level5:
   .byte 102   ; number of pellets
   .byte 13
   .byte 0
   .byte 6
   .byte 4
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level6:
   .byte 102   ; number of pellets
   .byte 14
   .byte 0
   .byte 7
   .byte 5
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level7:
   .byte 102   ; number of pellets
   .byte 15
   .byte 0
   .byte 8
   .byte 6
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level8:
   .byte 102   ; number of pellets
   .byte 16
   .byte 0
   .byte 0
   .byte 7
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level9:
   .byte 102   ; number of pellets
   .byte 17
   .byte 1
   .byte 10
   .byte 0
   .byte 2     ; number of bars
   .byte 9,11, 18,8

level10:
   .byte 102   ; number of pellets
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

.endif
