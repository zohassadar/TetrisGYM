gameMode_bootScreen: ; boot
        ; ABSS goes to gameTypeMenu instead of here

        ; reset cursors
        lda #MODE_TETRIS
        sta practiseType

        ; levelMenu stuff
        lda #0
        sta levelControlMode

        ; detect region
        jsr updateAudioAndWaitForNmi
        jsr checkRegion

        lda #1
        sta gameMode
.if KEYBOARD = 1
        jsr detectKeyboard
.endif
        ldy #0
        lda qualFlag
        bne @qualBoot
;nonQual
        ldy #$8
@qualBoot:
        sty classicLevel
        jmp gameMode_waitScreen
