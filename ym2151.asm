.ifndef YM2151_INC
YM2151_INC = 1

.include "x16.inc"

YM_addr_bank   = ^VRAM_audio
YM_addr_high   = >VRAM_audio
YM_TEST        = $01
YM_KEY_ON      = $08
YM_SN_M1       = $08
YM_SN_C1       = $10
YM_SN_M2       = $20
YM_SN_C2       = $40
YM_CH_mask     = $07
YM_NE_NFRQ     = $0F
YM_NE_mask     = $80
YM_NFRQ_mask   = $1F
YM_CLKA1       = $10
YM_CLKA2       = $11
YM_CLKB        = $12
YM_TIMER_CTRL  = $14
YM_CSM         = $80
YM_F_RESET_A   = $10
YM_F_RESET_B   = $20
YM_IRQEN_A     = $04
YM_IRQEN_B     = $08
YM_LOAD_A      = $01
YM_LOAD_B      = $02
YM_LFRQ        = $18
YM_PMD_AMD     = $19
YM_CT_W        = $1B
YM_CT1         = $40
YM_CT2         = $80
YM_W_mask      = $03
YM_OP_CTRL     = $20
YM_KC          = $28
YM_KC_OCT0     = $00
YM_KC_OCT1     = $10
YM_KC_OCT2     = $20
YM_KC_OCT3     = $30
YM_KC_OCT4     = $40
YM_KC_OCT5     = $50
YM_KC_OCT6     = $60
YM_KC_OCT7     = $70
YM_KC_C_SH     = $00
YM_KC_D_FL     = $00
YM_KC_D        = $01
YM_KC_D_SH     = $02
YM_KC_E_FL     = $02

YM_KF          = $30
YM_PMS_AMS     = $38
YM_DT1_MUL     = $40
YM_TL          = $60
YM_KS_AR       = $80
YM_AMS_EN_D1R  = $A0
YM_DT2_D2R     = $C0
YM_D1L_RR      = $E0

.endif
