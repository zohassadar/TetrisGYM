resetScores:
        ldx #$0
        lda #$0
@initHighScoreTable:
        cpx #highScoreLength * highScoreQuantity
        beq @continue
        sta highscores,x
        inx
        jmp @initHighScoreTable
@continue:
        rts


resetMenuVars:
        ldx #sramVariableLength -1
        lda #$0
@loop:
        sta menuVars,x
        dex
        bpl @loop
        rts


.if SAVE_HIGHSCORES
detectSRAM:
        lda #$37
        sta SRAM_hsMagic
        lda #$64
        sta SRAM_hsMagic+1
        lda SRAM_hsMagic
        cmp #$37
        bne @noSRAM
        lda SRAM_hsMagic+1
        cmp #$64
        bne @noSRAM
        lda #1
        rts
@noSRAM:
        lda #0
        rts

checkSavedInit:
        lda SRAM_hsMagic+2
        cmp #$4B
        bne resetSavedScores
        lda SRAM_hsMagic+3
        cmp #$D2
        bne resetSavedScores
        rts

resetSavedScores:
        lda #$4B
        sta SRAM_hsMagic+2
        lda #$D2
        sta SRAM_hsMagic+3

        ldx #$0
        lda #$0
@copyLoop:
        cpx #highScoreLength * highScoreQuantity
        beq @continue
        sta SRAM_highscores,x
        inx
        jmp @copyLoop
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

copyVarsToSRAM:
        ldx #sramVariableLength - 1
@copyLoop:
        lda menuVars,x
        sta SRAM_variables,x
        dex
        bpl @copyLoop
@continue:
        rts
.endif
