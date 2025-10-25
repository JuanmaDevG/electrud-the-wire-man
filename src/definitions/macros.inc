if !def(MACROS_INC)
  def MACROS_INC equ 1

macro Load_hldebc
  ld hl, \1
  ld de, \2
  ld bc, \3
endm

macro Load_hlabc
  ld hl, \1
  ld a, \2
  ld bc, \3
endm


endc ; MACROS_INC
