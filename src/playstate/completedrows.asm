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
;         lda practiseType
;         cmp #MODE_TSPINS
;         beq @rowNotComplete

;         lda practiseType
;         cmp #MODE_FLOOR
;         beq @floorCheck
;         lda linecapState
;         cmp #LINECAP_FLOOR
;         beq @fullRowBurningCheck
;         bne @normalRow

; @floorCheck:
;         lda floorModifier
;         beq @rowNotComplete

; @fullRowBurningCheck:
;         ; bugfix to ensure complete rows aren't cleared
;         ; used in floor / linecap floor
;         lda currentPiece_copy
;         beq @IJLTedge
;         cmp #5
;         beq @IJLTedge
;         cmp #$10
;         beq @IJLTedge
;         cmp #$12
;         beq @IJLTedge
;         bne @normalRow
; @IJLTedge:
;         lda lineIndex
;         cmp #3
;         bcs @rowNotComplete
; @normalRow:

        ldy #$00
@checkIfRowCompleteLoopStart:
        lda (sramPlayfield),y
        cmp #EMPTY_TILE
        beq @rowNotComplete
        iny
        dex
        bne @checkIfRowCompleteLoopStart

@rowIsComplete:
        ; sound effect $A to slot 1 used to live here
        inc completedLines
        ldx lineIndex
        inc completedRow,x
;         ldy generalCounter
;         dey
; @movePlayfieldDownOneRow:
;         lda (playfieldAddr),y
;         ldx #$0A
;         stx playfieldAddr
;         sta (playfieldAddr),y
;         lda #$00
;         sta playfieldAddr
;         dey
;         cpy #$FF
;         bne @movePlayfieldDownOneRow
;         lda #EMPTY_TILE
;         ldy #$00
; @clearRowTopRow:
;         sta (playfieldAddr),y
;         iny
;         cpy #$0A
;         bne @clearRowTopRow
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

        lda incompleteRows
        beq @noIncompletesToMove
        lda completedLines
        beq @noIncompletesToMove

        lda tetriminoY
        cmp #$02
        bcs @yInRange
        lda #$02
@yInRange:
        sec
        sbc #$02
        clc
        adc completedLines
        tay
        dey
        sty rowBeingMoved
        iny
        lda (multTableLo),y
        sta sramPlayfield
        clc
        lda #>SRAM_playfield
        adc (multTableHi),y
        sta sramPlayfield+1

        ldy incompleteRows
        iny
        lda (multTableLo),y
        tay
        dey
@incompleteRowLoop:
        lda SRAM_incompletes,y
        sta (sramPlayfield),y
        dey
        bpl @incompleteRowLoop

@noIncompletesToMove:
        lda #$00
        sta vramRow
        sta rowY
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
        lda rowBeingMoved
        bne @incomplete
        inc playState
        rts
@incomplete:
        clc
        adc completedLines
        tay
        lda (multTableLo),y
        sta sramPlayfieldBR
        clc
        lda #>SRAM_playfield
        adc (multTableHi),y
        sta sramPlayfieldBR+1

        ldy rowBeingMoved
        lda (multTableLo),y
        sta sramPlayfield
        clc
        lda #>SRAM_playfield
        adc (multTableHi),y
        sta sramPlayfield+1

        ldx practiseType
        ldy xLimits,x
        dey
@shiftLoop:
        lda (sramPlayfield),y
        sta (sramPlayfieldBR),y
        dey
        bpl @shiftLoop
        dec rowBeingMoved
        rts
