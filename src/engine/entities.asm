include "definitions/constants.inc"

def MAIN_CHARACTER_OFFSET equ (3 * OAM_SLOT_SIZE)
def ENT_START_WRITEPOINT equ (COMPONENT_SPRITES + MAIN_CHARACTER_OFFSET)

SECTION "Entity management", ROM0
; DESTROYS:
allocate_projectile::
  ;TODO: projectile in WRAM
  ret
