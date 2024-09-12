initDroughtInfoAndChooseNext:
    lda practiseType
    cmp #MODE_SEED
    bne normalRng
    lda #<pieceBuffer
    sta spsPointer
    lda #>pieceBuffer
    sta spsPointer+1
    ldy #0
@fillLoop:
    jsr pickTetriminoSeed
    sta (spsPointer),y
    inc spsPointer
    bne @fillLoop
; reset pointer
    lda #<pieceBuffer
    sta spsPointer
    bne chooseNextTetriminoAfterInit ; unconditional

normalRng:
    jmp chooseNextTetriminoOld

chooseNextTetrimino:
    lda practiseType
    cmp #MODE_SEED
    bne normalRng
    ldy #0
chooseNextTetriminoAfterInit:
    lda (spsPointer),y
    pha
    jsr pickTetriminoSeed
    sta (spsPointer),y
    inc spsPointer
    bne @noReset
    lda #<pieceBuffer
    sta spsPointer
@noReset:
    lda spsPointer
    pha
    ldx #0
    stx droughtTens
@droughtCount:
    lda (spsPointer),y
    cmp #$12
    beq @barFound
    inx
    inc spsPointer
    bne @droughtCount
    lda #<pieceBuffer
    sta spsPointer
    bne @droughtCount ; unconditional
@barFound:
    txa
@compareLoop:
    cmp #$0A
    bcc @storeOnes
    inc droughtTens
    sbc #$0A ; carry is set
    bcs @compareLoop ; unconditional
@storeOnes:
    sta droughtOnes
    pla
    sta spsPointer
    pla
    rts

stageSpriteForNextPiece:
    lda practiseType
    cmp #MODE_SEED
    bne @ret
    ; y
    lda #$C8
    sta oamStaging+248
    sta oamStaging+252
    ; t
    lda droughtTens
    bne @store
    lda #$FF ; no leading zero
@store:
    sta oamStaging+249
    lda droughtOnes
    sta oamStaging+253
    ; a
    lda #$03
    sta oamStaging+250
    sta oamStaging+254
    ; x
    lda #$20
    sta oamStaging+251
    lda #$28
    sta oamStaging+255
@ret:
    jmp stageSpriteForNextPieceOld
