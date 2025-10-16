INCLUDE "constants.inc"

SECTION "Electrud space", WRAM0 [$C000]
DS 12

SECTION "Animación Electrud", ROM0 

sys_player_anim_update::
	.comprobar_contador:
		ld hl, blink_timer		;; comprobamos si ha llegado a 0
		ld a, [hl]
		dec a
		ld [hl], a
	jr nz, .end_check			;; si no ha llegado a 0 continuamos

	.cambio:					;; si ha llegado a 0 el contador, tenemos que ver el estado de la cabeza para ver cuál es el cambio 
		ld hl, blink_state
		ld a, [hl]
		or a
	jr z, .cambiar_a_parpadeo	;; si es 0, es que la cabeza está en estado normal

	.cambiar_a_normal:
		xor a
		ld [hl], a   		; blink_state = 0 = cabeza normal
		ld a, 20
	jp .res_contador	

	.cambiar_a_parpadeo:
		ld a, 1
		ld [hl], a 
		ld a, 4

	.res_contador:
		ld hl, blink_timer  
		ld [hl], a

	call cambia_tiles

	.end_check:
	ret

cambia_tiles::
	.cabeza:
		ld hl, blink_state
		ld a, [hl]
		or a 
	jr z, .cabeza_normal

	.cabeza_parpadeo:
		ld hl, WRAM_START + 2  		;; sprite_electrud + (RB) CMP_SPRITE_TILE
		ld a, $02					;; CABEZA_BLINK
		ld [hl], a
		jp .cabeza_done

	.cabeza_normal:
		ld hl, WRAM_START + 2  		;; sprite_electrud + (RB) CMP_SPRITE_TILE
		ld a, $01					;; CABEZA_NORMAL
		ld [hl], a

	.cabeza_done:
		ret
