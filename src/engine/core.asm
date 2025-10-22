INCLUDE "constants.inc"
include "font.inc"
includee "electrud.inc"

def VRAM_LOAD_POINTER = _VRAM + TILE_SIZE

SECTION "Game Engine", ROM0

load_engine::
    .load_tiles:
    ld hl, font_tiles
    ld de, VRAM_LOAD_POINTER
    ld bc, FONT_TILE_COUNT * TILE_SIZE
    call memcpy
    ld hl, electrud_tiles
    VRAM_LOAD_POINTER += (FONT_CHAR_COUNT * TILE_SIZE)
    ld de, VRAM_LOAD_POINTER
    ld bc, ELECTRUD_TILE_COUNT * TILE_SIZE
    call memcpy
    ;TODO: provisional bricks, must change later
    ld hl, brick_tiles
    ld de, MAP_GROUND
    ld bc, 1
    .set_palettes:
    ld a, %11100100
    ld hl, rBGP
    ld a, [hl+]
    ld a, [hl]
    .initial_scene:
    ld hl, MAP_GROUND
    ld a, BRICK; TODO: brick tile def
    ld bc, 1
    call memset
    ;TODO: provisional basic brick load, must change later
    ;CALL MEMSET

tiles_init::
	.load_tiles:
		;; queremos primero cargar los tiles
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
	    ld de, _SCRN0
	    ld b, 256
	    call memcpy_256
	    call memcpy_256
	    call memcpy_256
	    call memcpy_256

	;; vacíar la WRAM
	.set_wram:
		xor a 
		ld hl, _WRAM   	;; SECTION "Sprite Components", WRAM [$C000]
		ld b, 160 			 	;; CMP_SPRITES_SIZE = SPRITE_SIZE (4) * NUM_TOTAL_SPRITES (40 ó 64)
		call memset_256

	.set_oam:
		;; vaciar la OAM
		ld hl, _OAM 		;; DEF OAM_START equ $FE00
		ld b, 160
		xor a
		call memset_256

	.load_electrud_sprite:
	;; Ahora ya podemos cargar una entidad
	;; Primero cargamos el sprite en la WRAM
	ld hl, electrud_sprites_def
	ld de, electrud_sprite_component
	ld b, 8 					;; son 2 sprites (2 sprites x 4bytes cada uno)
	call memcpy_256

	;; también queremos cargar la componente de física (solo cogemremos una como cabeza) en WRAM
	.load_electrud_physics:
		ld hl, electrud_physics_cmp
		ld de, electrud_physics
		ld b, 12
		call memcpy_256


	;; Y luego lo copiamos a la OAM
	ld hl, WRAM_START
	ld de, OAM_START
	ld b, 160
	call memcpy_256

	ret
