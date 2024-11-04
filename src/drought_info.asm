pieceBufferOffset = pieceBuffer - <pieceBuffer

.macro resetSpsPointer
    ldy #<pieceBuffer
.endmacro

initDroughtInfoAndChooseNext:
    lda practiseType
    cmp #MODE_SEED
    bne normalRng
    resetSpsPointer
@fillLoop:
    jsr pickTetriminoSeed
    sta pieceBufferOffset,y
    iny
    bne @fillLoop
; reset pointer
    resetSpsPointer
    bne chooseNextTetriminoAfterInit ; unconditional

normalRng:
    jmp chooseNextTetriminoOld

chooseNextTetrimino:
    lda practiseType
    cmp #MODE_SEED
    bne normalRng
    ldy spsPointer
chooseNextTetriminoAfterInit:
    lda pieceBufferOffset,y
    pha
    jsr pickTetriminoSeed
    sta pieceBufferOffset,y
    iny
    bne @noReset
    resetSpsPointer
@noReset:
    sty spsPointer
    ldx #0
    stx droughtTens
@droughtCount:
    lda pieceBufferOffset,y
    cmp #$12
    beq @barFound
    inx
    iny
    bne @droughtCount
    resetSpsPointer
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
