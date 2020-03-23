.ifndef LEVELS_INC
LEVELS_INC = 1

.include "x16.inc"
.include "tiles.inc"
.include "globals.asm"
.include "timer.asm"
.include "skull.asm"
.include "bomb.asm"
.include "wallstub.asm"

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

NORTH_LOCK_X = 9
NORTH_LOCK_Y = 1
EAST_LOCK_X  = 19
EAST_LOCK_Y  = 8
SOUTH_LOCK_X = 9
SOUTH_LOCK_Y = 14
WEST_LOCK_X  = 0
WEST_LOCK_Y  = 8

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
SKULL_X        = 19
SKULL_Y        = 20
NUM_FIREBALLS  = 21
BOMB_X         = 22
BOMB_Y         = 23
NUM_BARS       = 24

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
   .word level45, level46, level47, level48

level1:
   .byte 108   ; number of pellets
   .byte 0     ; new
   .byte 9     ; east neighbor
   .byte 0     ; west neighbor
   .byte 2     ; south neighbor
   .byte 0     ; north neighbor
   .word 0     ; hscroll
   .word 0     ; yscroll
   .byte 71    ; release_e3
   .byte 33    ; release_e4
   .byte 54    ; show_fruit
   .byte BANANA_FRAME ; fruit_frame
   .word 300   ; scatter_time
   .word 900   ; chase_time
   .byte 90    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 2     ; number of bars
   .byte 9,12, 18,8  ; x,y coordinates of each bar tile

level2:
   .byte 102   ; number of pellets
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
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 9,11, 18,8, 9,2

level3:
   .byte 69    ; number of pellets
   .byte 1
   .byte 11
   .byte 0
   .byte 4
   .byte 2
   .word 0
   .word 480
   .byte 50    ; release_e3
   .byte 33    ; release_e4
   .byte 40    ; show_fruit
   .byte GUAVA_FRAME
   .word 270   ; scatter_time
   .word 930  ; chase_time
   .byte 86    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,13, 18,8, 15,11, 9,2

level4:
   .byte 101   ; number of pellets
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
   .word 240   ; scatter_time
   .word 930   ; chase_time
   .byte 84    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 9,2, 9,12, 17,8

level5:
   .byte 107   ; number of pellets
   .byte 1
   .byte 13
   .byte 0
   .byte 6
   .byte 4
   .word 0
   .word 960
   .byte 72    ; release_e3
   .byte 34    ; release_e4
   .byte 50    ; show_fruit
   .byte CARAMBOLA_FRAME
   .word 240   ; scatter_time
   .word 960   ; chase_time
   .byte 82    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 2,8, 9,2, 9,13, 18,8

level6:
   .byte 94   ; number of pellets
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
   .word 210   ; scatter_time
   .word 960   ; chase_time
   .byte 80    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 9,2, 9,12, 17,8

level7:
   .byte 42   ; number of pellets
   .byte 1
   .byte 15
   .byte 0
   .byte 8
   .byte 6
   .word 0
   .word 1440
   .byte 34    ; release_e3
   .byte 15    ; release_e4
   .byte 22    ; show_fruit
   .byte APPLE_FRAME
   .word 210   ; scatter_time
   .word 990   ; chase_time
   .byte 78    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 9,4, 9,11, 13,8

level8:
   .byte 107   ; number of pellets
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
   .word 180   ; scatter_time
   .word 990   ; chase_time
   .byte 76    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 2     ; number of bars
   .byte 9,2, 17,8

level9:
   .byte 99    ; number of pellets
   .byte 1
   .byte 17
   .byte 1
   .byte 10
   .byte 0
   .word 320
   .word 0
   .byte 80    ; release_e3
   .byte 50    ; release_e4
   .byte 40    ; show_fruit
   .byte MANGO_FRAME
   .word 180   ; scatter_time
   .word 1020  ; chase_time
   .byte 74    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 2,8, 9,12, 18,8

