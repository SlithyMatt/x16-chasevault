.ifndef SOUNDFX_INC
SOUNDFX_INC = 1

.include "x16.inc"
.include "ym2151.asm"
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
.byte OPM_DELAY_REG, 32
.byte YM_KEY_ON,     YM_CH_5
.byte OPM_DONE_REG,  0

sfx_bomb:
.byte YM_KEY_ON,     YM_NOISE_OFF
.byte YM_CT_W,       YM_W_NOISE
.byte YM_OP_CTRL+YM_CH_8,  YM_RL_ENABLE
.byte YM_TL_C2+YM_CH_8,    $7F
.byte YM_NE_NFRQ,    YM_NE | YM_NFRQ_7k
.byte YM_KEY_ON,     YM_NOISE_ON
.byte OPM_DELAY_REG, 32
.byte YM_KEY_ON,     YM_NOISE_OFF
.byte YM_CT_W,       YM_W_SAWTOOTH
.byte OPM_DONE_REG,  0

sfx_playing:
.byte 0  ; Bits 7-4: TBD
         ; Bit3: bomb | Bit 2: power pellet | Bit 1: pellet | Bit 0: death

SFX_PLAYING_BOMB = $08
SFX_PLAYING_PWR_PELLET = $04
SFX_PLAYING_PELLET = $02
SFX_PLAYING_DEATH = $01

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


.macro SFX_PLAY data, offset, delay, playing_bit
   lda sfx_playing
   bit #playing_bit
   bne :+
   jmp :+++++
:  lda delay
   beq :+
   dec delay
   lda delay
   beq :+
   jmp :++++
:  ldx offset
   lda data,x
   cmp #OPM_DELAY_REG
   beq :+
   cmp #OPM_DONE_REG
   beq :++
   sta YM_reg
   inc offset
   ldx offset
   lda data,x
   sta YM_data
   inc offset
   bra :-
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


.endif
