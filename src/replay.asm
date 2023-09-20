


restorePauseFunction:
    lda playState
    cmp #$04
    beq @ret

    lda backupSlot
    sta startingSlot

    lda newlyPressedButtons_player1
    and #BUTTON_LEFT
    beq @leftNotPressed
    dec backupSlot
    jmp @restore

@leftNotPressed:
    lda newlyPressedButtons_player1
    and #BUTTON_RIGHT
    beq @ret
    inc backupSlot

@restore:
    jsr restorePlayfield
    bcc @invalidField

    lda #$00
    sta vramRow
    lda #%00100111
    sta outOfDateRenderFlags
@ret:
    rts

@invalidField:
    lda startingSlot
    sta backupSlot
    rts



loadPlayfield:
    ; load appropriate bank
    lda backupSlot
    and #$60
    lsr
    lsr
    lsr
    lsr
    lsr
    ora #$04
    sta MMC5_RAM_BANK

    ; load appropriate address
    lda backupSlot
    and #$1F
    clc
    adc #$60
    sta replayAddress+1

    rts






restorePlayfield:
    jsr loadPlayfield
    ; backup playfield
    ldy #$00
    sty replayAddress
    lda (replayAddress),y
    bne @copyPlayfield
    clc
    rts 

@copyPlayfield:
    lda (replayAddress),y
    sta playfield,y
    iny
    cpy #$c8
    bne @copyPlayfield
    

    lda (replayAddress),y
    sta currentPiece
    iny

    lda (replayAddress),y
    sta nextPiece
    iny

    lda (replayAddress),y
    sta autorepeatX
    iny

    lda (replayAddress),y
    sta tetriminoX
    iny

    lda (replayAddress),y
    sta tetriminoY
    iny

    lda (replayAddress),y
    sta binScore
    iny

    lda (replayAddress),y
    sta binScore+1
    iny

    lda (replayAddress),y
    sta binScore+2
    iny

    lda (replayAddress),y
    sta binScore+3
    iny

    lda (replayAddress),y
    sta lines
    iny 

    lda (replayAddress),y
    sta lines+1
    iny 

    lda (replayAddress),y
    sta levelNumber
    iny

    lda (replayAddress),y
    sta set_seed
    iny

    lda (replayAddress),y
    sta set_seed+1
    iny

    lda (replayAddress),y
    sta set_seed+2
    iny


    ldx #$0
@statsLoop:
    lda (replayAddress),y
    sta statsByType,x
    iny
    inx
    cpx #$0e
    bne @statsLoop

    lda #$02
    sta playState


    lda #$00
    sta MMC5_RAM_BANK

    sec
    rts




storePlayfield:
    jsr loadPlayfield

    ; backup playfield
    ldy #$00
    sty replayAddress
@copyPlayfield:
    lda playfield,y
    sta (replayAddress),y
    iny
    cpy #$c8
    bne @copyPlayfield

    lda currentPiece
    sta (replayAddress),y
    iny

    lda nextPiece
    sta (replayAddress),y
    iny

    lda autorepeatX
    sta (replayAddress),y
    iny

    lda tetriminoX
    sta (replayAddress),y
    iny

    lda tetriminoY
    sta (replayAddress),y
    iny

    lda binScore
    sta (replayAddress),y
    iny

    lda binScore+1
    sta (replayAddress),y
    iny

    lda binScore+2
    sta (replayAddress),y
    iny

    lda binScore+3
    sta (replayAddress),y
    iny

    lda lines
    sta (replayAddress),y
    iny 

    lda lines+1
    sta (replayAddress),y
    iny 

    lda levelNumber
    sta (replayAddress),y
    iny

    lda set_seed
    sta (replayAddress),y
    iny

    lda set_seed+1
    sta (replayAddress),y
    iny

    lda set_seed+2
    sta (replayAddress),y
    iny

    ldx #$0
@statsLoop:
    lda statsByType,x
    sta (replayAddress),y
    iny
    inx
    cpx #$0e
    bne @statsLoop

    ; increment counter
    inc backupSlot

    lda #$00
    sta MMC5_RAM_BANK
    
    rts
