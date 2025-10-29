include "definitions/constants.inc"
include "definitions/font.inc"
include "definitions/electrud.inc"
include "definitions/enemies.inc"
include "definitions/macros.inc"

def FONT_LOAD_POINT = _VRAM + TILE_SIZE
def TILES_LOAD_POINT = FONT_LOAD_POINT + (FONT_CHAR_COUNT * TILE_SIZE)
def OTHER_TILES_LOAD_POINT = TILES_LOAD_POINT + (ELECTRUD_TILE_COUNT * TILE_SIZE);TODO: read about compile-time variables
def ENEMY1_TILES_LOAD_POINT = OTHER_TILES_LOAD_POINT + (GENERAL_TILES_TILE_COUNT * TILE_SIZE)

SECTION "Game Engine", ROM0

load_engine::
  .load_tiles:
  Load_hldebc font_tiles, FONT_LOAD_POINT, FONT_BYTE_SIZE
  call memcpy
  Load_hldebc electrud_tiles, TILES_LOAD_POINT, ELECTRUD_TILES_BYTE_SIZE
  call memcpy
  Load_hldebc general_tiles, OTHER_TILES_LOAD_POINT, GENERAL_TILES_BYTE_SIZE
  call memcpy
  Load_hldebc enemy1_tiles, ENEMY1_TILES_LOAD_POINT, ENEMY1_TILES_BYTE_SIZE
  call memcpy
  .set_palettes:
  ld a, %11100100
  ld hl, rBGP
  ld [hl+], a
  ld [hl+], a
  ld [hl+], a
  .initial_scene: ;TODO: later more complex level loads
  Load_hlabc SCRN_GROUND_TILES, TILE_BRICK, SCRN_WIDTH_IN_TILES
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
  
  ld hl, electrud_init_physics
  ld de, COMPONENT_PHYSICS
  ld bc, ELECTRUD_INIT_PHYSICS_COMPONENT_SIZE
  call memcpy
  
  ld hl, electrud_init_hitbox
  ld de, COMPONENT_HITBOX
  ld bc, ELECTRUD_INIT_HITBOX_COMPONENT_SIZE
  call memcpy
  ret


update_main_player::
  ld a, [COMPONENT_PHYSICS + E_FLAGS]
  bit E_BIT_ALIVE, a
  jr nz, .player_is_alive
  .revive_player:
  call wait_vblank_start
  call lcdc_off
  call load_engine
  call lcdc_on
  .player_is_alive:
  call flip_player_blink
  call move_player_horizontally
  ; call drop_player_until_floor
  ; call e_action_buttons
  call animate_electrud_ground_move
  ret


update_entities::
  ;TODO: animate projectiles
  ret


;=================================================================
;                         COLISIONS
;=================================================================

