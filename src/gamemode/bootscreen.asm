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

.if KEYBOARD = 1
        jsr detectKeyboard
.endif

        lda qualFlag
        bne @qualBoot
        ; hold select to start in qual mode
        lda heldButtons_player1
        and #BUTTON_SELECT
        beq @nonQualBoot
@qualBoot:
        lda #1
        sta gameMode
        sta qualFlag
        jmp gameMode_waitScreen

@nonQualBoot:
        ; set start level to 8/18
        lda #$8
        sta classicLevel
        lda #2
        sta gameMode
        jmp gameMode_waitScreen
