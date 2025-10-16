INCLUDE "constants.inc"



SECTION "Game Engine", ROM0

tiles_init::
	.load_tiles:
		;; queremos primero cargar los tiles
		ld hl, electrud_tiles
		ld de, VRAM_TILES + 16
		ld b, 256    			;; 256 % 16 = 16 tiles
		call memcpy_256
		ld b, 16*6 				;; los tiles que quedan por cargar
		call memcpy_256

	.set_palletes:
		;; Cargamos las paletas de tiles y objetos
		ld hl, rBGP 
	    ld [hl], %11100100
	    ld hl, rOBP0
	    ld [hl], %11100100

    .pintar_tilemap:
	    ;; Vamos a pintar un tilemap
	    ld hl, tilemap_scene01
	    ld de, $9800
	    ld b, 256
	    call memcpy_256
	    call memcpy_256
	    call memcpy_256
	    call memcpy_256

	;; vacíar la WRAM
	.set_wram:
		xor a 
		ld hl, $C000   		;; SECTION "Sprite Components", WRAM [$C000]
		ld b, 160 			;; CMP_SPRITES_SIZE = SPRITE_SIZE (4) * NUM_TOTAL_SPRITES (40 ó 64)
		call memset_256

	.set_oam:
		;; vaciar la OAM
		ld hl, $FE00 		;; DEF OAM_START equ $FE00
		ld b, 160
		xor a
		call memset_256

	;; Ahora ya podemos cargar una entidad
	;; Primero cargamos el sprite en la WRAM
	ld hl, electrud_sprite
	ld de, $C000
	ld a, $08
	ld b, 12 				;; son 3 sprites (3 sprites x 4bytes cada uno)
	call memcpy_256

	;; Y luego lo copiamos a la OAM
	ld hl, $C000
	ld de, $FE00
	ld b, 160
	call memcpy_256

	ret