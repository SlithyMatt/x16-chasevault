.ifndef JOYSTICK_INC
JOYSTICK_INC = 1

; directions
JOY_RT = $01
JOY_LT = $02
JOY_DN = $04
JOY_UP = $08

; buttons
JOY_STA = $10
JOY_SEL = $20
JOY_B   = $40
JOY_A   = $80

; easy registers
joystick1_right: .byte 0
joystick1_left: .byte 0
joystick1_down: .byte 0
joystick1_up: .byte 0
joystick1_start: .byte 0
joystick1_select: .byte 0
joystick1_b: .byte 0
joystick1_a: .byte 0

joystick2_right: .byte 0
joystick2_left: .byte 0
joystick2_down: .byte 0
joystick2_up: .byte 0
joystick2_start: .byte 0
joystick2_select: .byte 0
joystick2_b: .byte 0
joystick2_a: .byte 0

joystick_tick:
   jsr JOYSTICK_SCAN
   lda #1
   jsr JOYSTICK_GET
   cpy #0
   beq @check_buttons
   lda #0
   jsr JOYSTICK_GET
@check_buttons:
   ldx #1
   bit #JOY_RT
   beq :+
   stz joystick1_right
   bra :++
:  stx joystick1_right
:  bit #JOY_LT
   beq :+
   stz joystick1_left
   bra :++
:  stx joystick1_left
:  bit #JOY_DN
   beq :+
   stz joystick1_down
   bra :++
:  stx joystick1_down
:  bit #JOY_UP
   beq :+
   stz joystick1_up
   bra :++
:  stx joystick1_up
:  bit #JOY_STA
   beq :+
   stz joystick1_start
   bra :++
:  stx joystick1_start
:  bit #JOY_SEL
   beq :+
   stz joystick1_select
   bra :++
:  stx joystick1_select
:  bit #JOY_B
   beq :+
   stz joystick1_b
   bra :++
:  stx joystick1_b
:  bit #JOY_A
   beq :+
   stz joystick1_a
   bra :++
:  stx joystick1_a
:  lda #2
   jsr JOYSTICK_GET
   ldx #1
   bit #JOY_RT
   beq :+
   stz joystick2_right
   bra :++
:  stx joystick2_right
:  bit #JOY_LT
   beq :+
   stz joystick2_left
   bra :++
:  stx joystick2_left
:  bit #JOY_DN
   beq :+
   stz joystick2_down
   bra :++
:  stx joystick2_down
:  bit #JOY_UP
   beq :+
   stz joystick2_up
   bra :++
:  stx joystick2_up
:  bit #JOY_STA
   beq :+
   stz joystick2_start
   bra :++
:  stx joystick2_start
:  bit #JOY_SEL
   beq :+
   stz joystick2_select
   bra :++
:  stx joystick2_select
:  bit #JOY_B
   beq :+
   stz joystick2_b
   bra :++
:  stx joystick2_b
:  bit #JOY_A
   beq :+
   stz joystick2_a
   bra :++
:  stx joystick2_a
:  rts

.endif
