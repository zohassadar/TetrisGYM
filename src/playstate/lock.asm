playState_lockTetrimino:
        jsr isPositionValid
        beq @notGameOver
; gameOver:
        lda outOfDateRenderFlags ; Flag needed to reveal hidden score
        ora #$04
        sta outOfDateRenderFlags
        lda #$02
        sta soundEffectSlot0Init
        lda #$0A ; playState_checkStartGameOver
        sta playState
        lda #$F0
        sta curtainRow
        jsr updateAudio2

        ; reset checkerboard score
        lda practiseType
        cmp #MODE_CHECKERBOARD
        bne @noChecker
        lda #0
        sta binScore
        sta binScore+1
        jsr setupScoreForRender
@noChecker:
        ; make invisible tiles visible
        lda #$00
        sta invisibleFlag
        sta vramRow
        rts

@notGameOver:
        lda vramRow
        cmp #$20
        bmi @ret
        lda tetriminoY
        asl a
        sta generalCounter
        asl a
        asl a
        clc
        adc generalCounter
        adc tetriminoX
        sta generalCounter
        ldy currentPiece
        sty currentPiece_copy ; this will conflict with floor mode mod
        lda orientationTiles,y
        sta generalCounter5
        tya
        asl a
        asl a
        tax
        lda #$04
        sta generalCounter3
; Copies a single square of the tetrimino to the playfield
@lockSquare:
        lda orientationYOffsets,x
        asl a
        sta generalCounter4
        asl a
        asl a
        clc
        adc generalCounter4
        clc
        adc generalCounter
        sta positionValidTmp
        lda orientationXOffsets,x
        clc
        adc positionValidTmp
        tay
        lda generalCounter5
        ; BLOCK_TILES
        sta playfield,y
        inx
        dec generalCounter3
        bne @lockSquare
        lda #$00
        sta lineIndex
        jsr updatePlayfield
        jsr updateMusicSpeed
        inc playState
@ret:   rts
