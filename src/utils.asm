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


; INPUT: hl = screen addr, b = num of tiles, c = TILE
; DESTROYS: hl, b, de
vertical_screen_fill::
  ld de, SCRN_LINE_JUMP
  .loop:
    ld [hl], c
    add hl, de
    dec b
    jr nz, .loop
  ret


;;DESTROYS: 
;;      A
;;INPUT:
;;      A: Sprite X-coordinate value
;; OUTPUT:
;;      A: Associated VRAM Tilemap TX-coordinate value
convert_x_to_tx:
  ; Tenemos la coordenada en píxeles, por lo tanto primero tenemos que restarle 8
  sub 8
  ; Y ahora, para pasarlo a coordenada de tilemap, se divide entre 8
  srl a
  srl a
  srl a
ret


;;DESTROYS: 
;;      A
;; INPUT:
;;      A: Sprite Y-coordinate value
;; 
;; OUTPUT:
;;      A: Associated VRAM Tilemap TY-coordinate value
convert_y_to_ty:
    ; Tenemos la coordenada en píxeles, por lo tanto primero tenemos que restarle 8
  sub 16
  ; Y ahora, para pasarlo a coordenada de tilemap, se divide entre 8
  srl a
  srl a
  srl a
ret


;;DESTROYS: 
;;      A, HL, DE
;; INPUT:
;;      B: TY coordinate 
;;      C: TX coordinate
;;  OUTPUT:
;;     HL: Address where the (TX, TY) tile is stored
;:
calculate_address_from_tx_and_ty:
  ;9800 + TY*32 + TX
  ld h, $00
  or a          ; esto lo hago para desactivar el flag carry
  ld l, b         ; movemos TY a L para hacer la multiplicación en HL
  ld de, $9800

  ;Multiplicamos TY*32
  ;*2
  rl l 
  rl h
  ;*4
  rl l 
  rl h
  ;*8
  rl l 
  rl h    
  ;*16
  rl l 
  rl h  
  ;*32
  rl l 
  rl h 

  ;Hacemos la suma (primero TY*32 + TX)
  ; como tenemos TY*32 en HL y TX en c
  ; sumamos L+A, lo guardamos en L
  ld b, $00
  add hl, bc      ;; Hacemos la suma TY*32 + TX
  add hl, de      ;; Y ahora sumamos $9800 a esto

ret

;;DESTROYS: 
;;      A
;; INPUT:
;;      A: Sprite Y-coordinate value
;; 
;; OUTPUT:
;;      A: Associated Y pixel of the sprite
convert_ty_to_y:
  add a
  add a
  add a
  add 16
ret

;;DESTROYS: 
;;      A
;; INPUT:
;;      A: Sprite Y-coordinate value
;; 
;; OUTPUT:
;;      A: Associated Y pixel of the sprite
convert_tx_to_x:
  add a
  add a
  add a
  add 8
ret
