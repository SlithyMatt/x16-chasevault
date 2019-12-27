.ifndef GLOBALS_INC
GLOBALS_INC = 1

; ---------- Build Options ----------
NUKE_ENABLED   = 0

; ------------ Constants ------------


VRAM_TILEMAP   = $04000 ; 128x128
VRAM_STARTSCRN = $0B800 ; 64x32
VRAM_SPRITES   = $0E000 ; 64 4bpp 16x16 frames
VRAM_TILES     = $10000 ; 212 4bpp 16x16 (may also be used as sprite frames)
VRAM_BITMAP    = $16A00 ; 4bpp 320x240


; sprite indices
PLAYER_idx     = 1
ENEMY1_idx     = 2
ENEMY2_idx     = 3
ENEMY3_idx     = 4
ENEMY4_idx     = 5
FRUIT_idx      = 6
FIREBALL1_idx  = 7
FIREBALL2_idx  = 8
FIREBALL3_idx  = 9
FIREBALL4_idx  = 10
BOMB_idx       = 11
SKULL_idx      = 12


ACTIVE_ENEMY_L = $0E400
ACTIVE_ENEMY_H = $0E600
VULN_ENEMY     = $0E680

TICK_MOVEMENT  = 1

DIR_RIGHT   = 0
DIR_LEFT    = 1
DIR_DOWN    = 2
DIR_UP      = 3

NO_FLIP     = $00
H_FLIP      = $01
V_FLIP      = $02
HV_FLIP     = $03

SPRITE_MIN_X  = 0
SPRITE_MIN_Y  = 2
SPRITE_MAX_X  = 19
SPRITE_MAX_Y  = 13

BANANA_FRAME      = 23
MANGO_FRAME       = 24
GUAVA_FRAME       = 25
GRAPEFRUIT_FRAME  = 26
CARAMBOLA_FRAME   = 27
CHERRY_FRAME      = 28
APPLE_FRAME       = 29

BITMAP_BANK       = 1
NORMX_BANK        = 6
NORMY_BANK        = 7
MUSIC_BANK        = 8

OPM_DELAY_REG   = 2
OPM_DONE_REG    = 4


; --------- Global Variables ---------

player:     .byte 0 ; 7-4 (TBD) | 3:2 - direction | 1 - movable | 0 - animated
;                                 0:R,1:L,2:D,3:U
lives:      .byte 4
level:      .byte 1     ; BCD
score:      .dword 0    ; BCD
pellets:    .byte 108
keys:       .byte 0

score_mult: .byte 1
max_lives:  .byte 4

release_e3:       .byte 71 ; pellets remaining to release enemy 3
release_e4:       .byte 33 ; pellets remaining to release enemy 4
show_fruit:       .byte 51 ; pellets remaining to show fruit
fruit_frame:      .byte 23 ; banana for level 1
scatter_time:     .word 300
chase_time:       .word 900
vuln_time:        .byte 90 ; Unit: 1/15 second (6 seconds)
num_fireballs:    .byte 0

regenerate_req:   .byte 0
move_req:         .byte 0
refresh_req:      .byte 0
winscreen_req:    .byte 0
move_x:           .byte 0
move_y:           .byte 0
start_prompt:     .byte 1
paused:           .byte 0
continue_prompt:  .byte 0
new_start:        .byte 0

.endif
