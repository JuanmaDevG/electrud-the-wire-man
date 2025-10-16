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

;; HL: destination
;;  B: bytes
;;  A: value to set
memset_256::
	.loop
		ld [hl+], a
		dec b 
	jr nz, .loop
	ret