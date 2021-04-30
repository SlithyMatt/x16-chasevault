.ifndef SOUNDFX_INC
SOUNDFX_INC = 1

.include "x16.inc"
.include "ym2151.inc"
.include "globals.asm"

sfx_death:
.byte YM_KEY_ON,     YM_CH_1
.byte YM_KC+YM_CH_1, YM_KC_OCT2 | YM_KC_C
.byte YM_KEY_ON,     YM_CH_1 | YM_SN_ALL
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_C
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_B_FL
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_1
.byte YM_KEY_ON,     YM_CH_1 | YM_SN_ALL
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_A
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_G
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_1
.byte YM_KEY_ON,     YM_CH_1 | YM_SN_ALL
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_F
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_E_FL
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_1
.byte YM_KEY_ON,     YM_CH_1 | YM_SN_ALL
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_D
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KC+YM_CH_4, YM_KC_OCT2 | YM_KC_C
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_1
.byte YM_KEY_ON,     YM_CH_1 | YM_SN_ALL
.byte OPM_DELAY_REG, 32
.byte YM_KEY_ON,     YM_CH_1
.byte YM_KEY_ON,     YM_CH_1 | YM_SN_ALL
.byte OPM_DELAY_REG, 32
.byte YM_KEY_ON,     YM_CH_1
.byte YM_KEY_ON,     YM_CH_4
.byte OPM_DONE_REG,  0

sfx_pellet:
.byte YM_KEY_ON,     YM_CH_5
.byte YM_KC+YM_CH_5, YM_KC_OCT6 | YM_KC_F
.byte YM_KEY_ON,     YM_CH_5 | YM_SN_ALL
.byte OPM_DELAY_REG, 16
.byte YM_KEY_ON,     YM_CH_5
.byte OPM_DONE_REG,  0

sfx_pwr_pellet:
.byte YM_KEY_ON,     YM_CH_5
.byte YM_KC+YM_CH_5, YM_KC_OCT5 | YM_KC_C
.byte YM_KEY_ON,     YM_CH_5 | YM_SN_ALL
.byte OPM_DELAY_REG, 16
.byte YM_KEY_ON,     YM_CH_5
.byte YM_KC+YM_CH_5, YM_KC_OCT6 | YM_KC_G
.byte YM_KEY_ON,     YM_CH_5 | YM_SN_ALL
.byte OPM_DELAY_REG, 24
.byte YM_KEY_ON,     YM_CH_5
.byte OPM_DONE_REG,  0

sfx_bomb:
.byte YM_KEY_ON,     YM_NOISE_OFF
.byte YM_NE_NFRQ,    YM_NE | $1E
.byte YM_KEY_ON,     YM_NOISE_ON
.byte OPM_DELAY_REG, 1
.byte YM_NE_NFRQ,    YM_NE | $1A
.byte OPM_DELAY_REG, 1
.byte YM_NE_NFRQ,    YM_NE | $16
.byte OPM_DELAY_REG, 1
.byte YM_NE_NFRQ,    YM_NE | $14
.byte OPM_DELAY_REG, 1
.byte YM_NE_NFRQ,    YM_NE | $12
.byte OPM_DELAY_REG, 2
.byte YM_NE_NFRQ,    YM_NE | $10
.byte OPM_DELAY_REG, 2
.byte YM_NE_NFRQ,    YM_NE | $0E
.byte OPM_DELAY_REG, 2
.byte YM_NE_NFRQ,    YM_NE | $0C
.byte OPM_DELAY_REG, 3
.byte YM_NE_NFRQ,    YM_NE | $0A
.byte OPM_DELAY_REG, 3
.byte YM_NE_NFRQ,    YM_NE | $08
.byte OPM_DELAY_REG, 3
.byte YM_NE_NFRQ,    YM_NE | $06
.byte OPM_DELAY_REG, 4
.byte YM_NE_NFRQ,    YM_NE | $04
.byte OPM_DELAY_REG, 7
.byte YM_NE_NFRQ,    YM_NE | $02
.byte OPM_DELAY_REG, 10
.byte YM_KEY_ON,     YM_NOISE_OFF
.byte YM_NE_NFRQ,    0
.byte OPM_DONE_REG,  0

sfx_key:
.byte YM_KEY_ON,     YM_CH_5
.byte YM_KC+YM_CH_5, YM_KC_OCT5 | YM_KC_C
.byte YM_KEY_ON,     YM_CH_5 | YM_SN_ALL
.byte YM_KEY_ON,     YM_CH_6
.byte YM_KC+YM_CH_6, YM_KC_OCT5 | YM_KC_F
.byte YM_KEY_ON,     YM_CH_6 | YM_SN_ALL
.byte OPM_DELAY_REG, 16
.byte YM_KEY_ON,     YM_CH_5
.byte YM_KC+YM_CH_5, YM_KC_OCT6 | YM_KC_B_FL
.byte YM_KEY_ON,     YM_CH_5 | YM_SN_ALL
.byte OPM_DELAY_REG, 24
.byte YM_KEY_ON,     YM_CH_5
.byte YM_KEY_ON,     YM_CH_6
.byte OPM_DONE_REG,  0

