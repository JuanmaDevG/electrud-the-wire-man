SECTION "Init data", ROM0
electrud_sprites_def:
	DB $0B*8 + 16, 	$01*8 + 8, 	$01, $00	;; cabeza electrud
	DB $0C*8 + 16, 	$01*8 + 8, 	$03, $00	;; cuerpo ""


electrud_physics_cmp:
	DB $01, SPEED_COUNTER, $80, TRANSF_CNT			;;Tenemos:		 Velocidad - contador de frames para velocidad - flags - contador de transformación

	;; TILES DE ELECTRUD-SERPIENTE
	;DB $0C*8 + 16, 	$08, 	$0A, $00   	;; cola serpiente
	;DB $0C*8 + 16, 	$08+8, 	$0A, $00   	;; cola ""
	;DB $0C*8 + 16, 	$08+16, $08, $00   	;; cabeza


SECTION "Sprite Component", WRAM0 [$C000]
electrud_sprite_component::
	electrud_sprite_head: DS 4
	electrud_sprite_body: DS 4
	raysnake_sprite_tile: DS 4

other_sprites_components:: 
DS 37*4


SECTION "Physics Component", WRAM0[$C100]
electrud_physics: DS 12

;;;;;; OTRAS SECCIONES ;;;;;;;;;;;;;;,

; TODO: esto debería estar en una posición específica de la wram (para el futuro)
SECTION "Electrud state", WRAM0 
blink_timer: 	DS 1 		; contador = 10 para cabeza normal    ; contador = 4 para cabeza brillante
blink_state: 	DS 1 		; 0 = cabeza normal   ; 1 = cabeza brillante


SECTION "Botones data", WRAM0
;====== PARA TODOS: 0 = NO PULSADO ; 1 = PULSADO ======;
A_button: 			DS 1 	
B_button: 			DS 1
SELECT_button: 		DS 1
START_button: 		DS 1