level10:
   .byte 101   ; number of pellets
   .byte 1     ; new
   .byte 18    ; east neighbor
   .byte 2     ; west neighbor
   .byte 11    ; south neighbor
   .byte 9     ; north neighbor
   .word 320   ; hscroll
   .word 240   ; vscroll
   .byte 80    ; release_e3
   .byte 50    ; release_e4
   .byte 40    ; show_fruit
   .byte GUAVA_FRAME
   .word 150   ; scatter_time
   .word 1020  ; chase_time
   .byte 72    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,4, 1,8, 18,8, 9,13

level11:
   .byte 109   ; number of pellets
   .byte 1     ; new
   .byte 19    ; east neighbor
   .byte 3     ; west neighbor
   .byte 12    ; south neighbor
   .byte 10    ; north neighbor
   .word 320   ; hscroll
   .word 480   ; vscroll
   .byte 82    ; release_e3
   .byte 51    ; release_e4
   .byte 40    ; show_fruit
   .byte GRAPEFRUIT_FRAME
   .word 150   ; scatter_time
   .word 1050  ; chase_time
   .byte 70    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,2, 1,8, 18,8, 9,12

level12:
   .byte 96   ; number of pellets
   .byte 1     ; new
   .byte 20    ; east neighbor
   .byte 4     ; west neighbor
   .byte 13    ; south neighbor
   .byte 11    ; north neighbor
   .word 320   ; hscroll
   .word 720   ; vscroll
   .byte 80    ; release_e3
   .byte 50    ; release_e4
   .byte 40    ; show_fruit
   .byte CARAMBOLA_FRAME
   .word 120   ; scatter_time
   .word 1050  ; chase_time
   .byte 68    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,2, 1,8, 17,8, 9,12

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
   .byte 40    ; show_fruit
   .byte CHERRY_FRAME
   .word 120   ; scatter_time
   .word 1080   ; chase_time
   .byte 66    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,2, 2,8, 18,8, 9,12

level14:
   .byte 98    ; number of pellets
   .byte 1     ; new
   .byte 22    ; east neighbor
   .byte 6     ; west neighbor
   .byte 15    ; south neighbor
   .byte 13    ; north neighbor
   .word 320   ; hscroll
   .word 1200  ; vscroll
   .byte 80    ; release_e3
   .byte 50    ; release_e4
   .byte 40    ; show_fruit
   .byte APPLE_FRAME
   .word 90    ; scatter_time
   .word 1080  ; chase_time
   .byte 64    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 1,8, 9,2, 10,12, 18,8

level15:
   .byte 89    ; number of pellets
   .byte 1     ; new
   .byte 23    ; east neighbor
   .byte 7     ; west neighbor
   .byte 16    ; south neighbor
   .byte 14    ; north neighbor
   .word 320   ; hscroll
   .word 1440  ; vscroll
   .byte 72    ; release_e3
   .byte 45    ; release_e4
   .byte 36    ; show_fruit
   .byte BANANA_FRAME
   .word 90    ; scatter_time
   .word 1100  ; chase_time
   .byte 62    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,4, 9,13, 17,6, 1,8

level16:
   .byte 99    ; number of pellets
   .byte 1     ; new
   .byte 24    ; east neighbor
   .byte 8     ; west neighbor
   .byte 0     ; south neighbor
   .byte 15    ; north neighbor
   .word 320   ; hscroll
   .word 1680  ; vscroll
   .byte 80    ; release_e3
   .byte 50    ; release_e4
   .byte 40    ; show_fruit
   .byte MANGO_FRAME
   .word 60    ; scatter_time
   .word 1100  ; chase_time
   .byte 60    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 9,2, 2,8, 17,8

level17:
   .byte 101   ; number of pellets
   .byte 1     ; new
   .byte 25    ; east neighbor
   .byte 9     ; west neighbor
   .byte 18    ; south neighbor
   .byte 0     ; north neighbor
   .word 640   ; hscroll
   .word 0     ; vscroll
   .byte 85    ; release_e3
   .byte 60    ; release_e4
   .byte 30    ; show_fruit
   .byte GUAVA_FRAME
   .word 60    ; scatter_time
   .word 1130  ; chase_time
   .byte 58    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 1,8, 9,11, 18,8