sfx_unlock:
.byte YM_KEY_ON,     YM_CH_5
.byte YM_KC+YM_CH_5, YM_KC_OCT3 | YM_KC_E_FL
.byte YM_KEY_ON,     YM_CH_5 | YM_SN_ALL
.byte YM_KEY_ON,     YM_CH_6
.byte YM_KC+YM_CH_6, YM_KC_OCT3 | YM_KC_D
.byte YM_KEY_ON,     YM_CH_6 | YM_SN_ALL
.byte YM_KEY_ON,     YM_NOISE_OFF
.byte OPM_DELAY_REG, 1
.byte YM_NE_NFRQ,    YM_NE | $05
.byte YM_KEY_ON,     YM_NOISE_ON
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_5
.byte YM_KEY_ON,     YM_CH_6
.byte YM_KEY_ON,     YM_NOISE_OFF
.byte YM_NE_NFRQ,    0
.byte OPM_DONE_REG,  0

sfx_ghost:
.byte YM_KEY_ON,     YM_CH_7
.byte YM_KC+YM_CH_7, YM_KC_OCT4 | YM_KC_C
.byte YM_KF+YM_CH_7, $00
.byte YM_KEY_ON,     YM_CH_7 | YM_SN_ALL
.byte OPM_DELAY_REG, 16
.byte YM_KC+YM_CH_7, YM_KC_OCT4 | YM_KC_B
.byte YM_KF+YM_CH_7, $B8
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $70
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $28
.byte OPM_DELAY_REG, 1
.byte YM_KC+YM_CH_7, YM_KC_OCT4 | YM_KC_B_FL
.byte YM_KF+YM_CH_7, $E0
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $98
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $50
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $08
.byte OPM_DELAY_REG, 1
.byte YM_KC+YM_CH_7, YM_KC_OCT4 | YM_KC_A
.byte YM_KF+YM_CH_7, $C0
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $78
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $30
.byte OPM_DELAY_REG, 1
.byte YM_KC+YM_CH_7, YM_KC_OCT4 | YM_KC_A_FL
.byte YM_KF+YM_CH_7, $E8
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $A0
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $58
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $10
.byte OPM_DELAY_REG, 1
.byte YM_KC+YM_CH_7, YM_KC_OCT4 | YM_KC_G
.byte YM_KF+YM_CH_7, $C8
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $80
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $38
.byte OPM_DELAY_REG, 1
.byte YM_KC+YM_CH_7, YM_KC_OCT4 | YM_KC_G_FL
.byte YM_KF+YM_CH_7, $F0
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $A8
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $60
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $18
.byte OPM_DELAY_REG, 1
.byte YM_KC+YM_CH_7, YM_KC_OCT4 | YM_KC_F
.byte YM_KF+YM_CH_7, $D0
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $88
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $40
.byte OPM_DELAY_REG, 1
.byte YM_KC+YM_CH_7, YM_KC_OCT4 | YM_KC_E
.byte YM_KF+YM_CH_7, $F8
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $B0
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $68
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $20
.byte OPM_DELAY_REG, 1
.byte YM_KC+YM_CH_7, YM_KC_OCT4 | YM_KC_E_FL
.byte YM_KF+YM_CH_7, $D8
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $90
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $48
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $00
.byte OPM_DELAY_REG, 1
.byte YM_KC+YM_CH_7, YM_KC_OCT4 | YM_KC_D
.byte YM_KF+YM_CH_7, $B8
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $70
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $28
.byte OPM_DELAY_REG, 1
.byte YM_KC+YM_CH_7, YM_KC_OCT4 | YM_KC_D_FL
.byte YM_KF+YM_CH_7, $E0
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $98
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $50
.byte OPM_DELAY_REG, 1
.byte YM_KF+YM_CH_7, $08
.byte OPM_DELAY_REG, 1
.byte YM_KC+YM_CH_7, YM_KC_OCT3 | YM_KC_C
.byte YM_KF+YM_CH_7, $00
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_7
.byte OPM_DONE_REG,  0

sfx_bars:
.byte YM_KEY_ON,     YM_CH_5
.byte YM_KC+YM_CH_5, YM_KC_OCT4 | YM_KC_B_FL
.byte YM_KEY_ON,     YM_CH_6
.byte YM_KC+YM_CH_6, YM_KC_OCT4 | YM_KC_E_FL
.byte YM_KEY_ON,     YM_CH_5 | YM_SN_ALL
.byte OPM_DELAY_REG, 16
.byte YM_KEY_ON,     YM_CH_5
.byte YM_KC+YM_CH_5, YM_KC_OCT3 | YM_KC_C
.byte YM_KEY_ON,     YM_CH_5 | YM_SN_ALL
.byte OPM_DELAY_REG, 24
.byte YM_KEY_ON,     YM_CH_5
.byte YM_KEY_ON,     YM_CH_6
.byte OPM_DONE_REG,  0

