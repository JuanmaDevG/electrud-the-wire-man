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