level18:
   .byte 107   ; number of pellets
   .byte 1     ; new
   .byte 26    ; east neighbor
   .byte 10    ; west neighbor
   .byte 19    ; south neighbor
   .byte 17    ; north neighbor
   .word 640   ; hscroll
   .word 240   ; vscroll
   .byte 87    ; release_e3
   .byte 61    ; release_e4
   .byte 30    ; show_fruit
   .byte GRAPEFRUIT_FRAME
   .word 45    ; scatter_time
   .word 1130  ; chase_time
   .byte 56    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,2, 1,8, 18,8, 9,12

level19:
   .byte 101   ; number of pellets
   .byte 1     ; new
   .byte 27    ; east neighbor
   .byte 11    ; west neighbor
   .byte 20    ; south neighbor
   .byte 18    ; north neighbor
   .word 640   ; hscroll
   .word 480   ; vscroll
   .byte 85    ; release_e3
   .byte 60    ; release_e4
   .byte 30    ; show_fruit
   .byte CARAMBOLA_FRAME
   .word 45    ; scatter_time
   .word 1160  ; chase_time
   .byte 54    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,2, 9,12, 1,8, 17,8

level20:
   .byte 101   ; number of pellets
   .byte 1     ; new
   .byte 28    ; east neighbor
   .byte 12    ; west neighbor
   .byte 21    ; south neighbor
   .byte 19    ; north neighbor
   .word 640   ; hscroll
   .word 720   ; vscroll
   .byte 85    ; release_e3
   .byte 60    ; release_e4
   .byte 30    ; show_fruit
   .byte CHERRY_FRAME
   .word 30    ; scatter_time
   .word 1160  ; chase_time
   .byte 52    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,4, 1,8, 18,8, 9,13

level21:
   .byte 99    ; number of pellets
   .byte 1     ; new
   .byte 29    ; east neighbor
   .byte 13    ; west neighbor
   .byte 22    ; south neighbor
   .byte 20    ; north neighbor
   .word 640   ; hscroll
   .word 960   ; vscroll
   .byte 85    ; release_e3
   .byte 60    ; release_e4
   .byte 30    ; show_fruit
   .byte APPLE_FRAME
   .word 30    ; scatter_time
   .word 1190  ; chase_time
   .byte 50    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,2, 2,8, 9,12, 18,8

level22:
   .byte 107   ; number of pellets
   .byte 1     ; new
   .byte 30    ; east neighbor
   .byte 14    ; west neighbor
   .byte 23    ; south neighbor
   .byte 21    ; north neighbor
   .word 640   ; hscroll
   .word 1200  ; vscroll
   .byte 85    ; release_e3
   .byte 60    ; release_e4
   .byte 30    ; show_fruit
   .byte BANANA_FRAME
   .word 15    ; scatter_time
   .word 1190  ; chase_time
   .byte 48    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 2,8, 9,2, 9,13, 18,8

level23:
   .byte 102   ; number of pellets
   .byte 1     ; new
   .byte 31    ; east neighbor
   .byte 15    ; west neighbor
   .byte 24    ; south neighbor
   .byte 22    ; north neighbor
   .word 640   ; hscroll
   .word 1440  ; vscroll
   .byte 85    ; release_e3
   .byte 60    ; release_e4
   .byte 30    ; show_fruit
   .byte MANGO_FRAME
   .word 15    ; scatter_time
   .word 1220  ; chase_time
   .byte 46    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,2, 2,8, 18,8, 9,12

level24:
   .byte 96    ; number of pellets
   .byte 1     ; new
   .byte 32    ; east neighbor
   .byte 16    ; west neighbor
   .byte 0     ; south neighbor
   .byte 23    ; north neighbor
   .word 640   ; hscroll
   .word 1680  ; vscroll
   .byte 85    ; release_e3
   .byte 60    ; release_e4
   .byte 30    ; show_fruit
   .byte GUAVA_FRAME
   .word 15    ; scatter_time
   .word 1230  ; chase_time
   .byte 44    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,2, 1,8, 17,8, 9,12

