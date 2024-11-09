; place any tables that see repeated lookups here to avoid extra cycles from crossed page boundaries


; mult10Tail at end of this page allows table lookup for all possible values of tetriminoY (-2..=20)
pageBoundary0:
.assert <pageBoundary0 = 0, error, "pageBoundary0 shifted"


; needs to be first in this page with mul10Tail last
multBy10Table:                                                  ; 20
        .byte   $00,$0A,$14,$1E,$28,$32,$3C,$46
        .byte   $50,$5A,$64,$6E,$78,$82,$8C,$96
        .byte   $A0,$AA,$B4,$BE

multBy32Table:                                                  ; 8
        .byte 0,32,64,96,128,160,192,224

multBy100Table:                                                 ; 10
        .byte $0, $64, $c8, $2c, $90
        .byte $f4, $58, $bc, $20, $84

spawnTable:                                                     ; 7
        .byte   $02,$07,$08,$0A,$0B,$0E,$12

tetriminoTypeFromOrientation:                                   ; 19
        .byte   $00,$00,$00,$00,$01,$01,$01,$01
        .byte   $02,$02,$03,$04,$04,$05,$05,$05
        .byte   $05,$06,$06

tetriminoTileFromOrientation:                                   ; 20
        .byte   $7B,$7B,$7B,$7B,$7D,$7D,$7D,$7D
        .byte   $7C,$7C,$7B,$7D,$7D,$7C,$7C,$7C
        .byte   $7C,$7B,$7B,$FF

orientationTableY:                                              ; 80
        .byte   $00,$00,$00,$FF ; $00 t up
        .byte   $FF,$00,$00,$01 ; $01 t right
        .byte   $00,$00,$00,$01 ; $02 t down
        .byte   $FF,$00,$00,$01 ; $03 t left
        .byte   $FF,$00,$01,$01 ; $04 j left
        .byte   $FF,$00,$00,$00 ; $05 j up
        .byte   $FF,$FF,$00,$01 ; $06 j right
        .byte   $00,$00,$00,$01 ; $07 j down
        .byte   $00,$00,$01,$01 ; $08 z horizontal
        .byte   $FF,$00,$00,$01 ; $09 z vertical
        .byte   $00,$00,$01,$01 ; $0a o
        .byte   $00,$00,$01,$01 ; $0b s horizontal
        .byte   $FF,$00,$00,$01 ; $0c s vertical
        .byte   $FF,$00,$01,$01 ; $0d l right
        .byte   $00,$00,$00,$01 ; $0e l down
        .byte   $FF,$FF,$00,$01 ; $0f l left
        .byte   $FF,$00,$00,$00 ; $10 l up
        .byte   $FE,$FF,$00,$01 ; $11 i vertical
        .byte   $00,$00,$00,$00 ; $12 i horizontal
        .byte   $00,$00,$00,$00 ; $13 hidden

orientationTableX:                                              ; 80
        .byte   $FF,$00,$01,$00 ; $00 t up
        .byte   $00,$00,$01,$00 ; $01 t right
        .byte   $FF,$00,$01,$00 ; $02 t down
        .byte   $00,$FF,$00,$00 ; $03 t left
        .byte   $00,$00,$FF,$00 ; $04 j left
        .byte   $FF,$FF,$00,$01 ; $05 j up
        .byte   $00,$01,$00,$00 ; $06 j right
        .byte   $FF,$00,$01,$01 ; $07 j down
        .byte   $FF,$00,$00,$01 ; $08 z horizontal
        .byte   $01,$00,$01,$00 ; $09 z vertical
        .byte   $FF,$00,$FF,$00 ; $0a o
        .byte   $00,$01,$FF,$00 ; $0b s horizontal
        .byte   $00,$00,$01,$01 ; $0c s vertical
        .byte   $00,$00,$00,$01 ; $0d l right
        .byte   $FF,$00,$01,$FF ; $0e l down
        .byte   $FF,$00,$00,$00 ; $0f l left
        .byte   $01,$FF,$00,$01 ; $10 l up
        .byte   $00,$00,$00,$00 ; $11 i vertical
        .byte   $FE,$FF,$00,$01 ; $12 i horizontal
        .byte   $00,$00,$00,$00 ; $13 hidden


; free space
.repeat 10
    .byte $00
.endrepeat

mult10Tail:                                                     ; 2
    .byte $EC,$F6 ; -20,-10

.assert (<multBy10Table) + $fe = <mult10Tail, error, "mult10Tail is not multBy10Table + $FE"

pageBoundary1:
.assert <pageBoundary1 = 0, warning, "pageBoundary1 shifted"


; uncomment for another page

; free space
; .repeat 256
;     .byte $00
; .endrepeat

; pageBoundary2:
; .assert <pageBoundary2 = 0, warning, "pageBoundary2 shifted"
