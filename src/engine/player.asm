include "definitions/constants.inc"
include "definitions/electrud.inc"


SECTION "Player functions", ROM0
; PARAM: b = E_PLAYER_INPUT, c = E_FLAGS
; DESTROY: hl
flip_player_blink::
  ld hl, COMPONENT_PHYSICS + E_BLINK_COUNTER
  dec [hl]
  ret nz
  push hl
  ld a, c
  xor E_FLAG_BLINK
  ld c, a
  ld [COMPONENT_PHYSICS + E_FLAGS], a
  .apply_blink:
    ld hl, COMPONENT_SPRITES + ENT_TILE
    ld de, OAM_SLOT_SIZE
    bit E_BIT_BLINK, c
    jr nz, .blink_up
    .blink_down:
      dec [hl]
      add hl, de
      bit E_BIT_NO_GROUND, c
      ret z
      dec [hl]
      add hl, de
      bit E_BIT_RAYSNAKE, c
      ret z
      dec [hl]
      ret
    .blink_up:
      inc [hl]
      add hl, de
      bit E_BIT_NO_GROUND, c
      ret z
      inc [hl]
      add hl, de
      bit E_BIT_RAYSNAKE, c
      ret z
      inc [hl]
      ret
  pop hl
  ld [hl], E_BLINK_COUNTER_RELOAD
  ret


;TODO: a function that adds one or negative one (to apply blinking)
; PARAM: 
_apply_blink:
  ret


; PARAM: b = input bits
; DESTROYS: hl, de
move_player_horizontally::
  ld hl, COMPONENT_SPRITES + ENT_X
  ld de, OAM_SLOT_SIZE
  .move_right:
    bit INPUT_BIT_RIGHT, b
    jr z, .move_left
    inc [hl]
    add hl, de
    inc [hl]
    add hl, de
    inc [hl]
    ld hl, COMPONENT_SPRITES + ENT_FLAGS
    res ENT_FLAGS_BIT_X_FLIP, [hl]
    add hl, de
    res ENT_FLAGS_BIT_X_FLIP, [hl]
    add hl, de
    res ENT_FLAGS_BIT_X_FLIP, [hl]
  .move_left:
    bit INPUT_BIT_LEFT, b
    ret z
    dec [hl]
    add hl, de
    dec [hl]
    add hl, de
    dec [hl]
    ld hl, COMPONENT_SPRITES + ENT_FLAGS
    set ENT_FLAGS_BIT_X_FLIP, [hl]
    ld hl, COMPONENT_SPRITES + ENT_FLAGS
    set ENT_FLAGS_BIT_X_FLIP, [hl]
    ld hl, COMPONENT_SPRITES + ENT_FLAGS
    ret


; PARAM: c = [COMPONENT_PHYSICS + E_FLAGS]
; DESTROYS: hl
animate_electrud_ground_move::
  ld hl, COMPONENT_PHYSICS + E_WALK_STEP_COUNTER
  dec [hl]
  ret nz
  push hl

  ld hl, COMPONENT_SPRITES + ENT_TILE + OAM_SLOT_SIZE
  bit E_BIT_WALK_STEP1, c
  jr z, .body_static
  bit E_BIT_WALK_STEP2, c
  jr z, .body_step1
  .body_step2:
    res E_BIT_WALK_STEP1, c
    res E_BIT_WALK_STEP2, c
    ld a, E_TILE_BODY_WALK2
    jr .apply_animation
  .body_step1:
    res E_BIT_WALK_STEP1, c
    set E_BIT_WALK_STEP2, c
    ld a, E_TILE_BODY_WALK1
    jr .apply_animation
  .body_static:
    set E_BIT_WALK_STEP1, c
    ld a, E_TILE_BODY
  .apply_animation:
  ld [hl], a
  pop hl
  ld [hl], E_WALK_STEP_COUNTER_RELOAD
  ld a, c
  ld a, [COMPONENT_PHYSICS + E_FLAGS]
  ret


; PARAM: c = [COMPONENT_PHYSICS + E_FLAGS], b = [COMPONENT_PHYSICS + E_PLAYER_INPUT]
; DESTROYS: hl
calculate_electrud_jump::
  ;TODO: this will calculate electrud jump by using physics (not the blinking)
  ;TODO: calculate jump by button press history (may add more components)
  ret

move_raysnake_vertically::
  ret


;;;;;;;;;;;;;;;;;;;
; Local functions ;
;;;;;;;;;;;;;;;;;;;

dec_hl_pointed_value:
  ;TODO: make if necessary but probably not really
  ret
