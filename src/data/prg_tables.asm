; place any tables that see repeated lookups here to avoid extra cycles from crossed page boundaries

pageBoundry0:
.assert <pageBoundry0 = 0, error, "pageBoundry0 shifted"

; mult10Tail pinned to the end of this page allows table lookup for all possible values of tetriminoX/Y

multBy10Table: ; needs to be first in this page with mul10Tail last
        .byte   $00,$0A,$14,$1E,$28,$32,$3C,$46
        .byte   $50,$5A,$64,$6E,$78,$82,$8C,$96
        .byte   $A0,$AA,$B4,$BE

; free space
.repeat 10
    .byte $00
.endrepeat

; add tables here and deduct from above


multBy32Table:
        .byte 0,32,64,96,128,160,192,224

multBy100Table:
        .byte $0, $64, $c8, $2c, $90
        .byte $f4, $58, $bc, $20, $84

orientationTableTiles:
        .byte $7B,$7B,$7B,$7B ; T
        .byte $7D,$7D,$7D,$7D ; J
        .byte $7C,$7C         ; Z
        .byte $7B             ; O
        .byte $7D,$7D         ; S
        .byte $7C,$7C,$7C,$7C ; L
        .byte $7B,$7B         ; I
        .byte $FF             ; hidden ($13)

tetriminoTypeFromOrientation:
        .byte   $00,$00,$00,$00,$01,$01,$01,$01
        .byte   $02,$02,$03,$04,$04,$05,$05,$05
        .byte   $05,$06,$06

spawnTable:
        .byte   $02,$07,$08,$0A,$0B,$0E,$12

orientationTableY:
        .byte $00,$00,$00,$FF
        .byte $FF,$00,$00,$01
        .byte $00,$00,$00,$01
        .byte $FF,$00,$00,$01
        .byte $FF,$00,$01,$01
        .byte $FF,$00,$00,$00
        .byte $FF,$FF,$00,$01
        .byte $00,$00,$00,$01
        .byte $00,$00,$01,$01
        .byte $FF,$00,$00,$01
        .byte $00,$00,$01,$01
        .byte $00,$00,$01,$01
        .byte $FF,$00,$00,$01
        .byte $FF,$00,$01,$01
        .byte $00,$00,$00,$01
        .byte $FF,$FF,$00,$01
        .byte $FF,$00,$00,$00
        .byte $FE,$FF,$00,$01
        .byte $00,$00,$00,$00
        .byte $00,$00,$00,$00

orientationTableX:
        .byte $FF,$00,$01,$00
        .byte $00,$00,$01,$00
        .byte $FF,$00,$01,$00
        .byte $00,$FF,$00,$00
        .byte $00,$00,$FF,$00
        .byte $FF,$FF,$00,$01
        .byte $00,$01,$00,$00
        .byte $FF,$00,$01,$01
        .byte $FF,$00,$00,$01
        .byte $01,$00,$01,$00
        .byte $FF,$00,$FF,$00
        .byte $00,$01,$FF,$00
        .byte $00,$00,$01,$01
        .byte $00,$00,$00,$01
        .byte $FF,$00,$01,$FF
        .byte $FF,$00,$00,$00
        .byte $01,$FF,$00,$01
        .byte $00,$00,$00,$00
        .byte $FE,$FF,$00,$01
        .byte $00,$00,$00,$00

mult10Tail:
    .byte -20,-10
.assert (<multBy10Table) + $fe = <mult10Tail, warning, "mult10Tail not $FE bytes away from multBy10Table"

pageBoundry1:
.assert <pageBoundry1 = 0, warning, "pageBoundry1 shifted"


; uncomment for another page

; free space
; .repeat 256
;     .byte $00
; .endrepeat

; pageBoundry2:
; .assert <pageBoundry2 = 0, warning, "pageBoundry2 shifted"
