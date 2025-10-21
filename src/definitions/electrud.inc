if !def(ELECTRUD_INC)
  def ELECTRUD_INC

include "assets.inc"

def ELECTRUD_TILE_COUNT equ 22

rsreset FONT_CHAR_COUNT
E_TILE_HEAD:                    rs 1
E_TILE_BLINKED_HEAD:            rs 1
E_TILE_BODY:                    rs 1
E_TILE_BODY_WALK1:              rs 1
E_TILE_BODY_WALK1:              rs 1
E_TILE_JUMP:                    rs 1
E_TILE_BLINKED_JUMP:            rs 1
RSNK_TILE_HEAD:                 rs 1
RSNK_TILE_BLINKED_HEAD:         rs 1
RSNK_TILE_BODY:                 rs 1
RSNK_TILE_BLINKED_BODY:         rs 1
RSNK_TILE_DIAG_BODY:            rs 1
RSNK_TILE_DIAG_BLINKED_BODY:    rs 1
E_PROJECTILE:                   rs 1
E_BLINKED_PROJECTILE:           rs 1
E_EXPLOSION1:                   rs 1
E_EXPLOSION2:                   rs 1
E_EXPLOSION3:                   rs 1
E_EXPLOSION4:                   rs 1
RSNK_DASH1:                     rs 1
RSNK_DASH2:                     rs 1


DEF E_BIT_ALIVE 		equ 7
DEF E_BIT_RAYSNAKE 		equ 6
DEF E_BIT_JMP			equ 5
DEF E_BIT_WALK			equ 4

DEF E_BIT_MV_RIGHT		equ 3
DEF E_BIT_MV_LEFT		equ 2
DEF E_BIT_MV_UP			equ 1
DEF E_BIT_MV_DOWN 		equ 0

def E_TRANSF_CNT equ 90

endc ; ELECTRUD_INC
