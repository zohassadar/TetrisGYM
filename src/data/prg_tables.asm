; place any tables that see repeated lookups here to avoid extra cycles from crossed page boundaries

pageBoundry0:
.assert <pageBoundry1 = 0, error, "pageBoundry0 shifted"

; mult10Tail pinned to the end of this page allows table lookup for all possible values of tetriminoX/Y

multBy10Table: ; needs to be first in this page with mul10Tail last
        .byte   $00,$0A,$14,$1E,$28,$32,$3C,$46
        .byte   $50,$5A,$64,$6E,$78,$82,$8C,$96
        .byte   $A0,$AA,$B4,$BE

; free space
.repeat 234
    .byte $00
.endrepeat

; add tables here and deduct from above

mult10Tail:
    .byte -20,-10
.assert (<multBy10Table) + $fe = <mult10Tail, error, "mult10Tail not $FE bytes away from multBy10Table"

pageBoundry1:
.assert <pageBoundry1 = 0, error, "pageBoundry1 shifted"

orientationTable: ; to be removed when all functions use the split table
        .byte   $00,$7B,$FF,$00,$7B,$00,$00,$7B
        .byte   $01,$FF,$7B,$00,$FF,$7B,$00,$00
        .byte   $7B,$00,$00,$7B,$01,$01,$7B,$00
        .byte   $00,$7B,$FF,$00,$7B,$00,$00,$7B
        .byte   $01,$01,$7B,$00,$FF,$7B,$00,$00
        .byte   $7B,$FF,$00,$7B,$00,$01,$7B,$00
        .byte   $FF,$7D,$00,$00,$7D,$00,$01,$7D
        .byte   $FF,$01,$7D,$00,$FF,$7D,$FF,$00
        .byte   $7D,$FF,$00,$7D,$00,$00,$7D,$01
        .byte   $FF,$7D,$00,$FF,$7D,$01,$00,$7D
        .byte   $00,$01,$7D,$00,$00,$7D,$FF,$00
        .byte   $7D,$00,$00,$7D,$01,$01,$7D,$01
        .byte   $00,$7C,$FF,$00,$7C,$00,$01,$7C
        .byte   $00,$01,$7C,$01,$FF,$7C,$01,$00
        .byte   $7C,$00,$00,$7C,$01,$01,$7C,$00
        .byte   $00,$7B,$FF,$00,$7B,$00,$01,$7B
        .byte   $FF,$01,$7B,$00,$00,$7D,$00,$00
        .byte   $7D,$01,$01,$7D,$FF,$01,$7D,$00
        .byte   $FF,$7D,$00,$00,$7D,$00,$00,$7D
        .byte   $01,$01,$7D,$01,$FF,$7C,$00,$00
        .byte   $7C,$00,$01,$7C,$00,$01,$7C,$01
        .byte   $00,$7C,$FF,$00,$7C,$00,$00,$7C
        .byte   $01,$01,$7C,$FF,$FF,$7C,$FF,$FF
        .byte   $7C,$00,$00,$7C,$00,$01,$7C,$00
        .byte   $FF,$7C,$01,$00,$7C,$FF,$00,$7C
        .byte   $00,$00,$7C,$01,$FE,$7B,$00,$FF
        .byte   $7B,$00,$00,$7B,$00,$01,$7B,$00
        .byte   $00,$7B,$FE,$00,$7B,$FF,$00,$7B
        .byte   $00,$00,$7B,$01,$00,$FF,$00,$00
        .byte   $FF,$00,$00,$FF,$00,$00,$FF,$00

; free space
.repeat 16
    .byte $00
.endrepeat

pageBoundry2:
.assert <pageBoundry2 = 0, error, "pageBoundry2 shifted"

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

orientationTableTiles:
        .byte $7B,$7B,$7B,$7B
        .byte $7B,$7B,$7B,$7B
        .byte $7B,$7B,$7B,$7B
        .byte $7B,$7B,$7B,$7B
        .byte $7D,$7D,$7D,$7D
        .byte $7D,$7D,$7D,$7D
        .byte $7D,$7D,$7D,$7D
        .byte $7D,$7D,$7D,$7D
        .byte $7C,$7C,$7C,$7C
        .byte $7C,$7C,$7C,$7C
        .byte $7B,$7B,$7B,$7B
        .byte $7D,$7D,$7D,$7D
        .byte $7D,$7D,$7D,$7D
        .byte $7C,$7C,$7C,$7C
        .byte $7C,$7C,$7C,$7C
        .byte $7C,$7C,$7C,$7C
        .byte $7C,$7C,$7C,$7C
        .byte $7B,$7B,$7B,$7B
        .byte $7B,$7B,$7B,$7B
        .byte $FF,$FF,$FF,$FF

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

; free space
.repeat 16
    .byte $00
.endrepeat

pageBoundry3:
.assert <pageBoundry3 = 0, error, "pageBoundry3 shifted"
