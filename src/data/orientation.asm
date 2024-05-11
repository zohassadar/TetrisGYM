tileHidden = $FF

orientationTable:

        .byte    0, $A2,-1, 0, $A8, 0, 0, $A4, 1,-1, $A5, 0 ; $-2E t up
        .byte   -1, $A5, 0, 0, $A9, 0, 0, $A4, 1, 1, $A7, 0 ; $-2D t right
        .byte    0, $A2,-1, 0, $AA, 0, 0, $A4, 1, 1, $A7, 0 ; $-2C t down (spawn)
        .byte   -1, $A5, 0, 0, $A2,-1, 0, $AB, 0, 1, $A7, 0 ; $-2B t left

        .byte   -1, $C5, 0, 0, $C6, 0, 1, $C2,-1, 1, $CF, 0 ; $-2A j left
        .byte   -1, $C5,-1, 0, $CE,-1, 0, $C3, 0, 0, $C4, 1 ; $-29 j up
        .byte   -1, $CC, 0,-1, $C4, 1, 0, $C6, 0, 1, $C7, 0 ; $-28 j right
        .byte    0, $C2,-1, 0, $C3, 0, 0, $CD, 1, 1, $C7, 1 ; $-27 j down (spawn)

        .byte    0, $B2,-1, 0, $BD, 0, 1, $BE, 0, 1, $B4, 1 ; $-26 z horizontal (spawn)
        .byte   -1, $B5, 1, 0, $BC, 0, 0, $BF, 1, 1, $B7, 0 ; $-25 z vertical

        .byte    0, $AC,-1, 0, $AD, 0, 1, $AE,-1, 1, $AF, 0 ; $-24 o (spawn)

        .byte    0, $CC, 0, 0, $C4, 1, 1, $C2,-1, 1, $CF, 0 ; $-23 s horizontal (spawn)
        .byte   -1, $C5, 0, 0, $CE, 0, 0, $CD, 1, 1, $C7, 1 ; $-22 s vertical

        .byte   -1, $B5, 0, 0, $B6, 0, 1, $BE, 0, 1, $B4, 1 ; $-21 l right
        .byte    0, $BC,-1, 0, $B3, 0, 0, $B4, 1, 1, $B7,-1 ; $-20 l down (spawn)
        .byte   -1, $B2,-1,-1, $BD, 0, 0, $B6, 0, 1, $B7, 0 ; $-1F l left
        .byte   -1, $B5, 1, 0, $B2,-1, 0, $B3, 0, 0, $BF, 1 ; $-1E l up

        .byte   -2, $A5, 0,-1, $A6, 0, 0, $A6, 0, 1, $A7, 0 ; $-1D i vertical
        .byte    0, $A2,-2, 0, $A3,-1, 0, $A3, 0, 0, $A4, 1 ; $-1C i horizontal (spawn)

        ; Hidden orientation used during line clear animation and game over curtain
        .byte    0, tileHidden, 0, 0, tileHidden, 0, 0, tileHidden, 0, 0, tileHidden, 0 ; $13


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
