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
        bcc @loop
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

xCoord = generalCounter3
yCoord = generalCounter4
tile = generalCounter5
tileCounter = generalCounter2

minimimYCoord = 47

stageSpriteForCurrentPiece_actual:
        lda tetriminoX
        cmp #TETRIMINO_X_HIDE
        bne @carryOn
        rts
@carryOn:
        ldy spriteDoubles
@doubleX:
        asl a
        dey
        bne @doubleX
        adc #$60 ; clc omission is from original code.   3*asl for 0-9 will result in clear carry
        sta xCoord
        ldy spriteDoubles
        lda tetriminoY
@doubleY:
        asl a
        dey
        bne @doubleY
        clc
        adc yOffset
        sta yCoord
        lda currentPiece
        tay ; index into tiles
        asl
        asl
        tax ; index into Y & X Offsets
        lda orientationTiles,y
        ldy practiseType
        cpy #MODE_SMALL
        bne @loadPieceTile
        lda #$C1
        bne @storeTile
@loadPieceTile:
;         ldy pieceTileModifier
;         beq @storeTile
;         bpl @tileMultiple
;         tya
;         bmi @storeTile
; @tileMultiple:
;         clc
;         adc pieceTileModifier
@storeTile:
        ldy oamStagingLength
        sta oamStaging+1,y
        sta oamStaging+5,y
        sta oamStaging+9,y
        sta oamStaging+13,y
        lda #$04
        sta tileCounter
         ; y is oam y coordinate
@stageMino:  
        lda spriteDoubles
        sta generalCounter
        lda orientationYOffsets,x
@doubleXOffset:
        asl a
        dec generalCounter
        bne @doubleXOffset
        clc
        adc yCoord
        cmp #minimimYCoord
        bcs @validY
        lda #$FF
@validY:
        sta oamStaging,y
        iny ; oam tile
        iny ; oam attribute
        lda #$02
        sta oamStaging,y
        iny ; oam x coordinate
        lda spriteDoubles
        sta generalCounter
        lda orientationXOffsets,x
@doubleYOffset:
        asl a
        dec generalCounter
        bne @doubleYOffset
        clc
        adc xCoord
        sta oamStaging,y
@finishLoop:  
        iny
        inx
        dec tileCounter
        bne @stageMino
        sty oamStagingLength
        lda practiseType
        cmp #MODE_BIG
        beq @expandBigSprites
@ret:   rts

@expandBigSprites:
        tya
        sec
        sbc #$10
        tay
        lda #$04
        sta generalCounter
@loop:
        lda oamStaging+1,y
        cmp #EMPTY_TILE
        beq @nextPiece
        lda oamStaging,y
        cmp #$F0
        bcs @nextPiece
        sta oamStaging+16,y
        clc
        adc #$08
        sta oamStaging+32,y
        sta oamStaging+48,y

        lda oamStaging+1,y
        clc
        adc #$10
        sta oamStaging+1,y
        adc #$10
        sta oamStaging+16+1,y
        adc #$10
        sta oamStaging+32+1,y
        adc #$10
        sta oamStaging+48+1,y

        lda oamStaging+2,y
        sta oamStaging+16+2,y
        sta oamStaging+32+2,y
        sta oamStaging+48+2,y

        lda oamStaging+3,y
        sta oamStaging+32+3,y
        clc
        adc #$08
        sta oamStaging+16+3,y
        sta oamStaging+48+3,y
@nextPiece:
        iny
        iny
        iny
        iny
        dec generalCounter
        bne @loop
        tya
        clc
        adc #$30
        sta oamStagingLength
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
        sta spriteIndexInOamContentLookup
        jmp loadSpriteIntoOamStaging
@ret:   rts
