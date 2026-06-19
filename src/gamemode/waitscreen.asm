gameMode_waitScreen:
        lda #0
        sta screenStage
        jsr hideSpritesAndBackground
.if INES_MAPPER <> 0
; NROM (and possibly FDS in the future) won't load the 2nd bankset
; and will instead use the title/menu chrset letters.  This won't be noticeable
; unless a graphic is added
        lda #CHRBankSet1
        jsr changeCHRBanks
.endif
        stagePatchThenWaitForNmi waitPalettePatch

        ldx #RLE_NT_LEGAL
        jsr copyRleNametableToPpu

; reenable display
        jsr resetScroll
        lda #NMIEnable
        sta currentPpuCtrl
        lda #RENDER_IDLE
        sta renderMode
        jsr showSpriteAndBackground

        cmp #2
        beq waitLoopCheckStart
        lda #$FF
        ldx palFlag
        ; cpx #0 ; ldx sets z flag
        beq @notPAL
        lda #$CC
@notPAL:
        sta sleepCounter
@loop:
        ; if second wait, skip render loop
        lda screenStage
        cmp #1
        beq waitLoopCheckStart

        jsr updateAudioWaitForNmiAndResetOamStaging
        lda #$1A
        sta spriteXOffset
        lda #$20
        sta spriteYOffset
        lda #sleepCounter
        sta byteSpriteAddr
        lda #0
        sta byteSpriteAddr+1
        sta byteSpriteTile
        lda #1
        sta byteSpriteLen
        jsr byteSprite

        lda qualFlag
        beq @checkStart
        jsr showQualWait
        jmp @checkSleepCounter
@checkStart:
        lda newlyPressedButtons_player1
        and #BUTTON_START
        bne @exitLoop
@checkSleepCounter:
        lda sleepCounter
        bne @loop
@exitLoop:
        inc screenStage

waitLoopCheckStart:
        lda screenStage
        cmp #1
        bne @title
        lda sleepCounter
        beq waitLoopNext
@title:
        lda newlyPressedButtons_player1
        cmp #BUTTON_START
        beq waitLoopNext
        jsr updateAudioWaitForNmiAndResetOamStaging
        jmp waitLoopCheckStart
waitLoopNext:
        ldx #$02
        lda screenStage
        cmp #2
        beq waitLoopContinue
        stx soundEffectSlot1Init
        inc screenStage
        stagePatchThenWaitForNmi titleNametablePatch
        jmp waitLoopCheckStart
waitLoopContinue:
        stx soundEffectSlot1Init
        inc gameMode
        rts

showQualWait:
        lda heldButtons_player1
        and #BUTTON_START
        beq @ret

        lda #$70
        sta spriteXOffset
        lda #$80
        sta spriteYOffset
        lda #$01
        sta stringAttrib
        ldx #>STR_WAIT
        ldy #<STR_WAIT
        jsr stringSpriteXY
        dec stringAttrib
@ret:
        rts
