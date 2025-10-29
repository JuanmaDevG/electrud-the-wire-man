if !def(CONSTANTS_INC)
  def CONSTANTS_INC equ 1

;;;;;;;;;;;;;;;;;;;;;;;
; Generic definitions ;
;;;;;;;;;;;;;;;;;;;;;;;

def TILE_SIZE equ 16
def TILE_PX_WIDTH equ 8
def TILE_PX_HEIGHT equ 8

;;;;;;;;;;;;;;;;;;
; Memory regions ;
;;;;;;;;;;;;;;;;;;

def _WRAM equ $c000
def _OAM equ $fe00
def _VRAM equ $8000
def _SCRN0 equ $9800
def _SCRN1 equ $9c00

def MEM_LINE_SIZE equ 256
def OAM_BYTESIZE equ 160


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hardware registers at $ff?? ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

def rP1 equ $ff00
def rLCDC equ $ff40
def rSTAT equ $ff41
def rLY equ $ff44
def rBGP equ $ff47
def rOBP0 equ $ff48
def rOBP1 equ $ff49
def rWY equ $ff4a
def rWX equ $ff4b
def rIE equ $ffff
def rIF equ $ff0f


;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Values for rLY register ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

DEF VBLANK_START_LINE 	equ $90
def VBLANK_END_LINE     equ $99


;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Values for rIE register ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

def INTERRUPT_VBLANK equ  %00000001
def INTERRUPT_LCD equ     %00000010
def INTERRUPT_TIMER equ   %00000100
def INTERRUPT_SERIAL equ  %00001000
def INTERRUPT_JOYPAD equ  %00010000


;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Values for rP1 register ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

def SELECT_NONE equ     %00110000
def SELECT_BUTTONS equ  %00010000
def SELECT_JOYPAD equ   %00100000

def BIT_BUTTONS equ 5
def BIT_JOYPAD equ 4

def BUTTON_START equ    %00001000
def BUTTON_SELECT equ   %00000100
def BUTTON_B equ        %00000010
def BUTTON_A equ        %00000001

def JOY_DOWN equ    %00001000
def JOY_UP equ      %00000100
def JOY_LEFT equ    %00000010
def JOY_RIGHT equ   %00000001

def INPUT_START equ   %10000000
def INPUT_SELECT equ  %01000000
def INPUT_B equ       %00100000
def INPUT_A equ       %00010000
def INPUT_DOWN equ    %00001000
def INPUT_UP equ      %00000100
def INPUT_LEFT equ    %00000010
def INPUT_RIGHT equ   %00000001

def INPUT_BIT_START equ 7
def INPUT_BIT_SELECT equ 6
def INPUT_BIT_B equ 5
def INPUT_BIT_A equ 4
def INPUT_BIT_DOWN equ 3
def INPUT_BIT_UP equ 2
def INPUT_BIT_LEFT equ 1
def INPUT_BIT_RIGHT equ 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GENERIC ENTITY DEFINITIONS ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

rsset _WRAM
def COMPONENT_SPRITES   rb $100
def COMPONENT_PHYSICS   rb $100
def COMPONENT_HITBOX    rb $100

def OAM_SLOT_SIZE equ 4
; COMPONENT SPRITES
rsreset 
def ENT_Y 	    rb 1
def ENT_X 	    rb 1
def ENT_TILE 	  rb 1
def ENT_FLAGS   rb 1

def ENT_FLAGS_BIT_PRIORITY    equ 7
def ENT_FLAGS_BIT_Y_FLIP      equ 6
def ENT_FLAGS_BIT_X_FLIP      equ 5
def ENT_FLAGS_BIT_PALETTE     equ 4
def ENT_FLAGS_BIT_VRAM_BANK   equ 3

; COMPONENT_PHYSICS
rsreset
def ENT_V 		            rb 1
def ENT_V_COUNTER	        rb 1
def ENT_PHYS_FLAGS 	      rb 1

; ENT_PHYS_FLAGS bit values
def ENT_BIT_USED            equ 7
def ENT_BIT_IS_PROJECTILE   equ 6
def ENT_BIT_NO_MOVE         equ 5
def ENT_BIT_GOES_RIGHT      equ 4

def BLINK_COUNTER_RELOAD equ 3

; ENT_V and ENT_V_COUNTER
def ENT_SPEED_MAX     equ 0
def ENT_SPEED_HIGH    equ 1
def ENT_SPEED_MEDIUM  equ 2
def ENT_SPEED_MLOW    equ 3
def ENT_SPEED_LOW     equ 4
def ENT_SPEED_LOWER   equ 5
def ENT_SPEED_SNAIL   equ 6

; COMPONENT HITBOX
rsreset 
def ENT_Y_HITBOX rb 1
def ENT_H_HITBOX rb 1
def ENT_X_HITBOX rb 1
def ENT_W_HITBOX rb 1


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generic screen proportion definitions ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

def SCRN_LINE_JUMP equ $20
def SCRN_WIDTH_IN_TILES equ 20
def SCRN_HEIGHT_IN_TILES equ 18

def SCRN_PX_WIDTH equ 152
def SCRN_PX_HEIGHT equ 144
def SCRN_PX_Y_OFFSET equ 16
def SCRN_PX_X_OFFSET equ 8

def SCRN_GROUND_TILES equ _SCRN0 + (SCRN_LINE_JUMP * (SCRN_HEIGHT_IN_TILES -1))


endc ; CONSTANTS_INC
