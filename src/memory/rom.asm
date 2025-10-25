include "definitions/constants.inc"
include "definitions/electrud.inc"

SECTION "Initialization data", ROM0
electrud_init_sprites::
  db SCRN_PX_HEIGHT - TILE_PX_WIDTH, TILE_PX_WIDTH * 2, E_TILE_HEAD, $00
  db SCRN_PX_HEIGHT, TILE_PX_WIDTH * 2, E_TILE_BODY, $00
electrud_init_physics::
  db ENT_SPEED_HIGH, ENT_SPEED_HIGH, E_FLAG_ALIVE, E_TRANSFORM_COUNTER_RELOAD
  db E_BLINK_COUNTER_RELOAD, E_NOT_AVAILABLE_INPUT, E_WALK_STEP_COUNTER_RELOAD
