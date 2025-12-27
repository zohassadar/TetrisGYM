gameMode_gameTypeMenu:
.if NO_MENU
        inc gameMode
        rts
.endif
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

        jsr makeNotReady
        lda #0
        sta hideNextPiece
        lda #$1
        sta renderMode
gameTypeLoop:
        lda newlyPressedButtons_player1
        cmp #BUTTON_START
        bne @wait
        inc gameMode
        rts
@wait:
        jsr resetMenuRenderBuffer
        jsr updateAudioWaitForNmiAndResetOamStaging
        jmp gameTypeLoop


MENU_TITLE_PPU = $2108
MENU_ROW_PPU = $2124


resetMenuRenderBuffer:
    ; mathRAM is 18 bytes of unused zeropage
    ; first 12 bytes for pointers
    @stackRow = mathRAM
    @ppuRow = mathRAM+2
    @currentString = mathRAM+4

    ; last 6 bytes for single vars
    @wordIndex = mathRAM+10
    @counter = mathRAM+11

    lda #>stack
    sta @stackRow+1
    ldx #$00
    stx @wordIndex
    lda #>MENU_TITLE_PPU
    sta stack,x
    inx
    lda #<MENU_TITLE_PPU
    sta stack,x
    inx
    lda #>MENU_ROW_PPU
    sta @ppuRow+1
    lda #<MENU_ROW_PPU
    sta @ppuRow
    stx @stackRow
    jsr @draw16BlanksToStackPlusX
    jsr @drawWordToStackBuffer
    ldy #$8
@nextRow:
    clc
    lda @ppuRow
    adc #$40
    sta @ppuRow
    sta stack+1,x
    lda #$00
    adc @ppuRow+1
    sta @ppuRow+1
    sta stack,x
    inx
    inx
    stx @stackRow
    jsr @draw16BlanksToStackPlusX
    jsr @drawWordToStackBuffer
    dey
    bne @nextRow
    rts

@draw16BlanksToStackPlusX:
    lda #$10
    sta @counter
    lda #$FF
@nextTile:
    sta stack,x
    inx
    dec @counter
    bne @nextTile
    rts

@drawWordToStackBuffer:
    txa
    pha
    tya
    pha
    ldy #$00

    ldx @wordIndex
    inc @wordIndex
    lda wordListLo,x
    sta @currentString
    lda wordListHi,x
    sta @currentString+1

; store length then bump pointer so y can start loop at 0
    lda (@currentString),y
    and #$0F
    tax
    inc @currentString
    bne @copy
    inc @currentString+1
@copy:
    lda (@currentString),y
    sta (@stackRow),y
    iny
    dex
    bne @copy
    pla
    tay
    pla
    tax
    rts

render_mode_menu:
    tsx
    txa
    ldx #$ff
    txs
    tax
    ldy #$9
@nextRow:
    pla
    sta PPUADDR
    pla
    sta PPUADDR
    .repeat 16
    pla
    sta PPUDATA
    .endrepeat
    dey
    bne @nextRow
    txs
    rts


wordListHi:
    .byte >stringStrict
    .byte >stringConfetti
    .byte >stringLetters
    .byte >stringOff
    .byte >stringConfirm
    .byte >stringShown
    .byte >stringClassic
    .byte >stringOff
    .byte >stringTeal

wordListLo:
    .byte <stringStrict
    .byte <stringConfetti
    .byte <stringLetters
    .byte <stringOff
    .byte <stringConfirm
    .byte <stringShown
    .byte <stringClassic
    .byte <stringOff
    .byte <stringTeal
