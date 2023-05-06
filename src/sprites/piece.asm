stageSpriteForCurrentPiece:
        lda #$0
        sta pieceTileModifier
        jsr stageSpriteForCurrentPiece_actual

        lda practiseType
        cmp #MODE_HARDDROP
        beq ghostPiece
        rts

ghostPiece:
        lda playState
        cmp #3
        bpl @noGhost
        lda tetriminoY
        sta tmp3
@loop:
        inc tetriminoY
        jsr isPositionValid
        beq @loop
        dec tetriminoY

        ; check if equal to current position
        lda tetriminoY
        cmp tmp3
        beq @noGhost

        lda frameCounter
        and #1
        asl
        asl
        adc #$0D
        sta pieceTileModifier
        jsr stageSpriteForCurrentPiece_actual
        lda tmp3
        sta tetriminoY
@noGhost:
        rts

tileModifierForCurrentPiece:
        lda pieceTileModifier
        beq @tileNormal
        and #$80
        bne @tileSingle
; @tileMultiple:
        lda orientationTable,x
        clc
        adc pieceTileModifier
        rts
@tileSingle:
        lda pieceTileModifier
        rts
@tileNormal:
        lda orientationTable,x
        rts

upsideDownOffset:
        .byte $00,$F6

stageSpriteForCurrentPiece_actual:
        lda tetriminoX
        cmp #TETRIMINO_X_HIDE
        bne @notHidden
        rts
@notHidden:
        asl a
        asl a
        asl a
        adc #$60
        sta generalCounter3
        clc
        lda tetriminoY
        rol a
        rol a
        rol a
        adc #$2F
        sta generalCounter4
        lda currentPiece
        sta generalCounter5
        clc
        lda generalCounter5
        rol a
        rol a
        sta generalCounter
        rol a
        adc generalCounter
        tax
        ldy oamStagingLength
        lda #$04
        sta generalCounter2
@stageMino:  
        lda orientationTable,x
        asl a
        asl a
        asl a
        clc
        adc generalCounter4
        sta generalCounter5
        lda upsideDownFlag
        beq @notUpsideDown
        lda #$F6
        sec
        sbc generalCounter5
        jmp @endUpsideDown
@notUpsideDown:
        lda generalCounter5
@endUpsideDown:
        sta oamStaging,y
        sta originalY
        inc oamStagingLength
        iny
        inx
        jsr tileModifierForCurrentPiece ; used to just load from orientationTable
        ; lda orientationTable, x
        sta oamStaging,y
        inc oamStagingLength
        iny
        inx
        lda #$02
        sta oamStaging,y
        lda upsideDownFlag
        beq @notUpsideDown2
        lda originalY
        cmp #$C8 ; Maximum value in upside down mode
        bcc @validYCoordinate
        jmp @endUpsideDown2
@notUpsideDown2:
        lda originalY
        cmp #$2F ; Minimum value in normal mode
        bcs @validYCoordinate
@endUpsideDown2:
        inc oamStagingLength
        dey
        lda #$FF
        sta oamStaging,y
        iny
        iny
        lda #$00
        sta oamStaging,y
        jmp @finishLoop

@validYCoordinate:  
        inc oamStagingLength
        iny
        lda orientationTable,x
        asl a
        asl a
        asl a
        clc
        adc generalCounter3
        sta oamStaging,y
@finishLoop:  
        inc oamStagingLength
        iny
        inx
        dec generalCounter2
        bne @stageMino
        rts

stageSpriteForNextPiece:
        lda qualFlag
        beq @alwaysNextBox
        lda displayNextPiece
        bne @ret

@alwaysNextBox:
        lda #$C8
        sta spriteXOffset
        lda #$77
        sta spriteYOffset
        ldx nextPiece
        lda orientationToSpriteTable,x
        ldx upsideDownFlag
        beq @notUpsideDown
        clc
        adc #$1d
@notUpsideDown:
        sta spriteIndexInOamContentLookup
        jmp loadSpriteIntoOamStaging
@ret:   rts
