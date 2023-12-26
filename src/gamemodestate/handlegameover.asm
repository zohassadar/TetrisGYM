gameModeState_handleGameOver:
.if AUTO_WIN
        lda newlyPressedButtons_player1
        and #BUTTON_SELECT
        bne @gameOver
.endif
        lda #$05
        sta generalCounter2
        lda playState
        cmp #$00
        beq @gameOver
        jmp @ret
@gameOver:
        lda #$03
        sta renderMode
.if INES_MAPPER = 3
        lda qualFlag
        beq @CNROM_CHR_HIGHSCORE_END
@CNROM_CHR_HIGHSCORE:
        lda #1
        sta @CNROM_CHR_HIGHSCORE+1
@CNROM_CHR_HIGHSCORE_END:
.endif
        jsr handleHighScoreIfNecessary
        lda #$01
        sta playState
        jsr resetPlayfields
        lda #$00
        sta vramRow
        lda #$01
        sta playState
        jsr updateAudioWaitForNmiAndResetOamStaging
        ldx #3 ; levelMenu
        lda practiseType
        cmp #MODE_KILLX2
        bne @notGameTypeMenu
        dex
@notGameTypeMenu:
        stx gameMode
        rts

@ret:   inc gameModeState ; 4
        lda #$1 ; acc should not be equal (always $1 in original game)
        rts
