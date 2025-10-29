;;----------LICENSE NOTICE-------------------------------------------------------------------------------------------------------;;
;;  This file is part of GBTelera: A Gameboy Development Framework                                                               ;;
;;  Copyright (C) 2024 ronaldo / Cheesetea / ByteRealms (@FranGallegoBR)                                                         ;;
;;                                                                                                                               ;;
;; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    ;;
;; files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy,    ;;
;; modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the         ;;
;; Softwareis furnished to do so, subject to the following conditions:                                                           ;;
;;                                                                                                                               ;;
;; The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.;;
;;                                                                                                                               ;;
;; THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          ;;
;; WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         ;;
;; COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   ;;
;; ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         ;;
;;-------------------------------------------------------------------------------------------------------------------------------;;
include "definitions/constants.inc"

;TODO: remove this
include "definitions/electrud.inc"

SECTION "Entry point", ROM0[$150]

main::
  di
  call lcdc_off
  call load_engine
  call lcdc_on

  .mainloop:
    call get_input

    ; TODO: delete this, is temporary
    ld a, [COMPONENT_PHYSICS + E_PLAYER_INPUT]
    bit INPUT_BIT_B, a
    jr z, .not_kill
      ld hl, COMPONENT_PHYSICS + E_FLAGS
      res E_BIT_ALIVE, [hl]
    .not_kill:

    call update_main_player
    call update_entities
    call update_map_scroll
    call render
    jr .mainloop