level25:
   .byte 11    ; number of pellets
   .byte 1     ; new
   .byte 0     ; east neighbor
   .byte 17    ; west neighbor
   .byte 26    ; south neighbor
   .byte 0     ; north neighbor
   .word 960   ; hscroll
   .word 0     ; vscroll
   .byte 8     ; release_e3
   .byte 5     ; release_e4
   .byte 0     ; show_fruit
   .byte GRAPEFRUIT_FRAME
   .word 10    ; scatter_time
   .word 1230  ; chase_time
   .byte 42    ; vuln_time
   .byte 4,5   ; skull placement
   .byte 2     ; no. fireballs
   .byte 11,10 ; bomb placement
   .byte 2     ; number of bars
   .byte 9,13, 1,8

level26:
   .byte 94   ; number of pellets
   .byte 1     ; new
   .byte 34    ; east neighbor
   .byte 18    ; west neighbor
   .byte 27    ; south neighbor
   .byte 25    ; north neighbor
   .word 960   ; hscroll
   .word 240   ; vscroll
   .byte 90    ; release_e3
   .byte 70    ; release_e4
   .byte 25    ; show_fruit
   .byte CARAMBOLA_FRAME
   .word 10    ; scatter_time
   .word 1260  ; chase_time
   .byte 40    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 1,8, 9,2, 9,12, 17,8

level27:
   .byte 98    ; number of pellets
   .byte 1     ; new
   .byte 35    ; east neighbor
   .byte 19    ; west neighbor
   .byte 28    ; south neighbor
   .byte 26    ; north neighbor
   .word 960   ; hscroll
   .word 480   ; vscroll
   .byte 90    ; release_e3
   .byte 70    ; release_e4
   .byte 25    ; show_fruit
   .byte CHERRY_FRAME
   .word 10    ; scatter_time
   .word 1290  ; chase_time
   .byte 38    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 1,8, 9,2, 10,12, 18,8

level28:
   .byte 99   ; number of pellets
   .byte 1     ; new
   .byte 36    ; east neighbor
   .byte 20    ; west neighbor
   .byte 0     ; south neighbor
   .byte 27    ; north neighbor
   .word 960   ; hscroll
   .word 720   ; vscroll
   .byte 90    ; release_e3
   .byte 70    ; release_e4
   .byte 25    ; show_fruit
   .byte APPLE_FRAME
   .word 10    ; scatter_time
   .word 1320  ; chase_time
   .byte 36    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 9,2, 2,8, 17,8

level29:
   .byte 20    ; number of pellets
   .byte 1     ; new
   .byte 37    ; east neighbor
   .byte 21    ; west neighbor
   .byte 0     ; south neighbor
   .byte 0     ; north neighbor
   .word 960   ; hscroll
   .word 960   ; vscroll
   .byte 18    ; release_e3
   .byte 16    ; release_e4
   .byte 0     ; show_fruit
   .byte BANANA_FRAME
   .word 10    ; scatter_time
   .word 1350  ; chase_time
   .byte 34    ; vuln_time
   .byte 16,12 ; skull placement
   .byte 2     ; no. fireballs
   .byte 9,13  ; bomb placement
   .byte 2     ; number of bars
   .byte 1,8, 18,8

level30:
   .byte 84   ; number of pellets
   .byte 1     ; new
   .byte 38    ; east neighbor
   .byte 22    ; west neighbor
   .byte 31    ; south neighbor
   .byte 29    ; north neighbor
   .word 960   ; hscroll
   .word 1200  ; vscroll
   .byte 72    ; release_e3
   .byte 56    ; release_e4
   .byte 20    ; show_fruit
   .byte MANGO_FRAME
   .word 10    ; scatter_time
   .word 1380  ; chase_time
   .byte 32    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 1,8, 9,4, 9,13

