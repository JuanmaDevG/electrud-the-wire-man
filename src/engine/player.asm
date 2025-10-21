INCLUDE "constants.inc"


SECTION "Player functions", ROM0 



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
		ld [hl], a   			; blink_state = 0 = cabeza normal
		ld a, BLINK_COUNTER_1 	; reseteamos el contador a 20 en la etiqueta res_contador
	jp .res_contador	

	.cambiar_a_parpadeo:
		ld a, 1
		ld [hl], a 				;; blink_state = 1 = parpadeo
		ld a, BLINK_COUNTER_2	;; reseteamos el contador a 4

	.res_contador:
		ld hl, blink_timer  
		ld [hl], a

	call cambia_tiles_character

	.end_check:
	ret

cambia_tiles_character::
	;; primero comprobamos si el personaje está transformado o no
	.is_transformed:
		ld hl, electrud_physics + E_EL_FL
		ld a, [hl]
		bit E_BIT_RAYSNAKE, a 
	jr z, .tile_electrud

	; Si no está transformado, asignamos la cabeza de raysnake
	.tile_raysnake:
		ld c, $08
	jr .tipo_cabeza

	; O asignamos la de electrud
	.tile_electrud:
		ld c, $01

	.tipo_cabeza:
		ld hl, blink_state
		ld a, [hl]
		or a 
	jr z, .cabeza_normal

	.cabeza_parpadeo:
		ld hl, electrud_sprite_head + E_TILE  		;; Nos situamos en el nº de tile
		ld a, c										;; CABEZA_BLINK
		inc a
		ld [hl], a
		jp .cabeza_done

	.cabeza_normal:
		ld hl, electrud_sprite_head + E_TILE  		;; Nos situamos en el nº de tile
		ld a, c										;; CABEZA_NORMAL
		ld [hl], a

	.cabeza_done:
		ret

check_transformation::
	; Seguimos decrementando el contador de transformación
	.check_tc:
		ld hl, electrud_physics + E_TC
		ld a, [hl]
		dec a
		ld [hl], a
	jr nz, .end_check_tc

	; Si el contador ha llegado a 0, primero lo reiniciamos
	ld a, TRANSF_CNT
	ld [hl], a

	; Y ahora sí, transformamos
	.transform:
		ld hl, electrud_physics + E_EL_FL
		ld a, [hl]
		bit E_BIT_RAYSNAKE, a 
	jr z, .transform_to_raysnake

	;.transform_to_electrud:
		;
		;
		;
		;
	jp .end_check_tc

	.transform_to_raysnake:
		;; Primero cambiamos la cabeza por cabeza
		.cambio_cabeza:
			; Recolocamos un tile hacia abajo
			ld hl, electrud_sprite_head + E_Y 
			ld a, [hl]
			add 8
			ld [hl], a
			
			;; Recolocamos un tile a la derecha
			ld hl, electrud_sprite_head + E_X
			ld a, [hl]
			add 8
			ld [hl], a

			; Y ya cambiamos el tile por la cabeza de la serpiente
			ld hl, electrud_sprite_head + E_TILE
			ld a, $08
			ld [hl], a

		;; Ahora cambiamos el cuerpo de electrud por la cola de raynsake
		.cambio_cuerpo:
			ld hl, electrud_sprite_body + E_TILE
			ld a, $0A
			ld [hl], a
		.add_scnd_tile:
			; No tenemos que cambiar, si no añadir
			; Para ello, copiamos la coordenada Y
			ld hl, electrud_sprite_body + E_Y
			ld a, [hl]
			ld hl, raysnake_sprite_tile + E_Y
			ld [hl], a

			; copiamos la coordenada X del cuerpo y le restamos 8
			ld hl, electrud_sprite_body + E_X
			ld a, [hl]
			sub 8
			ld hl, raysnake_sprite_tile + E_X
			ld [hl], a

			ld hl, raysnake_sprite_tile + E_TILE 
			ld a, $0A
			ld [hl], a

		;Y por último falta poner que ya es serpiente (bit 7 = E_BIT_RAYSNAKE)
		ld hl, electrud_physics + E_EL_FL
		ld a, [hl]
		set E_BIT_RAYSNAKE, a
		ld [hl], a


	.end_check_tc:
	ret





move_electrud_raysnake::
	.check_move_counter:
		; PRIMERO COMPROBAMOS EL CONTADOR DE VELOCIDAD PARA VER SI TIENE QUE MOVERSE YA O NO
		ld hl, electrud_physics + E_V_CONT
		ld a, [hl]
		dec a  					; Decrementamos el contador 
		ld [hl], a
		cp 0 					; Comprobamos si es 0 y hay que mover
		jp nz, .not_move

	;;MOVER DERECHA
	.move_right:
		;Primero comprobar si hay que mover a la derecha
		ld hl, electrud_physics + E_EL_FL
		bit E_BIT_MV_RIGHT, [hl]
		jr z, .move_left

		; ========== IMPORTANTE ===============
		; ¿ROTAR TILES DERECHA?

		;Movemos la cabeza
		ld hl, electrud_sprite_head + E_X
		ld a, [hl]
		add PASO_MOVIMIENTO
		ld [hl], a

		;Movemos el cuerpo
		ld hl, electrud_sprite_body + E_X
		ld a, [hl]
		add PASO_MOVIMIENTO
		ld [hl], a 

		;Es raysnake? MOVER LA SEGUNDA COLA TAMBIÉN !!
		ld hl, electrud_physics + E_EL_FL
		bit E_BIT_RAYSNAKE, [hl]
		jr nz, .move_raysnake_right

		jp .end_moving


	;;MOVER IZQUIERDA
	.move_left:
		;Primero comprobar si hay que mover a la izquierda
		bit E_BIT_MV_LEFT, [hl]
		jr z, .move_another

		; ========== IMPORTANTE ===============
		; ¿ROTAR TILES IZQUIERDA?

		;Movemos la cabeza
		ld hl, electrud_sprite_head + E_X
		ld a, [hl]
		sub PASO_MOVIMIENTO
		ld [hl], a

		;Movemos el cuerpo
		ld hl, electrud_sprite_body + E_X
		ld a, [hl]
		sub PASO_MOVIMIENTO
		ld [hl], a 

		;Es raysnake? MOVER LA SEGUNDA COLA TAMBIÉN !!
		ld hl, electrud_physics + E_EL_FL
		bit E_BIT_RAYSNAKE, [hl]
		jr nz, .move_raysnake_left
		
		jp .end_moving


	.move_another:
		; Queda comprobar el salto de electrud por un lado
		; Y por otro lado queda comprobar move_up y move_down de raysnake
		jp .end_moving

	.move_raysnake_right:
		;Movemos la segunda cola de raysnake
		ld hl, raysnake_sprite_tile + E_X
		ld a, [hl]
		add PASO_MOVIMIENTO
		ld [hl], a 

		jp .end_moving

	.move_raysnake_left:
		;Movemos la segunda cola de raysnake
		ld hl, raysnake_sprite_tile + E_X
		ld a, [hl]
		sub PASO_MOVIMIENTO
		ld [hl], a 

		jp .end_moving


	.end_moving:
		ld hl, electrud_physics + E_V_CONT
		ld a, [hl]
		ld a, SPEED_COUNTER 					; Reiniciamos el contador
		ld [hl], a

	.not_move:

ret



