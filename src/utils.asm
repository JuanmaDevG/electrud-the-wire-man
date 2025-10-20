INCLUDE "constants.inc"

SECTION "utils", ROM0


;; Así lo define el profe tal cual, es la forma más rápida
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESTROYS: AF, HL
;;
wait_vblank_start::
	ld hl, rLY
	ld a, VBLANK_START_LINE
	.loop:
		cp [hl]
	jr nz, .loop
	ret

; Como dijo el profe, apagado seguro
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESTROYS: F, HL
;;
lcdc_off::
	di
	call wait_vblank_start
	ld hl, rLCDC
	res 7, [hl]
	ei
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESTROYS: F, HL
;;
lcdc_on:: 
    ld a, [rLCDC]
    set 7, a
    set 1, a 
    
    ;  ld a, %10010011 -> con esto activaríamos la pantalla, pero también BG ON, usar $8000 para tiles, BG map $9800
    ; El caso es que el valor de rLCDC no debería haber cambiado (o sí -> INVESTIGAR), por lo tanto podemos simplemente activar el bit 7 otra vez
    ; hemos activado 2 bits más (para los sprites), así que hay que saber cuáles queremos tener activos porque es preferible activar todo de una
    
    ld [rLCDC], a
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HL: source
;; DE: destiny
;;  B: bytes
memcpy_256::
	.loop:
		ld a, [hl+]
		ld [de], a
		inc de
		dec b 
	jr nz, .loop
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

;; HL: source
;; DE: dest
;; BC: bytes
memset::
;TODO: full 16bit memset
  ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HL: destination
;;  B: bytes
;;  A: value to set
memset_256::
	.loop
		ld [hl+], a
		dec b 
	jr nz, .loop
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESTROYS: A
;; 
leer_joypad::
    ld a, $20
    ld [$FF00], a
    ld a, [$FF00] 
    ld a, [$FF00] 
    ld a, [$FF00] 
ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESTROYS: A
;; 
leer_buttons::
    ld a, $10
    ld [$FF00], a
    ld a, [$FF00] 
    ld a, [$FF00] 
    ld a, [$FF00] 
ret


;; DESTROYS: B, C
;; RETURN: B (joy_down, joy_up, joy_left, joy_right, start, select, B, A)
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
  ld b, a
  ld a, SELECT_NONE
  ldh [c], a
  ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESTROYS: A, B
;; 
process_button:
	ld b, a
	xor a
   	ld [A_button], a
   	ld [B_button], a
   	ld [SELECT_button], a
   	ld [START_button], a

   	ld a, b 
	bit 0, a 
	jr z, .A_button_pressed
	bit 1, a
	jr z, .B_button_pressed
	bit 2, a
	jr z, .SELECT_button_pressed
	bit 3, a
	jr z, .START_button_pressed

	jp .end_processing

	.A_button_pressed:
		ld a, 1
		ld [A_button], a 
	jp .end_processing

	.B_button_pressed:
		ld a, 1
		ld [B_button], a 
	jp .end_processing

	.SELECT_button_pressed:
		ld a, 1
		ld [SELECT_button], a
	jp .end_processing

	.START_button_pressed:
		ld a, 1
		ld [START_button], a

	.end_processing:
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DESTROYS: HL, A
;; 
process_joypad:
	;Primero reseteamos todos los bits a 0 para registrar de nuevo los movimientos bien
	ld hl, electrud_physics + E_EL_FL
	res E_BIT_MV_RIGHT, [hl]
	res E_BIT_MV_LEFT, 	[hl]
	res E_BIT_MV_UP, 	[hl]
	res E_BIT_MV_DOWN, 	[hl]

	bit 0, a 
	jr z, .right_button_pressed
	bit 1, a
	jr z, .left_button_pressed
	bit 2, a
	jr z, .up_button_pressed
	bit 3, a
	jr z, .down_button_pressed

	jp .end_processing

	.right_button_pressed:
		set E_BIT_MV_RIGHT, [hl]
	jp .end_processing

	.left_button_pressed:
		set E_BIT_MV_LEFT, [hl]

	jp .end_processing

	.up_button_pressed:
		set E_BIT_MV_UP, [hl]
	jp .end_processing

	.down_button_pressed:
		set E_BIT_MV_DOWN, [hl]

	.end_processing:
	ret
