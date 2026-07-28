gameMode_legalScreen:
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

        lda #$FF
        ldx palFlag
        ; cpx #0 ; ldx sets z flag
        beq @notPAL
        lda #$CC
@notPAL:
        sta sleepCounter
@loop:
        jsr updateAudioWaitForNmiAndResetOamStaging
        lda screenStage
        bne @checkStart
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
        lda screenStage
        bne @exitLoop
        inc screenStage
        lda #$FF
        sta sleepCounter
        bne @loop
@exitLoop:
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
