.if KEYBOARD = 1
controllerInputTiles:
        ; RS    Start, Select
        ; HJKL  Left, Down, Up, Right
        ; DF -> B, A
        ;        R
        ;  DFHJKL
        ; S
        .byte "L", "H", "J", "K"
        .byte "R", "S", "D", "F"
controllerInputX:
        .byte 6*8+4, 3*8+4, 4*8+4, 5*8+4
        .byte 7*8+0, 0*8+0, 1*8-4, 2*8-4
controllerInputY:
        .byte  0, 0, 0, 0
        .byte -8, 8, 0, 0
.else
controllerInputTiles:
        ; .byte "RLDUSSBA"
        .byte $D0, $D1, $D2, $D3
        .byte $D4, $D4, $D5, $D5
controllerInputX:
        .byte $9, $0, $5, $5
        .byte $1D, $14, $28, $31
controllerInputY:
        .byte $0, $0, $5, $FB
        .byte $0, $0, $FF, $FF

.endif
controllerInputDisplay: ; called in events, speedtest
        lda #0
        sta tmp3
controllerInputDisplayX:
        lda heldButtons_player1
        sta tmp1
        ldy #0
@inputLoop:
        lda tmp1
        and #1
        beq @inputContinue
        ldx oamStagingLength
        clc
        lda controllerInputY, y
        adc #$4C
        sta oamStaging, x
        inx
        lda controllerInputTiles, y
        sta oamStaging, x
        inx
.if KEYBOARD = 1
        cmp #'R'
        beq @red
        cmp #'S'
        bne @noRed
@red:
        lda #$03
        bne @storeAttr
@noRed:
.endif
        lda #$01
@storeAttr:
        sta oamStaging, x
        inx
        lda controllerInputX, y
        clc
.if KEYBOARD = 1
        adc #$10
.else
        adc #$13
.endif
        adc tmp3
        sta oamStaging, x
        inx
        ; increase OAM index
        lda #$04
        clc
        adc oamStagingLength
        sta oamStagingLength
@inputContinue:
        lda tmp1
        ror
        sta tmp1
        iny
        cpy #8
        bmi @inputLoop

        ldx oamStagingLength
        lda repeats
        bmi @zero
        bne @notZeroOrOne
        readKeyDirect key1  ; only display when held
        beq @ret
        lda #$00
        beq @skipMultiply
; x
@zero:
        clc
        adc #$0A
@notZeroOrOne:
        sta generalCounter ; multiply by 7
        asl
        asl
        asl
        sec
        sbc generalCounter
@skipMultiply:
        clc
        adc #$0C
        sta oamStaging+3,x
; tile
        ldy repeats
        iny
        tya
        sta oamStaging+1,x
; attr
        lda #$01
        sta oamStaging+2,x
; y
        lda #$45
        sta oamStaging+0,x

        inx
        inx
        inx
        inx
        stx oamStagingLength
@ret:
        rts
