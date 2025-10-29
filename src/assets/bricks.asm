SECTION "Map tiles", ROM0
brick_tiles::
; default wall
DB $FF, $FF, $FF, $E1, $FF, $C3, $FF, $87
DB $FF, $8F, $FF, $9F, $FF, $BD, $FF, $FF


SECTION "General tiles", ROM0
general_tiles::
; Barril
DB $3C,$00,$7E,$00,$3C,$42,$42,$7E
DB $3E,$7C,$2A,$54,$6A,$56,$3C,$3C
; Pipe head
DB $FF,$FF,$E1,$81,$9F,$E1,$9F,$E1
DB $9F,$E1,$FF,$FF,$E1,$81,$9F,$E1
; Pipe body
DB $9F,$E1,$9F,$E1,$9F,$E1,$9F,$E1
DB $9F,$E1,$9F,$E1,$9F,$E1,$9F,$E1
; Pipe link
DB $9F,$E1,$DF,$61,$7F,$A1,$DF,$11
DB $EF,$0B,$0F,$F7,$0F,$FF,$FF,$FF
; Floor
DB $00,$FF,$00,$FF,$00,$FF,$FF,$00
DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
