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


update_electrud::
  ld hl, _WRAM + $100 + E_FLAGS
  bit E_BIT_RAYSNAKE, [hl]
  jr nz, .is_raysnake:
  ;TODO: electrud code
  ret
  .is_raysnake:
  ;TODO: raysnake plays with other rules
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