level31:
   .byte 109   ; number of pellets
   .byte 1     ; new
   .byte 39    ; east neighbor
   .byte 23    ; west neighbor
   .byte 32    ; south neighbor
   .byte 30    ; north neighbor
   .word 960   ; hscroll
   .word 1440  ; vscroll
   .byte 90    ; release_e3
   .byte 70    ; release_e4
   .byte 25    ; show_fruit
   .byte GUAVA_FRAME
   .word 10    ; scatter_time
   .word 1410  ; chase_time
   .byte 30    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,2, 1,8, 18,8, 9,12

level32:
   .byte 96    ; number of pellets
   .byte 1     ; new
   .byte 40    ; east neighbor
   .byte 24    ; west neighbor
   .byte 0     ; south neighbor
   .byte 31    ; north neighbor
   .word 960   ; hscroll
   .word 1680  ; vscroll
   .byte 90    ; release_e3
   .byte 70    ; release_e4
   .byte 25    ; show_fruit
   .byte GRAPEFRUIT_FRAME
   .word 10    ; scatter_time
   .word 1440  ; chase_time
   .byte 29    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,2, 9,12, 1,8, 17,8

level33:
   .byte 69    ; number of pellets
   .byte 1     ; new
   .byte 41    ; east neighbor
   .byte 0     ; west neighbor
   .byte 34    ; south neighbor
   .byte 0     ; north neighbor
   .word 1280  ; hscroll
   .word 0     ; vscroll
   .byte 100   ; release_e3
   .byte 80    ; release_e4
   .byte 20    ; show_fruit
   .byte CARAMBOLA_FRAME
   .word 5     ; scatter_time
   .word 1440  ; chase_time
   .byte 28    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 9,13, 18,8, 15,11

level34:
   .byte 21    ; number of pellets
   .byte 1     ; new
   .byte 0     ; east neighbor
   .byte 26    ; west neighbor
   .byte 0     ; south neighbor
   .byte 33    ; north neighbor
   .word 1280  ; hscroll
   .word 240   ; vscroll
   .byte 18    ; release_e3
   .byte 15    ; release_e4
   .byte 0     ; show_fruit
   .byte CHERRY_FRAME
   .word 5     ; scatter_time
   .word 1470  ; chase_time
   .byte 27    ; vuln_time
   .byte 3,11  ; skull placement
   .byte 3     ; no. fireballs
   .byte 11,10 ; bomb placement
   .byte 2     ; number of bars
   .byte 9,2, 1,8

level35:
   .byte 106   ; number of pellets
   .byte 1     ; new
   .byte 43    ; east neighbor
   .byte 27    ; west neighbor
   .byte 36    ; south neighbor
   .byte 0     ; north neighbor
   .word 1280  ; hscroll
   .word 480   ; vscroll
   .byte 100   ; release_e3
   .byte 80    ; release_e4
   .byte 20    ; show_fruit
   .byte APPLE_FRAME
   .word 5     ; scatter_time
   .word 1500  ; chase_time
   .byte 26    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 1,8, 9,12, 18,8

level36:
   .byte 96   ; number of pellets
   .byte 1     ; new
   .byte 44    ; east neighbor
   .byte 28    ; west neighbor
   .byte 37    ; south neighbor
   .byte 35    ; north neighbor
   .word 1280  ; hscroll
   .word 720   ; vscroll
   .byte 100   ; release_e3
   .byte 80    ; release_e4
   .byte 20    ; show_fruit
   .byte BANANA_FRAME
   .word 5     ; scatter_time
   .word 1530  ; chase_time
   .byte 25    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 1,8, 9,2, 9,12, 17,8

level37:
   .byte 102   ; number of pellets
   .byte 1     ; new
   .byte 0     ; east neighbor
   .byte 29    ; west neighbor
   .byte 0     ; south neighbor
   .byte 36    ; north neighbor
   .word 1280  ; hscroll
   .word 960   ; vscroll
   .byte 100   ; release_e3
   .byte 80    ; release_e4
   .byte 20    ; show_fruit
   .byte MANGO_FRAME
   .word 5     ; scatter_time
   .word 1560  ; chase_time
   .byte 24    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 3,8, 9,2, 17,8

