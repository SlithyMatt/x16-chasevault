.ifndef SOUNDFX_INC
SOUNDFX_INC = 1

.include "x16.inc"
.include "ym2151.asm"
.include "globals.asm"

sfx_death:
.byte YM_KEY_ON,     YM_CH_1
.byte YM_KEY_ON,     YM_CH_1 | YM_SN_ALL
.byte YM_KC+YM_CH_1, YM_KC_OCT2 | YM_KC_C
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_C
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_B_FL
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_1
.byte YM_KEY_ON,     YM_CH_1 | YM_SN_ALL
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_A
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_G
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_1
.byte YM_KEY_ON,     YM_CH_1 | YM_SN_ALL
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_F
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_E_FL
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_1
.byte YM_KEY_ON,     YM_CH_1 | YM_SN_ALL
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte YM_KC+YM_CH_4, YM_KC_OCT3 | YM_KC_D
.byte OPM_DELAY_REG, 8
.byte YM_KEY_ON,     YM_CH_4
.byte YM_KEY_ON,     YM_CH_4 | YM_SN_ALL
.byte YM_KC+YM_CH_4, YM_KC_OCT2 | YM_KC_C
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

sfx_playing:
.byte 0  ; Bits 7-1: TBD | Bit 0: death

SFX_PLAYING_DEATH = $01

sfx_death_offset:
.byte 0
sfx_death_delay:
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
   rts

sfx_play_death:
   lda sfx_playing
   ora #SFX_PLAYING_DEATH
   sta sfx_playing
   stz sfx_death_offset
   stz sfx_death_delay
   rts

.endif
