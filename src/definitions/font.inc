if !def(FONT_INC)
  def FONT_INC equ 1

include "definitions/constants.inc"

def FONT_TILE_COUNT equ 66
def FONT_CHAR_COUNT equ 67
def FONT_BYTE_SIZE equ (FONT_TILE_COUNT * TILE_SIZE)

endc ; FON_INC