level38:
   .byte 16    ; number of pellets
   .byte 1     ; new
   .byte 46    ; east neighbor
   .byte 0     ; west neighbor
   .byte 39    ; south neighbor
   .byte 0     ; north neighbor
   .word 1280  ; hscroll
   .word 1200  ; vscroll
   .byte 14    ; release_e3
   .byte 12    ; release_e4
   .byte 0     ; show_fruit
   .byte GUAVA_FRAME
   .word 5     ; scatter_time
   .word 1590  ; chase_time
   .byte 23    ; vuln_time
   .byte 17,4  ; skull placement
   .byte 3     ; no. fireballs
   .byte 6,7   ; bomb placement
   .byte 2     ; number of bars
   .byte 9,13, 18,8

level39:
   .byte 94    ; number of pellets
   .byte 1     ; new
   .byte 47    ; east neighbor
   .byte 31    ; west neighbor
   .byte 40    ; south neighbor
   .byte 38    ; north neighbor
   .word 1280  ; hscroll
   .word 1440  ; vscroll
   .byte 88    ; release_e3
   .byte 72    ; release_e4
   .byte 20    ; show_fruit
   .byte GRAPEFRUIT_FRAME
   .word 5     ; scatter_time
   .word 1620  ; chase_time
   .byte 23    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 4     ; number of bars
   .byte 9,4, 9,13, 1,8, 18,8

level40:
   .byte 105   ; number of pellets
   .byte 1     ; new
   .byte 0     ; east neighbor
   .byte 32    ; west neighbor
   .byte 0    ; south neighbor
   .byte 39    ; north neighbor
   .word 1280  ; hscroll
   .word 1680  ; vscroll
   .byte 100   ; release_e3
   .byte 80    ; release_e4
   .byte 20    ; show_fruit
   .byte CARAMBOLA_FRAME
   .word 5     ; scatter_time
   .word 1650  ; chase_time
   .byte 23    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 9,2, 9,12, 1,8

level41:
   .byte 11    ; number of pellets
   .byte 1     ; new
   .byte 0     ; east neighbor
   .byte 33    ; west neighbor
   .byte 42    ; south neighbor
   .byte 0     ; north neighbor
   .word 1600  ; hscroll
   .word 0     ; vscroll
   .byte 8     ; release_e3
   .byte 5     ; release_e4
   .byte 0     ; show_fruit
   .byte CHERRY_FRAME
   .word 10    ; scatter_time
   .word 1230  ; chase_time
   .byte 42    ; vuln_time
   .byte 2,4   ; skull placement
   .byte 4     ; no. fireballs
   .byte 11,10 ; bomb placement
   .byte 2     ; number of bars
   .byte 9,13, 1,8

level42:
   .byte 105   ; number of pellets
   .byte 1     ; new
   .byte 0     ; east neighbor
   .byte 0     ; west neighbor
   .byte 43    ; south neighbor
   .byte 41    ; north neighbor
   .word 1600  ; hscroll
   .word 240   ; vscroll
   .byte 100   ; release_e3
   .byte 90    ; release_e4
   .byte 15    ; show_fruit
   .byte APPLE_FRAME
   .word 1     ; scatter_time
   .word 1680  ; chase_time
   .byte 23    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 2     ; number of bars
   .byte 9,2, 9,12

level43:
   .byte 100   ; number of pellets
   .byte 1     ; new
   .byte 0     ; east neighbor
   .byte 35    ; west neighbor
   .byte 44    ; south neighbor
   .byte 42    ; north neighbor
   .word 1600  ; hscroll
   .word 480   ; vscroll
   .byte 98    ; release_e3
   .byte 90    ; release_e4
   .byte 15    ; show_fruit
   .byte BANANA_FRAME
   .word 1     ; scatter_time
   .word 1710  ; chase_time
   .byte 23    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 2     ; number of bars
   .byte 9,2, 9,12, 1,8