;------------------------------------------------------
; INPUT:
; HL -> [y][h][x][w]   (todo en píxeles)
; OUTPUT:
; HITBOX [y][h][x][w]
; Postcondición: DE MOMENTO NADA, solo actualizamos la hitbox -> C=1 si bloquea (x corregida), C=0 si no.
;------------------------------------------------------
collide_right_with_tiles::
  push hl

  .load_hitbox_data:
    ld a, [hl+]
    ld d, a       ; D = Y

    ld a, [hl+]
    ld c, a       ; C = H

    ld a, [hl+]
    ld b, a       ; B = X

    ld a, [hl-]     ; hago hl- porque luego quiero coger el valor de Y otra vez
    ld e, a       ; E = W

  .calc_TY0_TY1_and_TX:
    ; Primero calculamos X + W para poder guardarlo (porque luego pisamos la e y no la podremos usar)
    ld a, b       ; A = X
    add a, e      ; A = X + W 
    ld b, a       ; B = " " "

    ; TY0: ahora tenemos que ver las filas tocadas por la hitbox (es decir, miramos la altura para ver cuántos tiles comprobar)
    ld a, d
    call convert_y_to_ty
    ld d, a       ; D = TY0

    ; Dec hl para coger la Y otra vez
    dec hl
    dec hl
    ld a, [hl]      ; A = y
    add a, c        ; A = y + h
    dec a         ; A = y + h - 1  (intervalo semiabierto, para que no coja un tile de más)
    call convert_y_to_ty
    ld e, a       ; E = TY1

    ; D = TY0  ,  E = TY1

    ; Y ahora sí calculamos el borde derecho
    ld a, b       ; Recuperamos en a el valor de X + W 
    dec a         ; A = X + W - 1
    call convert_x_to_tx
    ld c, a       ; C = TX_right

  ; ================ HASTA AHORA TENEMOS ESTO ================
  ; D = TY0  ,  E = TY1   ;   C = TX_right (borde derecho)  ,  B = usable    ;    HL = usable pq hitbox está en la pila 

  .loop_check_rows:
    ld b, d     ; B = TY0 
    push de     ; protegemos DE de la siguiente llamada
    call calculate_address_from_tx_and_ty
    pop de
    ld a, [hl]
    cp $00
    jr nz, .blocked_right

    ; Avanzamos a la siguiente fila a checkear (resto del cuerpo de la entidad)
    inc d
    ld a, e
    cp d 
    jr nc, .loop_check_rows

    pop hl
  ret

  .blocked_right:
    pop hl
    inc hl
    inc hl
    inc hl
    ld a, [hl]    ; Leemos la W
    ld e, a

    ld a, c       ; C = TX_right
    call convert_tx_to_x
    sub e         ; A = TX*8 + 8 - W   -> este será el pixel para posicionar el sprite al borde del tile con el que colisiona

    dec hl 
    ld [hl], a    ; Metemos el valor del pixel de reposicionado en la X de hitbox (y,h,x,w)
    
    ;scf      ; Activar el carry es opcional. De momento la única acción si hay colisión es que no avance
            ; pero quizá queremos que pase algo más, como que pare de andar. Para eso podríamos usar el carry.
ret


;------------------------------------------------------
; INPUT:
; HL -> [y][h][x][w]   (todo en píxeles)
; OUTPUT:
; HITBOX [y][h][x][w]
; Postcondición: DE MOMENTO NADA, solo actualizamos la hitbox -> C=1 si bloquea (x corregida), C=0 si no.
;------------------------------------------------------
collide_left_with_tiles::
  push hl

  .load_hitbox_data:
    ld a, [hl+]
    ld d, a       ; D = Y

    ld a, [hl+]
    ld c, a       ; C = H

    ld a, [hl+]
    ld b, a       ; B = X

    ld a, [hl-]     ; hago hl- porque luego quiero coger el valor de Y otra vez
    ld e, a       ; E = W

  .calc_TY0_TY1_and_TX:
    ; TY0: ahora tenemos que ver las filas tocadas por la hitbox (es decir, miramos la altura para ver cuántos tiles comprobar)
    ld a, d
    call convert_y_to_ty
    ld d, a       ; D = TY0

    ; Dec hl para coger la Y otra vez
    dec hl
    dec hl
    ld a, [hl]      ; A = y
    add a, c        ; A = y + h
    dec a         ; A = y + h - 1  (intervalo semiabierto, para que no coja un tile de más)
    call convert_y_to_ty
    ld e, a       ; E = TY1

    ; D = TY0  ,  E = TY1

    ; TX: ahora calculamos la frontera izquierda
    ld a, b       ; Recuperamos en a el valor de X, que es justo el borde colisionable
    call convert_x_to_tx
    ld c, a       ; C = TX_left (esto será el tile en el que haya entrado por la izquierda)

  ; ================ HASTA AHORA TENEMOS ESTO ================
  ; D = TY0  ,  E = TY1   ;   C = TX_left (borde izquierdo)  ,  B = usable    ;    HL = usable pq hitbox está en la pila 

  .loop_check_rows:
    ld b, d     ; B = TY0 
    push de     ; protegemos DE de la siguiente llamada
    call calculate_address_from_tx_and_ty
    pop de
    ld a, [hl]
    cp $00
    jr nz, .blocked_left

    ; Avanzamos a la siguiente fila a checkear (resto del cuerpo de la entidad)
    inc d
    ld a, e
    cp d 
    jr nc, .loop_check_rows

    pop hl
  ret

  .blocked_left:
    pop hl
    inc hl
    inc hl
    inc hl
    ld a, [hl]    ; Leemos la W
    ld e, a

    ld a, c                  ; C = TX_left
    inc a                    ; A = TX_left + 1 (que es dónde se va a posicionar la entidad, al borde del tile)
    call convert_tx_to_x     ; A = X 

    ; A = (TX*8 + 8)   -> este será el pixel para posicionar el sprite al borde del tile con el que colisiona
    ; No necesitamos añadir ni restar el ancho, porque ya nos está dando el borde exacto

    dec hl 
    ld [hl], a    ; Metemos el valor del pixel de reposicionado en la X de hitbox (y,h,x,w)
    
    ;scf      ; Activar el carry es opcional. De momento la única acción si hay colisión es que no avance
            ; pero quizá queremos que pase algo más, como que pare de andar. Para eso podríamos usar el carry.
