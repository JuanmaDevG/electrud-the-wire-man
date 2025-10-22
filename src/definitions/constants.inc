if !def(CONSTANTS_INC)
  def CONSTANTS_INC equ 1

;;;;;;;;;;;;;;;;;;;;;;;
; Generic definitions ;
;;;;;;;;;;;;;;;;;;;;;;;

def TILE_SIZE equ 16

;;;;;;;;;;;;;;;;;;
; Memory regions ;
;;;;;;;;;;;;;;;;;;

def _WRAM equ $c000
def _OAM equ $fe00
def _VRAM equ $8000
def _SCRN0 equ $9800
def _SCRN1 equ $9c00


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hardware registers at $ff?? ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

def rP1 equ $ff00
def rLCDC equ $ff40
def rSTAT equ $ff41
def rLY equ $ff44
def rBGP equ $ff47
def rOBP0 equ $ff48
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

DEF BLINK_COUNTER_1 	equ 3
DEF BLINK_COUNTER_2 	equ 3

DEF SPEED_COUNTER 		equ 2
DEF PASO_MOVIMIENTO 	equ 2

; CONSTANTES PARA LOS BYTES DEL COMPONENTE DE SPRITE
RSRESET 
DEF E_Y 	RB 1
DEF E_X 	RB 1
DEF E_TILE 	RB 1
DEF E_FLAGS RB 1

;CONSTANTES PARA LOS BYTES DEL COMPONENTE DE PHYSICS
RSRESET
DEF E_V 		RB 1
DEF E_V_CONT	RB 1		;; CONTADOR DE FRAMES PARA MOVERSE MÁS O MENOS RÁPIDO
DEF E_EL_FL 	RB 1		;; ELECTRUD FLAGS
DEF E_TC		RB 1		;; TRANSFORMER COUNTER


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Generic game map definitions ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

def SCRN_LINE_JUMP equ $20
def SCRN_TILE_WIDTH equ 19
def SCRN_TILE_HEIGHT equ 18

def MAP_GROUND equ _SCRN0 + (SCRN_LINE_JUMP * (SCRN_LINE_HEIGHT -1))


endc ; CONSTANTS_INC
