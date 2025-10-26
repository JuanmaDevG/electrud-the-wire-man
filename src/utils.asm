include "definitions/constants.inc"
include "definitions/electrud.inc"

SECTION "utils", ROM0
;; DESTROYS: AF, HL
wait_vblank_start::
	ld hl, rLY
	ld a, VBLANK_START_LINE
	.loop:
		cp [hl]
	jr nz, .loop
	ret


;; DESTROYS: F, HL
lcdc_off::
	call wait_vblank_start
	ld hl, rLCDC
	res 7, [hl]
	ret

;; DESTROYS: F, HL
lcdc_on:: 
    ld a, [rLCDC]
    set 7, a
    set 1, a 
    ld [rLCDC], a
  ret


;; HL: source
;; DE: destination
;; BC: bytes
memcpy::
  .loop:
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, .loop
    xor a
    cp b
    ret z
    dec b
    ld c, $ff
    jr .loop


;; HL: dest
;; A: value
;; BC: bytes
memset::
  .loop:
    ld [hl+], a
    dec c
    jr nz, .loop
    xor a
    cp b
    ret z
    dec b
    ld c, $ff
    jr .loop


;; DESTROYS: B, C, HL
;; RETURN: [E_PLAYER_INPUT] (joy_down, joy_up, joy_left, joy_right, start, select, B, A) (inside an electrud component)
get_input::
  ld c, $00
  ld a, SELECT_BUTTONS
  ldh [c], a
  ldh a, [c]
  ldh a, [c]
  ldh a, [c]
  cpl
  and $0f
  ld b, a
  swap b
  ld a, SELECT_JOYPAD
  ldh [c], a
  ldh a, [c]
  ldh a, [c]
  ldh a, [c]
  cpl
  and $0f
  or b
  ld hl, COMPONENT_PHYSICS + E_PLAYER_INPUT
  ld [hl], a
  ld a, SELECT_NONE
  ldh [c], a
  ret
