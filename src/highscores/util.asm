resetScores:
        ldx #highScoreLength * highScoreQuantity - 1
        lda #$0
@initHighScoreTable:
        sta highscores,x
        dex
        bpl @initHighScoreTable
@continue:
        rts


resetMenuVars:
        ldx #sramVariableLength -1
        lda #$0
@loop:
        sta menuVars,x
        dex
        bpl @loop

        lda #$FF
        sta paceModifier
        sta floorModifier

        lda #NTSC_DAS
        sta dasModifier
        lda #NTSC_ARR
        sta arrModifier

        lda #MODE_TETRIS
        sta practiseType

        lda #INITIAL_LINECAP_LEVEL
        sta linecapLevel
        lda #INITIAL_LINECAP_LINES_LO
        sta linecapLines+1
        lda #INITIAL_LINECAP_LINES_HI
        sta linecapLines

        rts


.if SAVE_HIGHSCORES
detectSRAM:
        lda #HIGH_SCORE_MAGIC0
        sta SRAM_hsMagic
        lda #HIGH_SCORE_MAGIC1
        sta SRAM_hsMagic+1
        lda SRAM_hsMagic
        cmp #HIGH_SCORE_MAGIC0
        bne @noSRAM
        lda SRAM_hsMagic+1
        cmp #HIGH_SCORE_MAGIC1
        bne @noSRAM
        lda #1
        rts
@noSRAM:
        lda #0
        rts

checkSavedInit:
        lda SRAM_hsMagic+2
        cmp #HIGH_SCORE_MAGIC2
        bne resetSavedScores
        lda SRAM_hsMagic+3
        cmp #HIGH_SCORE_MAGIC3
        bne resetSavedScores
        rts

resetSavedScores:
        lda #HIGH_SCORE_MAGIC2
        sta SRAM_hsMagic+2
        lda #HIGH_SCORE_MAGIC3
        sta SRAM_hsMagic+3

        ldx #highScoreLength * highScoreQuantity - 1
        lda #$0
@copyLoop:
        sta SRAM_highscores,x
        dex
        bpl @copyLoop

; copy variables


resetSavedVars:
        jsr resetMenuVars
copyVarsToSram:
        ldx #sramVariableLength - 1
@varsLoop:
        lda menuVars,x
        sta SRAM_variables,x
        dex
        bpl @varsLoop
@continue:
        rts


copyScoresFromSRAM:
        ldx #highScoreLength * highScoreQuantity - 1
@copyLoop:
        lda SRAM_highscores,x
        sta highscores,x
        dex
        bpl @copyLoop
@continue:
        rts

copyScoresToSRAM:
        ldx #highScoreLength * highScoreQuantity - 1
@copyLoop:
        lda highscores,x
        sta SRAM_highscores,x
        dex
        bpl @copyLoop
@continue:
        rts

copyVarsFromSRAM:
        ldx #sramVariableLength - 1
@copyLoop:
        lda SRAM_variables,x
        sta menuVars,x
        dex
        bpl @copyLoop
@continue:
        rts

.endif
