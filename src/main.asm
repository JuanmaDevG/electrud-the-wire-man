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
   call load_engine

   ; Inicializo variables
   xor a
   ; Botones
   ld [B_button], a
   .inicializo_parpadeo:
      xor a
      ld hl, blink_state
      ld [hl], a
      ld a, BLINK_COUNTER_1 
      ld hl, blink_timer
      ld [hl], a

   ;; Encendemos la pantalla
   call lcdc_on

   .mainloop:
      call update_electrud
      call update_entities
      call update_map_scroll
      call wait_vblank_start
      call render
      jr .mainloop

      ;; render


      ;; check-end


      ;; user_input:    joypad[direcciones]    &     buttons [A,B,SELECT,START]
      .user_input:
         call leer_joypad
         call process_joypad

         call leer_buttons       ; tenemos el botón leído almacenado en a, y ahora leemos el bit que se ha pulsado
         call process_button
         ; si la b se ha pulsado menos tiempo que E_TC, entonces dispara
         ; si se ha pulsado durante E_TC, transformar

      ;; simulate
      call sys_player_anim_update
      call move_electrud_raysnake
      
      ld a, [B_button]
      or a
      jr z, .check_firing

      call check_transformation
      jp .end_simulate
      
      ; Si no se ha pulsado la tecla b, hay 2 opciones
      ; Que se haya pulsado antes pero no se ha mantenido lo suficiente, por lo tanto HAY QUE DISPARAR
      ; O simplemente que no se ha pulsado
      .check_firing:
         ld hl, electrud_physics + E_TC
         ld a, [hl]
         cp TRANSF_CNT
      jr z, .no_firing           ; Si eran iguales (zero), es que no se había pulsado antes el botón

      ; En caso de que SÍ se hubiera pulsado, entonces habrá que llamar a la subrutina correspondiente
      ; call power_up

      ld a, TRANSF_CNT
      ld [hl], a

      .no_firing:
         ;; igual hay algo más por hacer aquí
      .end_simulate:

      ;; Y ya por último, actualizamos OAM
      ld hl, WRAM_START
      ld de, OAM_START
      ld b, 12                 ;; de momento copiamos 12 bytes para no copiar contadores provisionales
      call memcpy_256

      jr .mainloop

   di     ;; Disable Interrupts
   halt   ;; Halt the CPU (stop procesing here)
