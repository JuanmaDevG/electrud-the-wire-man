
def ENTITY_SLOT_SIZE equ 4

SECTION "Sprite Component", WRAM0 [$C000]
sprites_location:
electrud_sprite_head: DS ENTITY_SLOT_SIZE
electrud_sprite_body: DS ENTITY_SLOT_SIZE 
raysnake_sprite_tile: DS ENTITY_SLOT_SIZE 
general_entities_mem: DS ENTITY_SLOT_SIZE * 37


SECTION "Physics Component", WRAM0[$C100]
electrud_physics: DS 3 * ENTITY_SLOT_SIZE
ball_physics: DS 37 * ENTITY_SLOT_SIZE

SECTION "Physical Hitbox", WRAM0[$C200]
electrud_hitbox: 		    DS ENTITY_SLOT_SIZE
raysnake_hitbox: 		    DS ENTITY_SLOT_SIZE
empty_electrud_hitbox:	DS ENTITY_SLOT_SIZE
ball_hitbox:            DS 37 * ENTITY_SLOT_SIZE

SECTION "General engine data", WRAM0[$C300]
engine_data:
ball_spawn_rate: DS 1
ball_random_seed: DS 1
unused_engine_data: DS $98


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

