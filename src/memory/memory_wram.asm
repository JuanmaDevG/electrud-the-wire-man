SECTION "Sprite Component", WRAM0 [$C000]
electrud_sprite_component::
	electrud_sprite_head: DS 4
	electrud_sprite_body: DS 4
	raysnake_sprite_tile: DS 4

other_sprites_components:: 
DS 37*4


SECTION "Physics Component", WRAM0[$C100]
electrud_physics: DS 12

SECTION "Physics Hitbox", WRAM0[$C200]
electrud_hitbox: DS 4
raysnake_hitbox: DS 4
;DS 4

;;;;;; OTRAS SECCIONES ;;;;;;;;;;;;;;,

SECTION "Electrud state", WRAM0 
blink_timer: 	DS 1 		; contador = 10 para cabeza normal    ; contador = 4 para cabeza brillante
blink_state: 	DS 1 		; 0 = cabeza normal   ; 1 = cabeza brillante


SECTION "Botones data", WRAM0
;====== PARA TODOS: 0 = NO PULSADO ; 1 = PULSADO ======;
A_button: 			DS 1 	
B_button: 			DS 1
SELECT_button: 		DS 1
START_button: 		DS 1

