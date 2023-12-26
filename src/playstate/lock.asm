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
        adc tetriminoY
        cmp #$02
        bcc @skipLock ; don't lock above visible playfield to guarantee all blank tiles
        tay
        lda orientationXOffsets,x
        clc
        adc tetriminoX
        clc
        adc (multTableLo),y
        sta sramPlayfield
        lda #>SRAM_playfield
        adc (multTableHi),y
        sta sramPlayfield+1
        ldy #$00
        lda generalCounter5
        sta (sramPlayfield),y
@skipLock:
        inx
        dec lineIndex
        bne @lockSquare
        jsr updatePlayfield
        jsr copyPlayfieldToBuffer ; use a copy of the 4 rows for line clear checking
        lda #$00
        sta incompleteRows
        lda #<SRAM_incompletes
        sta incompletes
        lda #>SRAM_incompletes
        sta incompletes+1
        inc playState
@ret:   rts
