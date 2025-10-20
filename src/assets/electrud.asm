INCLUDE "constants.inc"

SECTION "Electrud tiles", ROM0
electrud_tiles::
; head
DB $54,$54,$AA,$AA,$7C,$7C,$C2,$FE
DB $41,$6B,$C1,$FF,$22,$3E,$3C,$3C
; blinked head
DB $54,$54,$AA,$AA,$7C,$7C,$C2,$C2
DB $55,$55,$C1,$C1,$22,$22,$3C,$3C
; body stop
DB $7E,$66,$FF,$89,$FF,$B5,$FF,$E7
DB $BD,$E7,$5A,$5A,$24,$3C,$7E,$7E
; body walk 1
DB $7E,$52,$3C,$2C,$3C,$34,$3A,$2E
DB $3E,$26,$18,$3C,$24,$24,$36,$36
; body walk 2
DB $3C,$24,$7E,$5A,$BD,$E7,$FF,$E7
DB $24,$3C,$3C,$3C,$42,$66,$63,$63
; electro jump
DB $06,$0C,$1C,$08,$30,$18,$3C,$3C
DB $0C,$18,$38,$10,$20,$70,$60,$40
; blinked electro jump
DB $0A,$0A,$14,$14,$2C,$28,$42,$42
DB $34,$14,$28,$28,$50,$50,$20,$A0
; ray-snake head
DB $00,$00,$7C,$7C,$82,$FE,$41,$77
DB $81,$FF,$42,$7E,$FC,$FC,$00,$00
; blinked ray-snake head
DB $00,$00,$7C,$7C,$FE,$82,$7F,$49
DB $FF,$81,$7E,$42,$FC,$FC,$00,$00
; ray-snake tail
DB $00,$00,$00,$88,$DD,$88,$55,$FF
DB $77,$22,$00,$22,$00,$00,$00,$00
; blinked ray-snake tail
DB $00,$00,$88,$88,$00,$55,$AA,$AA
DB $00,$55,$22,$22,$00,$00,$00,$00
; diagonal ray-snake tail
DB $05,$03,$0F,$07,$15,$0E,$3E,$1C
DB $54,$38,$78,$F0,$D0,$60,$E0,$C0
; blinked diagonal ray-snake tail
DB $02,$06,$00,$08,$0A,$1B,$00,$22
DB $28,$6C,$80,$88,$20,$B0,$00,$20
; projectile
DB $40,$02,$20,$04,$1B,$D8,$24,$3C
DB $24,$3C,$58,$1A,$84,$21,$04,$20
; blinked projectile
DB $00,$00,$04,$24,$64,$42,$18,$10
DB $18,$08,$26,$42,$20,$24,$00,$00
; explosion phase 1
DB $00,$00,$00,$00,$18,$00,$3C,$18
DB $3C,$18,$18,$00,$00,$00,$00,$00
; explosion phase 2
DB $00,$00,$3C,$00,$7E,$18,$66,$24
DB $66,$24,$7E,$18,$3C,$00,$00,$00
; explosion phase 3
DB $3C,$3C,$42,$7E,$99,$E7,$A5,$C3
DB $A5,$C3,$99,$E7,$42,$7E,$3C,$3C
; explosion phase 4
DB $42,$7E,$BD,$C3,$66,$81,$42,$81
DB $42,$81,$66,$81,$BD,$C3,$42,$7E
; dash phase 1
DB $08,$08,$C4,$C4,$32,$32,$0D,$0D
DB $0D,$0D,$32,$32,$C4,$C4,$08,$08
; dash phase 2
DB $C0,$C0,$30,$30,$CC,$CC,$33,$33
DB $33,$33,$CC,$CC,$30,$30,$C0,$C0


electrud_sprites_def:
	DB $0B*8 + 16, 	$01*8 + 8, 	$01, $00	;; cabeza electrud
	DB $0C*8 + 16, 	$01*8 + 8, 	$03, $00	;; cuerpo ""


electrud_physics_cmp:
	DB $01, SPEED_COUNTER, $80, TRANSF_CNT			;;Tenemos:		 Velocidad - contador de frames para velocidad - flags - contador de transformación

	;; TILES DE ELECTRUD-SERPIENTE
	;DB $0C*8 + 16, 	$08, 	$0A, $00   	;; cola serpiente
	;DB $0C*8 + 16, 	$08+8, 	$0A, $00   	;; cola ""
	;DB $0C*8 + 16, 	$08+16, $08, $00   	;; cabeza


