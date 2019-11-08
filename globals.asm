.ifndef GLOBALS_INC
GLOBALS_INC = 1

; ------------ Constants ------------

; sprite indices
PLAYER_idx     = 1
ENEMY1_idx     = 2
ENEMY2_idx     = 3
ENEMY3_idx     = 4
ENEMY4_idx     = 5
FRUIT_idx      = 6

ACTIVE_ENEMY_L = $0E400
ACTIVE_ENEMY_H = $0E600
VULN_ENEMY     = $0E680

SCOREBOARD_X   = 10
SCOREBOARD_Y   = 1

TICK_MOVEMENT  = 1

DIR_RIGHT   = 0
DIR_LEFT    = 1
DIR_DOWN    = 2
DIR_UP      = 3

; --------- Global Variables ---------

player:     .byte 0 ; 7-4 (TBD) | 3:2 - direction | 1 - movable | 0 - animated
;                                 0:R,1:L,2:D,3:U
lives:      .byte 4
level:      .byte 1
score:      .dword 0    ; BCD
pellets:    .byte 101
keys:       .byte 0

score_mult: .byte 1

release_e3: .byte 71 ; pellets remaining to release enemy 3
release_e4: .byte 33 ; pellets remaining to release enemy 4

.endif