sfx_playing:
.byte 0  ; Bits 7-4: TBD
         ; Bit 7: bars | Bit 6: Ghost | Bit 5: Unlock | Bit 4: key/fruit
         ; Bit 3: bomb | Bit 2: power pellet | Bit 1: pellet | Bit 0: death

SFX_PLAYING_BARS        = $80
SFX_PLAYING_GHOST       = $40
SFX_PLAYING_UNLOCK      = $20
SFX_PLAYING_KEY         = $10
SFX_PLAYING_BOMB        = $08
SFX_PLAYING_PWR_PELLET  = $04
SFX_PLAYING_PELLET      = $02
SFX_PLAYING_DEATH       = $01

sfx_death_offset:
.byte 0
sfx_death_delay:
.byte 0

sfx_pellet_offset:
.byte 0
sfx_pellet_delay:
.byte 0

sfx_pwr_pellet_offset:
.byte 0
sfx_pwr_pellet_delay:
.byte 0

sfx_bomb_offset:
.byte 0
sfx_bomb_delay:
.byte 0

sfx_key_offset:
.byte 0
sfx_key_delay:
.byte 0

sfx_unlock_offset:
.byte 0
sfx_unlock_delay:
.byte 0

sfx_ghost_offset:
.byte 0
sfx_ghost_delay:
.byte 0

sfx_bars_offset:
.byte 0
sfx_bars_delay:
.byte 0


.macro SFX_PLAY data, offset, delay, playing_bit
   lda sfx_playing
   bit #playing_bit
   bne :+
   jmp :++++++
:  lda delay
   beq :+
   dec delay
   lda delay
   beq :+
   jmp :+++++
:  ldx offset
   lda data,x
   cmp #OPM_DELAY_REG
   beq :++
   cmp #OPM_DONE_REG
   beq :+++
:  bit YM_data
   bmi :-
   sta YM_reg
   inc offset
   ldx offset
   lda data,x
   sta YM_data
   inc offset
   bra :--
:  inc offset
   ldx offset
   lda data,x
   sta delay
   inc offset
   bra :++
:  inc offset
   inc offset
   lda sfx_playing
   eor #playing_bit
   sta sfx_playing
:  nop
.endmacro

sfx_tick:
   SFX_PLAY sfx_death, sfx_death_offset, sfx_death_delay, SFX_PLAYING_DEATH
   SFX_PLAY sfx_pellet, sfx_pellet_offset, sfx_pellet_delay, SFX_PLAYING_PELLET
   SFX_PLAY sfx_pwr_pellet, sfx_pwr_pellet_offset, sfx_pwr_pellet_delay, SFX_PLAYING_PWR_PELLET
   SFX_PLAY sfx_bomb, sfx_bomb_offset, sfx_bomb_delay, SFX_PLAYING_BOMB
   SFX_PLAY sfx_key, sfx_key_offset, sfx_key_delay, SFX_PLAYING_KEY
   SFX_PLAY sfx_unlock, sfx_unlock_offset, sfx_unlock_delay, SFX_PLAYING_UNLOCK
   SFX_PLAY sfx_ghost, sfx_ghost_offset, sfx_ghost_delay, SFX_PLAYING_GHOST
   SFX_PLAY sfx_bars, sfx_bars_offset, sfx_bars_delay, SFX_PLAYING_BARS
   rts

sfx_play_death:
   lda sfx_playing
   ora #SFX_PLAYING_DEATH
   sta sfx_playing
   stz sfx_death_offset
   stz sfx_death_delay
   rts

sfx_play_pellet:
   lda sfx_playing
   ora #SFX_PLAYING_PELLET
   sta sfx_playing
   stz sfx_pellet_offset
   stz sfx_pellet_delay
   rts

sfx_play_pwr_pellet:
   lda sfx_playing
   ora #SFX_PLAYING_PWR_PELLET
   sta sfx_playing
   stz sfx_pwr_pellet_offset
   stz sfx_pwr_pellet_delay
   rts

sfx_play_bomb:
   lda sfx_playing
   ora #SFX_PLAYING_BOMB
   sta sfx_playing
   stz sfx_bomb_offset
   stz sfx_bomb_delay
   rts

sfx_play_key_fruit:
   lda sfx_playing
   ora #SFX_PLAYING_KEY
   sta sfx_playing
   stz sfx_key_offset
   stz sfx_key_delay
   rts

sfx_play_unlock:
   lda sfx_playing
   ora #SFX_PLAYING_UNLOCK
   sta sfx_playing
   stz sfx_unlock_offset
   stz sfx_unlock_delay
   rts

sfx_play_ghost:
   lda sfx_playing
   ora #SFX_PLAYING_GHOST
   sta sfx_playing
   stz sfx_ghost_offset
   stz sfx_ghost_delay
   rts

sfx_play_bars:
   lda sfx_playing
   ora #SFX_PLAYING_BARS
   sta sfx_playing
   stz sfx_bars_offset
   stz sfx_bars_delay
   rts


.endif