ret


;------------------------------------------------------
; INPUT:
; HL -> [y][h][x][w]   (todo en píxeles)
; OUTPUT:
; HITBOX [y][h][x][w]
; Postcondición: DE MOMENTO NADA, solo actualizamos la hitbox -> C=1 si bloquea (x corregida), C=0 si no.
;------------------------------------------------------
collide_down_with_tiles::
  push hl

  .load_hitbox_data:
    ld a, [hl+]
    ld b, a       ; B = Y

    ld a, [hl+]
    ld c, a       ; C = H

    ld a, [hl+]
    ld d, a       ; D = X

    ld a, [hl-]     ; hago hl- porque luego quiero coger el valor de X otra vez
    ld e, a       ; E = W

  .calc_TX0_TX1_and_TY:
    ; TX0
    ld a, d
    call convert_x_to_tx
    ld d, a 

    ; TX1 (hasta donde hay que iterar TX)
    ld a, [hl]
    add a, e      ; X + W
    dec a         ; X + W - 1 (si no le restas 1 cogería un tile de más)
    call convert_x_to_tx
    ld e, a 

    ; D = TX0  ,   E = TX1

    ; TY_down
    ld a, b 
    add a, c 
    dec a         ; Y + H - 1
    call convert_y_to_ty
    ld b, a 

  ; ================ HASTA AHORA TENEMOS ESTO ================
  ; D = TX0  ,  E = TX1   ;   B = TY_down (borde debajo)  ,  C = usable    ;    HL = usable pq hitbox está en la pila

  ; necesitamos tener:
  ; B = TY 
  ; C = TX
  
  .loop_check_columns:
    ld c, d   ; ponemos TX0 en c
    push de
    push bc
    call calculate_address_from_tx_and_ty
    pop bc
    pop de 

    ld a, [hl]
    cp $00
    jr nz, .blocked_down

    ; Si no hay bloqueo, comprobamos la siguiente columna
    inc d 
    ld a, e   ; cargamos TX1 para ver si hay más columnas
    cp d
    jr nc, .loop_check_columns

    ; Si no hay más columnas, no hay colisión y volvemos
    pop hl
    add 0 ; Set to zero the carry flag
  ret

  .blocked_down:
    ; bajamos hl de la pila para modificar la hitbox y reposicionar bien 
    pop hl
  
    ; Leemos H para ajustar al borde la entidad   
    inc hl 
    ld a, [hl]
    ld c, a

    ; Leemos TY_down para calcular el pixel exacto del borde de abajo
    ld a, b
    call convert_ty_to_y
    sub c               ; TY*8 - 16 + H

    dec hl 
    ld [hl], a  ; guardamos en la hitbox en [y] el valor del pixel al borde de la colisión

    scf 

ret


update_map_scroll::
  ret


render::
  call wait_vblank_start

  ;TODO: this update type is temporary
  ld hl, COMPONENT_SPRITES
  ld de, _OAM
  ld bc, 3 * OAM_SLOT_SIZE
  call memcpy
  ret
