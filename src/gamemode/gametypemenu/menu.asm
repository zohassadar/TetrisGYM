gameMode_gameTypeMenu:
.if NO_MENU
        inc gameMode
        rts
.endif
        jsr makeNotReady
        lda #0
        sta hideNextPiece
        lda #$1
        sta renderMode
        jsr updateAudioWaitForNmiAndDisablePpuRendering
        jsr disableNmi
        jsr bulkCopyToPpu
        .addr   title_palette
        jsr copyRleNametableToPpu
        .addr   game_type_menu_nametable
.if INES_MAPPER <> 0
        lda #CHRBankSet0
        jsr changeCHRBanks
.endif
        lda #NMIEnable
        sta currentPpuCtrl
        jsr waitForVBlankAndEnableNmi
        jsr updateAudioWaitForNmiAndResetOamStaging
        jsr updateAudioWaitForNmiAndEnablePpuRendering
        jsr updateAudioWaitForNmiAndResetOamStaging

gameTypeLoop:
        lda newlyPressedButtons_player1
        cmp #BUTTON_START
        bne @wait
        inc gameMode
        rts
@wait:
        jsr updateAudioWaitForNmiAndResetOamStaging
        jmp gameTypeLoop
