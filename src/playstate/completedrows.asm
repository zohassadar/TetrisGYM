playState_checkForCompletedRows:
        lda vramRow
        cmp #$20
        bpl @updatePlayfieldComplete
        jmp playState_checkForCompletedRows_return

@updatePlayfieldComplete:
        ldx practiseType
        lda tetriminoY
        and maskValueForTetriminoY,x
        clc
        adc lineIndex
        tay
        lda (multTableLo),y
        sta sramPlayfield
        clc
        lda #>SRAM_clearbuffer
        sta sramPlayfield+1


        lda xLimits,x
        tax

@checkIfRowComplete:
.if AUTO_WIN
        jmp @rowIsComplete
.endif
        ldy #$00
@checkIfRowCompleteLoopStart:
        lda (sramPlayfield),y
        cmp #EMPTY_TILE
        beq @rowNotComplete
        iny
        dex
        bne @checkIfRowCompleteLoopStart

@rowIsComplete:
        inc completedLines
        inc rowTop
        ldx lineIndex
        inc completedRow,x

        lda #$13
        sta currentPiece
        jmp @incrementLineIndex

@rowNotComplete:
        inc incompleteRows
        ldx practiseType
        ldy xLimits,x
        dey

@copyRowToIncompletes:
        lda (sramPlayfield),y
        sta (incompletes),y
        dey
        bpl @copyRowToIncompletes
        clc
        lda xLimits,x
        adc incompletes
        sta incompletes
        lda #$00
        adc incompletes+1
        sta incompletes+1
@incrementLineIndex:
        lda completedLines
        beq :+
        lda #$0A
        sta soundEffectSlot1Init
:
        inc lineIndex
        lda lineIndex
        cmp #$04 ; check actual height
        bmi playState_checkForCompletedRows_return

        ; todo Fix this!!
        lda incompleteRows
        beq @resetVars
        lda completedLines
        beq @resetVars
        
        ldy rowTop
        lda (multTableLo),y
        sta sramPlayfield
        clc
        lda #>SRAM_playfield
        adc (multTableHi),y
        sta sramPlayfield+1

        ldy incompleteRows
        lda (multTableLo),y
        tay
        dey
@incompleteRowLoop:
        lda SRAM_incompletes,y
        sta (sramPlayfield),y
        dey
        bpl @incompleteRowLoop

@resetVars:
        lda #$00
        sta vramRow
        sta rowY
        jsr updateLineClearingAnimation
        lda completedLines
        cmp #$04
        bne @skipTetrisSoundEffect
        lda #$04
        sta soundEffectSlot1Init
@skipTetrisSoundEffect:
        inc playState
        lda completedLines
        bne playState_checkForCompletedRows_return
@skipLines:
playState_completeRowContinue:
        inc playState
        lda #$07
        sta soundEffectSlot1Init
playState_checkForCompletedRows_return:
        rts




playstate_shiftPlayfieldDownABit:
        lda rowTop
        beq @ret
        ; todo Fix this!!
        ldy rowBeingMoved
@incomplete:
        lda (multTableLo),y
        sta sramPlayfield
        clc
        lda #>SRAM_playfield
        adc (multTableHi),y
        sta sramPlayfield+1

        ldy rowTop
        dey
        lda (multTableLo),y
        sta sramPlayfieldBR
        clc
        lda #>SRAM_playfield
        adc (multTableHi),y
        sta sramPlayfieldBR+1
        ldx practiseType
        ldy xLimits,x
        dey
@shiftLoop:
        lda (sramPlayfield),y
        sta (sramPlayfieldBR),y
        dey
        bpl @shiftLoop
        dec rowBeingMoved
        bpl @noReset
        inc rowBeingMoved
@noReset:
        dec rowTop
        bne @ret
        lda #$00
        sta vramRow
@ret:   jmp updateLineClearingAnimation

