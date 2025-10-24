include "constants.inc"
include "font.inc"
include "electrud.inc"
include "macros.inc"

def VRAM_LOAD_POINT = _VRAM + TILE_SIZE

SECTION "Game Engine", ROM0

load_engine::
  .load_tiles:
  Load_hldebc font_tiles, VRAM_LOAD_POINT, FONT_BYTE_SIZE
  call memcpy
  VRAM_LOAD_POINT += (FONT_CHAR_COUNT * TILE_SIZE)
  Load_hldebc electrud_tiles, VRAM_LOAD_POINT, ELECTRUD_TILES_BYTE_SIZE
  call memcpy
  VRAM_LOAD_POINT += ELECTRUD_TILES_BYTE_SIZE
  Load_hldebc brick_tiles, VRAM_LOAD_POINT, 1
  call memcpy
  .set_palettes:
  ld a, %11100100
  ld hl, rBGP
  ld a, [hl+]
  ld a, [hl]
  .initial_scene: ;TODO: later more complex level loads
  Load_hlabc SCRN_GROUND_TILES, BRICK, SCRN_WIDTH_IN_TILES
  call memset
  .clear_sprites_mem:
  Load_hlabc _WRAM, 0, MEM_LINE_SIZE
  call memset
  Load_hlabc _OAM, 0, OAM_BYTESIZE
  call memset
  .load_electrud:
  Load_hldebc electrud_init_sprites, _WRAM, ELECTRUD_INIT_SPRITES_COMPONENT_SIZE
  push hl
  push bc
  call memcpy
  pop bc
  pop hl
  ld de, _OAM
  call memcpy
  inc d
  ld hl, electrud_init_physics
  ld bc, ELECTRUD_INIT_PHYSICS_COMPONENT_SIZE
  call memcpy
  ret


update_main_player::
  ld a, [COMPONENT_PHYSICS + E_PLAYER_INPUT]
  ld b, a
  ld a, [COMPONENT_PHYSICS + E_FLAGS]
  ld c, a
  bit E_BIT_ALIVE, c
  jr nz, .player_is_alive
  push bc
  call wait_vblank_start
  call lcdc_off
  call load_engine
  call lcdc_on
  pop bc
  .player_is_alive:
  call flip_player_blink
  call move_player_horizontally
  bit E_BIT_RAYSNAKE, c
  jr nz, .is_raysnake
  .is_electrud:
    call calculate_electrud_jump
    .electrud_is_grounded:
      bit INPUT_BIT_RIGHT, b
      call nz animate_electrud_ground_move
      bit INPUT_BIT_LEFT, b
      call nz animate_electrud_ground_move
      ret
  .is_raysnake:
    call move_player_horizontally
    ; NO COUNTER
    ret


update_entities::
  ret


update_map_scroll::
  ret


render::
  call wait_vblank_start
  ;TODO: update the OAM
  ;TODO: update the map scroll I guess
  ret
