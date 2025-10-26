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
  bit E_BIT_RAYSNAKE, c
  jr nz, .apply_to_raysnake
  .apply_to_electrud:
    bit E_BIT_BLINK, c
    jr z, .e_blink_down
    .e_blink_up:
    ld [hl], E_TILE_BLINKED_HEAD
    ld a, 1
    jr .check_if_jumping
    .e_blink_down:
    ld [hl], E_TILE_HEAD
    xor a
    .check_if_jumping:
      bit E_BIT_NO_GROUND, c
      jr z, .clean_and_end
      .blink_the_jump:
      add E_TILE_JUMP
      add hl, de
      ld [hl], a
      jr .clean_and_end
  .apply_to_raysnake:
    bit E_BIT_BLINK, c
    jr nz, .rsnk_blink_up
    .rsnk_blink_down:
      ld [hl], RSNK_TILE_HEAD
      add hl, de
      ld [hl], RSNK_TILE_BODY
      add hl, de
      ld [hl], RSNK_TILE_BODY
      jr .clean_and_end
    .rsnk_blink_up:
      ld [hl], RSNK_TILE_BLINKED_HEAD
      add hl, de
      ld [hl], RSNK_TILE_BLINKED_BODY
      add hl, de
      ld [hl], RSNK_TILE_BLINKED_BODY
  .clean_and_end:
  pop hl
  ld [hl], E_BLINK_COUNTER_RELOAD
  ret


;TODO: a function that adds one or negative one (to apply blinking)
; PARAM: 
_apply_blink:
  ret

; DESTROYS: hl, de, bc, af
drop_player_until_floor::
  ; ld de, dirección_de_velocidad_de_fisicas_electrud -> para mover DE píxeles
  ld hl, electrud_hitbox    ; [y]
  inc [hl]     ; [y++]
  ;; Ahora ha bajado un píxel

  ;; Una vez cae, comprobamos colisión
  call collide_down_with_tiles
  call truly_move_electrud
ret

; PARAM: b = input bits
; DESTROYS: hl, de, bc, af
move_player_horizontally::
  ld hl, electrud_hitbox + ENT_X_HITBOX

  ;ld hl, COMPONENT_SPRITES + ENT_X
  ld de, OAM_SLOT_SIZE
  .move_right:
    bit INPUT_BIT_RIGHT, b
    jr z, .move_left
    
    inc [hl]
    ;; Una vez se mueve a la derecha, comprobamos colisión y corregimos si es necesario
    ld hl, electrud_hitbox
    call collide_right_with_tiles
    call truly_move_electrud

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
    ;; Una vez se mueve a la izquierda, comprobamos colisión y corregimos si es necesario
    ld hl, electrud_hitbox
    call collide_left_with_tiles
    call truly_move_electrud

    ld hl, COMPONENT_SPRITES + ENT_FLAGS
    set ENT_FLAGS_BIT_X_FLIP, [hl]
    ld hl, COMPONENT_SPRITES + ENT_FLAGS
    set ENT_FLAGS_BIT_X_FLIP, [hl]
    ld hl, COMPONENT_SPRITES + ENT_FLAGS
    ret

truly_move_electrud:
  .load_hitbox_YX:
    ld de, electrud_hitbox + ENT_Y_HITBOX
    ld a, [de]
    ld b, a               ; B = Y de hitbox
    
    ld de, electrud_hitbox + ENT_X_HITBOX
    ld a, [de]
    ld c, a               ; C = X de hitbox

  .update_electrud_head:
    ld hl, electrud_sprite_head + ENT_Y 
    ld [hl], b              ; Y = Y 
    inc hl                  ; ENT_X
    ld [hl], c 

  .update_electrud_body:
    ld hl, electrud_sprite_body + ENT_Y 
    ld a, b
    add 8                 ; Sumamos 8 porque el cuerpo está en Y + 8 (estamos cargando la Y de la hitbox que es de la cabeza)
    ld [hl], a

    inc hl                ; ENT_X
    ld [hl], c
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
