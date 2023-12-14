playState_lockTetrimino:
        jsr isPositionValid
        bcc @notGameOver
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
        ldy currentPiece
        sty currentPiece_copy ; this will conflict with floor mode mod
        lda orientationTiles,y
        sta generalCounter5
        tya
        asl a
        asl a
        tax
        lda #$04
        sta lineIndex ; conveniently leaves lineIndex 0 at return
; Copies a single square of the tetrimino to the playfield
@lockSquare:
        lda orientationYOffsets,x
        clc
        adc #$02
        clc
        adc tetriminoY
        tay

        lda orientationXOffsets,x
        clc
        adc tetriminoX
        clc
        adc multBy10OffsetBy2,y
        tay

        lda generalCounter5
        ; BLOCK_TILES
        sta playfield,y

        inx
        dec lineIndex
        bne @lockSquare
        jsr updatePlayfield
        jsr updateMusicSpeed
        inc playState
@ret:   rts
