SECTION "GameSprites", ROM0

;GENERAL TILES - Bloques y escenario
Blocks::
Barril::
DB $3C,$00,$7E,$00,$3C,$42,$42,$7E
DB $3E,$7C,$2A,$54,$6A,$56,$3C,$3C

Pipe_head::
DB $FF,$FF,$E1,$81,$9F,$E1,$9F,$E1
DB $9F,$E1,$FF,$FF,$E1,$81,$9F,$E1

Pipe_body::
DB $9F,$E1,$9F,$E1,$9F,$E1,$9F,$E1
DB $9F,$E1,$9F,$E1,$9F,$E1,$9F,$E1

Pipe_link::
DB $9F,$E1,$DF,$61,$7F,$A1,$DF,$11
DB $EF,$0B,$0F,$F7,$0F,$FF,$FF,$FF

Floor::
DB $00,$FF,$00,$FF,$00,$FF,$FF,$00
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

; ENEMY 1 - (tiles 8x8)
Enemy_1::
Enemy_1_Attack::
DB $BD,$BD,$66,$7E,$C3,$E7,$99,$C3
DB $99,$C3,$C3,$E7,$66,$7E,$BD,$BD

Enemy_1_Blink::
DB $BD,$BD,$7E,$7E,$FF,$FF,$FF,$FF
DB $FF,$FF,$FF,$FF,$7E,$7E,$BD,$BD

Enemy_1_Explosion::
DB $00,$00,$00,$00,$00,$00,$18,$18
DB $26,$3E,$51,$6F,$B4,$C3,$A2,$C1

; ENEMY 2 - (tiles 8x16)
Enemy2::
Enemy2_1::
DB $00,$00,$1F,$1F,$25,$3F,$27,$3D
DB $3F,$3F,$0C,$0C,$7F,$7F,$BD,$E1
DB $AF,$F1,$DF,$DF,$CA,$CE,$5B,$5F
DB $2F,$3F,$2B,$3B,$33,$33,$41,$41

Enemy2_2::
DB $00,$00,$1F,$1F,$25,$3F,$27,$3D
DB $3F,$3F,$0C,$0C,$7F,$7F,$BD,$E1
DB $AF,$F1,$DF,$DF,$CA,$CE,$5B,$5F
DB $2F,$3F,$2A,$3E,$2E,$3E,$18,$18

; BULLET - Proyectil (tile 8x8)
Bullet::
DB $0C,$3C,$36,$4E,$63,$87,$41,$83
DB $41,$83,$A3,$C7,$66,$7E,$3C,$3C
