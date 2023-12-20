orientationTable:
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

orientationYOffsets:
        .byte   $00,$00,$00,$FF ; t
        .byte   $FF,$00,$00,$01
        .byte   $00,$00,$00,$01
        .byte   $FF,$00,$00,$01 

        .byte   $FF,$00,$01,$01 ; j
        .byte   $FF,$00,$00,$00
        .byte   $FF,$FF,$00,$01
        .byte   $00,$00,$00,$01

        .byte   $00,$00,$01,$01 ; z
        .byte   $FF,$00,$00,$01

        .byte   $00,$00,$01,$01 ; o

        .byte   $00,$00,$01,$01 ; s
        .byte   $FF,$00,$00,$01

        .byte   $FF,$00,$01,$01 ; l
        .byte   $00,$00,$00,$01
        .byte   $FF,$FF,$00,$01
        .byte   $FF,$00,$00,$00

        .byte   $FE,$FF,$00,$01 ; i
        .byte   $00,$00,$00,$00

        .byte   $00,$00,$00,$00 ; hidden

orientationXOffsets:
        .byte   $FF,$00,$01,$00 ; t
        .byte   $00,$00,$01,$00
        .byte   $FF,$00,$01,$00
        .byte   $00,$FF,$00,$00

        .byte   $00,$00,$FF,$00 ; j
        .byte   $FF,$FF,$00,$01
        .byte   $00,$01,$00,$00
        .byte   $FF,$00,$01,$01

        .byte   $FF,$00,$00,$01 ; z
        .byte   $01,$00,$01,$00

        .byte   $FF,$00,$FF,$00 ; o

        .byte   $00,$01,$FF,$00 ; s
        .byte   $00,$00,$01,$01

        .byte   $00,$00,$00,$01 ; l
        .byte   $FF,$00,$01,$FF
        .byte   $FF,$00,$00,$00
        .byte   $01,$FF,$00,$01

        .byte   $00,$00,$00,$00 ; i
        .byte   $FE,$FF,$00,$01

        .byte   $00,$00,$00,$00 ; hidden

orientationTiles:
        .byte $7B,$7B,$7B,$7B   ; t
        .byte $7D,$7D,$7D,$7D   ; j
        .byte $7C,$7C           ; z
        .byte $7B               ; o
        .byte $7D,$7D           ; s
        .byte $7C,$7C,$7C,$7C   ; l
        .byte $7B,$7B           ; i
        .byte EMPTY_TILE

; Only cares about orientations selected by spawnTable
orientationToSpriteTable:
        .byte   $00,$00,$06,$00,$00,$00,$00,$09
        .byte   $08,$00,$0B,$07,$00,$00,$0A,$00
        .byte   $00,$00,$0C

tetriminoTypeFromOrientation:
        .byte   $00,$00,$00,$00,$01,$01,$01,$01
        .byte   $02,$02,$03,$04,$04,$05,$05,$05
        .byte   $05,$06,$06
spawnTable:
        .byte   $02,$07,$08,$0A,$0B,$0E,$12
        .byte   $02
spawnOrientationFromOrientation:
        .byte   $02,$02,$02,$02,$07,$07,$07,$07
        .byte   $08,$08,$0A,$0B,$0B,$0E,$0E,$0E
        .byte   $0E,$12,$12
