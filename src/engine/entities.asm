include "definitions/constants.inc"
include "definitions/electrud.inc"

def MAIN_CHARACTER_OFFSET equ (3 * OAM_SLOT_SIZE)
def ENT_START_WRITEPOINT equ (COMPONENT_SPRITES + MAIN_CHARACTER_OFFSET)

SECTION "Entity management", ROM0
; DESTROYS:
allocate_projectile::
  ;TODO: projectile in WRAM
  ret


update_ball::
    inc h                ; hl = C100 = component_physics
    inc hl               ; ENT_ALIVE_FLAG
    ld a, [hl]           ; ENT_ALIVE_FLAG (puede ser una flag o un byte entero, pq no tememos nada para las entidades)
    or a
    jr nz, .alive

    ; Si está muerta, entonces la movemos para que desaparezca
    dec hl
    dec h
    xor a
    ld [hl], a
    dec hl
    ld [hl], a 

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