level44:
   .byte 95   ; number of pellets
   .byte 1     ; new
   .byte 0     ; east neighbor
   .byte 36    ; west neighbor
   .byte 45    ; south neighbor
   .byte 43    ; north neighbor
   .word 1600  ; hscroll
   .word 720   ; vscroll
   .byte 89    ; release_e3
   .byte 82    ; release_e4
   .byte 15    ; show_fruit
   .byte MANGO_FRAME
   .word 1     ; scatter_time
   .word 2000  ; chase_time
   .byte 23    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 9,4, 9,13, 1,8

level45:
   .byte 24    ; number of pellets
   .byte 1     ; new
   .byte 0     ; east neighbor
   .byte 0     ; west neighbor
   .byte 46    ; south neighbor
   .byte 44    ; north neighbor
   .word 1600  ; hscroll
   .word 960   ; vscroll
   .byte 100   ; release_e3
   .byte 100   ; release_e4
   .byte 0     ; show_fruit
   .byte GUAVA_FRAME
   .word 1     ; scatter_time
   .word 3000  ; chase_time
   .byte 23    ; vuln_time
   .byte 17,6  ; skull placement
   .byte 4     ; no. fireballs
   .byte 1,3   ; bomb placement
   .byte 2     ; number of bars
   .byte 9,13, 9,2

level46:
   .byte 97    ; number of pellets
   .byte 1     ; new
   .byte 0     ; east neighbor
   .byte 38    ; west neighbor
   .byte 47    ; south neighbor
   .byte 45    ; north neighbor
   .word 1600  ; hscroll
   .word 1200  ; vscroll
   .byte 94    ; release_e3
   .byte 92    ; release_e4
   .byte 10    ; show_fruit
   .byte GRAPEFRUIT_FRAME
   .word 1     ; scatter_time
   .word 4000  ; chase_time
   .byte 23    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 2     ; number of bars
   .byte 9,4, 9,13, 1,8

level47:
   .byte 109   ; number of pellets
   .byte 1     ; new
   .byte 0     ; east neighbor
   .byte 39    ; west neighbor
   .byte 48    ; south neighbor
   .byte 46    ; north neighbor
   .word 1600  ; hscroll
   .word 1440  ; vscroll
   .byte 107   ; release_e3
   .byte 105   ; release_e4
   .byte 10    ; show_fruit
   .byte CARAMBOLA_FRAME
   .word 1     ; scatter_time
   .word 5000  ; chase_time
   .byte 23    ; vuln_time
   .byte 0,0   ; skull placement
   .byte 0     ; no. fireballs
   .byte 0,0   ; bomb placement
   .byte 3     ; number of bars
   .byte 9,2, 9,12, 1,8

level48:
   .byte 93    ; number of pellets
   .byte 1     ; new
   .byte 0     ; east neighbor
   .byte 0     ; west neighbor
   .byte 0     ; south neighbor
   .byte 47    ; north neighbor
   .word 1600  ; hscroll
   .word 1680  ; vscroll
   .byte 88    ; release_e3
   .byte 86    ; release_e4
   .byte 10    ; show_fruit
   .byte CHERRY_FRAME
   .word 1     ; scatter_time
   .word 10000 ; chase_time
   .byte 23    ; vuln_time
   .byte 17,4  ; skull placement
   .byte 4     ; no. fireballs
   .byte 7,3   ; bomb placement
   .byte 1     ; number of bars
   .byte 9,2

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
   sta BITMAP_PO
   bra @load_curr_scroll
@check_fade_in:
   cmp __level_fade_in
   bne @load_curr_scroll
   lda #14  ; start fade-in
   sta BITMAP_PO
@load_curr_scroll:
   lda VERA_L1_hscroll_l
   sta @hscroll
   lda VERA_L1_hscroll_h
   sta @hscroll+1
   lda VERA_L1_vscroll_l
   sta @vscroll
   lda VERA_L1_vscroll_h
   sta @vscroll+1
   lda #0
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
   sta BITMAP_PO
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
   lda @hscroll
   sta VERA_L1_hscroll_l
   lda @hscroll+1
   sta VERA_L1_hscroll_h
   lda @vscroll
   sta VERA_L1_vscroll_l
   lda @vscroll+1
   sta VERA_L1_vscroll_h
