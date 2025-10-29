if !def(ELECTRUD_INC)
  def ELECTRUD_INC equ 1

include "definitions/constants.inc"
include "definitions/font.inc"

def ELECTRUD_TILE_COUNT equ 21
def ELECTRUD_TILES_BYTE_SIZE equ (ELECTRUD_TILE_COUNT * TILE_SIZE)

def ELECTRUD_INIT_SPRITES_COMPONENT_SIZE equ 8
def ELECTRUD_INIT_PHYSICS_COMPONENT_SIZE equ 7
def ELECTRUD_INIT_HITBOX_COMPONENT_SIZE  equ 4


rsset (1 + FONT_CHAR_COUNT) ;Jump the null tile
def E_TILE_HEAD                    rb 1
def E_TILE_BLINKED_HEAD            rb 1
def E_TILE_BODY                    rb 1
def E_TILE_BODY_WALK1              rb 1
def E_TILE_BODY_WALK2              rb 1
def E_TILE_JUMP                    rb 1
def E_TILE_BLINKED_JUMP            rb 1
def RSNK_TILE_HEAD                 rb 1
def RSNK_TILE_BLINKED_HEAD         rb 1
def RSNK_TILE_BODY                 rb 1
def RSNK_TILE_BLINKED_BODY         rb 1
def RSNK_TILE_DIAG_BODY            rb 1
def RSNK_TILE_DIAG_BLINKED_BODY    rb 1
def E_TILE_PROJECTILE              rb 1
def E_TILE_BLINKED_PROJECTILE      rb 1
def E_TILE_EXPLOSION1              rb 1
def E_TILE_EXPLOSION2              rb 1
def E_TILE_EXPLOSION3              rb 1
def E_TILE_EXPLOSION4              rb 1
def RSNK_TILE_DASH1                rb 1
def RSNK_TILE_DASH2                rb 1
def TILE_BRICK                     rb 1 ;TODO: This is temporary


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Electrud physics components ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; COMPONENT_SPRITES for electrud
rsreset
def E_SPRITE_HEAD           rb 4
def E_SPRITE_BODY           rb 4
def E_SPRITE_UNUSED         rb 4

rsreset
def RSNK_SPRITE_HEAD        rb 4
def RSNK_SPRITE_TAIL1       rb 4
def RSNK_SPRITE_TAIL2       rb 4

; COMPONENT_PHYSICS bytes
rsreset
def E_V                     rb 1
def E_V_COUNTER             rb 1
def E_FLAGS                 rb 1
def E_TRANSFORM_COUNTER     rb 1
def E_BLINK_COUNTER         rb 1
def E_PLAYER_INPUT          rb 1
def E_WALK_STEP_COUNTER     rb 1
def E_NEW_PROJECTILE        rb 1

; E_FLAGS bit values
def E_BIT_ALIVE 		  equ 7
def E_BIT_RAYSNAKE 		equ 6
def E_BIT_NO_GROUND		equ 5
def E_BIT_WALK_STEP1  equ 4
def E_BIT_WALK_STEP2  equ 3
def E_BIT_BLINK       equ 2

def E_FLAG_ALIVE      equ %10000000
def E_FLAG_RAYSNAKE   equ %01000000
def E_FLAG_NO_GROUND  equ %00100000
def E_FLAG_STEP1      equ %00010000
def E_FLAG_STEP2      equ %00001000
def E_FLAG_BLINK      equ %00000100

def E_TRANSFORM_COUNTER_RELOAD equ 90
def E_BLINK_COUNTER_RELOAD equ 3
def E_NOT_AVAILABLE_INPUT equ 0
def E_WALK_STEP_COUNTER_RELOAD equ 4


endc ; ELECTRUD_INC
