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
INCLUDE "constants.inc"

SECTION "Entry point", ROM0[$150]

main::
   call lcdc_off
   ;;; INIT
   call tiles_init
   ;; CARGAR TILES A VRAM
   ;; CARGAR TILEMAP
   ;; CARGAR SPRITE PERSONAJE PRINCIPAL

   ; Inicializo variables
   xor a
   ; Botones
   ld [B_button], a
   .inicializo_parpadeo:            ;; esto no me mola nada aquí, provisional
      xor a
      ld hl, blink_state
      ld [hl], a
      ld a, BLINK_COUNTER_1 
      ld hl, blink_timer
      ld [hl], a

   ;; Encendemos la pantalla
   call lcdc_on

   .mainloop:
      call wait_vblank_start

      ;; render


      ;; check-end


      ;; user_input
      
      call leer_buttons
      ; tenemos el botón leído almacenado en a, y ahora leemos el bit que se ha pulsado
      call process_button
      ; si la b se ha pulsado menos tiempo que E_TC, entonces dispara
      ; si se ha pulsado durante E_TC, transformar

      ;;Si está pulsada la b (el botón de la B), comprobar transformación (en simulation)

      ;; simulate
      call sys_player_anim_update
      
      ld a, [B_button]
      or a
      jr z, .no_check_transf

      call check_transformation
      jp .end_simulate
      
      .no_check_transf:
         ld hl, electrud_physics + E_TC
         ld a, TRANSF_CNT
         ld [hl], a

      .end_simulate:

      ;; Y ya por último, actualizamos OAM
      ld hl, WRAM_START
      ld de, OAM_START
      ld b, 12                 ;; de momento copiamos 12 bytes para no copiar contadores provisionales
      call memcpy_256

      jr .mainloop

   di     ;; Disable Interrupts
   halt   ;; Halt the CPU (stop procesing here)
