include "definitions/constants.inc"
include "definitions/electrud.inc"

def MAIN_CHARACTER_OFFSET equ (3 * OAM_SLOT_SIZE)
def ENT_START_WRITEPOINT equ (COMPONENT_SPRITES + MAIN_CHARACTER_OFFSET)

SECTION "Entity management", ROM0
; INPUT: no
; DESTROYS: hl, de, b, a
allocate_ball::
  ld hl, ball_physics +1 - OAM_SLOT_SIZE ; ball_physics.alive_byte
  ld b, BALL_SLOTS
  .loop:
    ld a, l
    add OAM_SLOT_SIZE
    ld l, a
    xor a
    or [hl]
    jr z, .make_new_ball ; Ball not alive, so make new
    dec b
    ret z ; Ball slot not found
    jr .loop
  .make_new_ball:
    ld [hl], 1            ; Now ball alive
    dec l
    ld [hl], 2            ; vy (px per frame) = 2
    dec h                 ; hl = general_entities_mem
    push hl
    xor a
    ld [hl+], a           ; Y = 0
    call random_next
    ld [hl+], a           ; X = random [8 - 127]
    ld [hl], TILE_BALL
    inc l
    ld [hl], 0
    .init_hitbox:
    pop hl
    ld d, h
    ld e, l
    inc d
    inc d                 ; de = ball_hitbox
    ld a, [hl+]
    ld [de], a            ; hitbox Y = Y
    inc e
    ld a, TILE_PX_HEIGHT
    ld [de], a            ; hitbox H
    inc e
    ld a, [hl]
    ld [de], a            ; hitbox X = X
    inc e
    ld a, TILE_PX_WIDTH
    ld [de], a            ; hitbox W
  ret


; DESTROY: de
; RETURN: a = next random number
random_next::
  ld de, ball_random_seed
  ld a, [de]
  sla a
  jr nc, .no_xor
  xor $71
  .no_xor:
    ld [de], a  ; Set the raw next seed
    and $7f     ; Purify random number X = [8 - 127] (to be inside the screen)
    add TILE_PX_WIDTH
    cp 128
    ret nc
    ret c
    sub 112
    add TILE_PX_WIDTH
  ret


; INPUT: hl = ball loc
; DESTROY: hl, 
update_ball::
    inc h                ; hl = C100 = component_physics
    inc hl               ; ENT_ALIVE_FLAG
    ld a, [hl]           ; ENT_ALIVE_FLAG (puede ser una flag o un byte entero, pq no tememos nada para las entidades)
    or a
    jr nz, .alive

    ; Si está muerta, entonces ponemos el sprite a nulo
    inc l
    dec h
    ld [hl], 0 ; REMOVE SPRITE

  .alive:
    ; HL = C101
    call update_ball_position
    ; HL = C200
    call check_floor    
    ; HL = C200
    call check_collision_player
    ; HL = C200
    call truly_move_ball
ret


update_ball_position::
  ; Primero cargamos la velocidad
  dec hl                    ; physics [velocidad]
  ld a, [hl]
  ld b, a 
  
  ;Y luego mover hacia abajo
  inc h                     ; hl = C200 = component_hitbox [y]
  ld a, [hl]
  add b
  ld [hl], a
ret

check_floor::
    push hl
    ld a, [hl]                    ; ya viene de usar la hitbox
    cp 152 
    jr c, .still_dropping
    
    dec h                         ; hl = c100 = physics
    inc hl                        ; ENT_ALIVE_FLAG
    ld a, 0
    ld [hl], a                  ; ENT_ALIVE_FLAG (puede ser una flag o un byte entero, pq no tememos nada para las entidades)
  .still_dropping:
    pop hl
  ret

check_collision_player::
  push hl

  ld d, h
  ld e, l       ; C2XX (hitbox de la bola)
  ld bc, electrud_hitbox
  call are_boxes_colliding

  jr nc, .not_collide

  ; Si hubo colisión, entonces el jugador debe morir
  ld hl, COMPONENT_PHYSICS + E_FLAGS
  res E_BIT_ALIVE, [hl]

  .not_collide:
    pop hl

ret 

truly_move_ball::
    ; HL = C200 hitbox[y]
    ld a, [hl]            ; ball_hitbox + ENT_Y_HITBOX
    dec h
    dec h                 ; HL = C000
    ld [hl], a 
    inc h 
    inc h                 ; HL = C200 
    inc hl 
    inc hl                ; HL = C202
    ld   a, [hl]
    dec hl
    dec h 
    dec h                 ; HL = C001
    ld [hl], a
  ret