@return:
   rts

select_level:  ; Input: A: level to select (current level if zero)
               ; Output: ZP_PTR_1: level params address
   cmp #0
   bne @select
   lda level
@select:
   asl
   tax
   lda level_table,x
   sta ZP_PTR_1
   lda level_table+1,x
   sta ZP_PTR_1+1
   rts

clear_bars:
   lda #0
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
   lda #0
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
   lda #0
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
   lda #0
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
   lda #0
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
   lda #0
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
   sta BITMAP_PO
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
   lda #0
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
   LOAD_LEVEL_PARAM L_VULN
   sta vuln_time
   LOAD_LEVEL_PARAM NUM_FIREBALLS
   sta num_fireballs
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
   jsr __level_prepare_locks
   jsr level_backup
   lda #1
   sta regenerate_req
   LOAD_LEVEL_PARAM BOMB_X
   beq @check_skull
   pha
   LOAD_LEVEL_PARAM BOMB_Y
   tay
   plx
   lda #1
   jsr bomb_place
@check_skull:
   LOAD_LEVEL_PARAM SKULL_X
   beq @done_regenerate
   pha
   LOAD_LEVEL_PARAM SKULL_Y
   tay
   plx
   lda #1
   jsr skull_place
@done_regenerate:
   jmp timer_done
@move:
   jsr __level_prepare_locks
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
   lda #0
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

__level_prepare_locks:
   lda #0
   jsr select_level
   LOAD_LEVEL_PARAM EAST_NEIGHBOR
   beq @check_west
   jsr select_level
   LOAD_LEVEL_PARAM NEW_LEVEL
   bne @check_west
   ldx #EAST_LOCK_X
   ldy #EAST_LOCK_Y
   jsr clear_vlock
@check_west:
   lda #0
   jsr select_level
   LOAD_LEVEL_PARAM WEST_NEIGHBOR
   beq @check_south
   jsr select_level
   LOAD_LEVEL_PARAM NEW_LEVEL
   bne @check_south
   ldx #WEST_LOCK_X
   ldy #WEST_LOCK_Y
   jsr clear_vlock
@check_south:
   lda #0
   jsr select_level
   LOAD_LEVEL_PARAM SOUTH_NEIGHBOR
   beq @check_north
   jsr select_level
   LOAD_LEVEL_PARAM NEW_LEVEL
   bne @check_north
   ldx #SOUTH_LOCK_X
   ldy #SOUTH_LOCK_Y
   jsr clear_hlock
@check_north:
   lda #0
   jsr select_level
   LOAD_LEVEL_PARAM NORTH_NEIGHBOR
   beq @return
   jsr select_level
   LOAD_LEVEL_PARAM NEW_LEVEL
   bne @return
   ldx #NORTH_LOCK_X
   ldy #NORTH_LOCK_Y
   jsr clear_hlock
@return:
   rts

clear_hlock:   ; Input:
               ;  X: tile x
               ;  Y: tile y
   phx
   phy
   lda #1
   jsr xy2vaddr
   stz VERA_ctrl
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   stz VERA_data0
   ply
   plx
   phx
   phy
   dex
   lda #DIR_RIGHT
   jsr make_wall_stub
   ply
   plx
   inx
   lda #DIR_LEFT
   jsr make_wall_stub
   rts

clear_vlock:   ; Input:
               ;  X: tile x
               ;  Y: tile y
   phx
   phy
   lda #1
   jsr xy2vaddr
   stz VERA_ctrl
   sta VERA_addr_bank
   stx VERA_addr_low
   sty VERA_addr_high
   stz VERA_data0
   ply
   plx
   phx
   phy
   dey
   lda #DIR_DOWN
   jsr make_wall_stub
   ply
   plx
   iny
   lda #DIR_UP
   jsr make_wall_stub
   rts

.endif
