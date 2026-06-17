.macro stagePatchInQueue patchAddr
; can be made subroutine if needed to save space
        lda #<patchAddr
        sta patchPtr
        lda #>patchAddr
        sta patchPtr+1
        jsr copyPatchAtPointerToQueue
        lda renderMode
        pha
        lda #RENDER_QUEUE
        sta renderMode
        jsr waitForNmi
        pla
        sta renderMode
.endmacro

gameMode_waitScreen:
        lda #0
        sta screenStage
        lda #NMIEnable
        sta currentPpuCtrl
        lda #RENDER_IDLE
        sta renderMode
        jsr resetRenderQueue
        jsr hideSpritesAndBackground
.if INES_MAPPER <> 0
; NROM (and possibly FDS in the future) won't load the 2nd bankset
; and will instead use the title/menu chrset letters.  This won't be noticeable
; unless a graphic is added
        lda #CHRBankSet1
        jsr changeCHRBanks
.endif
        stagePatchInQueue waitPalettePatch
        jsr copyRleNametableToPpu
        .addr legal_nametable
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
        lda newlyPressedButtons_player1
        and #BUTTON_START
        bne @exitLoop
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
        stagePatchInQueue titleNametablePatch
        jmp waitLoopCheckStart
waitLoopContinue:
        stx soundEffectSlot1Init
        inc gameMode
        rts
