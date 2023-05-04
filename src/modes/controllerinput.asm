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

controllerInputDisplay: ; called in events, speedtest
        lda #0
        sta tmp3
controllerInputDisplayX:
; swap up & down back for upside down
        lda upsideDownFlag
        beq @notUpsideDown  
        lda heldButtons_player1
        and #BUTTON_UP
        lsr
        sta tmp1
        lda heldButtons_player1
        and #BUTTON_DOWN
        asl
        sta tmp2
        lda heldButtons_player1
        and #$F3
        ora tmp1
        ora tmp2
        sta tmp1
        jmp @endUpsideDown
@notUpsideDown:
        lda heldButtons_player1
        sta tmp1
@endUpsideDown:
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
        lda #$01
        sta oamStaging, x
        inx
        lda controllerInputX, y
        clc
        adc #$13
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
        rts
