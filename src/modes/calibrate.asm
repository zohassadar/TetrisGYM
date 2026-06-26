advanceGameCalibrate:
    lda practiseType
    cmp #MODE_CALIBRATE
    beq @calibrate
    rts

@calibrate:
    lda #$0
    sta generalCounter
    lda newlyPressedButtons_player1
    and #BUTTON_LEFT
    beq @leftNotPressed
    inc generalCounter
    dec levelNumber
    bpl @leftNotPressed
    lda #9
    sta levelNumber
@leftNotPressed:

    lda newlyPressedButtons_player1
    and #BUTTON_RIGHT
    beq @rightNotPressed
    inc generalCounter
    inc levelNumber
    lda levelNumber
    cmp #$0A
    bcc @rightNotPressed
    lda #0
    sta levelNumber
@rightNotPressed:

    lda generalCounter
    beq @checkFrameCounter

    lda levelNumber
    sta lines+1
    asl
    asl
    asl
    asl
    ora levelNumber
    sta lines
    sta score
    sta score+1
    sta score+2
    sta bcd32
    sta bcd32+1
    sta bcd32+2
    lda #0
    sta bcd32+3
    jsr BCD_BIN
    lda binary32
    sta binScore
    lda binary32+1
    sta binScore+1
    lda binary32+2
    sta binScore+2
    lda #RENDER_LINES|RENDER_LEVEL|RENDER_SCORE
    sta renderFlags
    rts
@checkFrameCounter:
    lda frameCounter
    and #$7F
    bne calibrateReturn
initializeGameCalibrate:
    lda frameCounter
    sta tmp1
    lda frameCounter+1
    sta tmp2
    ldy #6
@shift:
    lsr tmp2
    ror tmp1
    dey
    bpl @shift
    lda tmp1
    and #$E
    tay
    lda calibratePatterns,y
    sta tmp1
    lda calibratePatterns+1,y
    sta tmp2

    ldx #200
    lda rng_seed
    and #7
    tay
@loop:
    lda (tmp1),y
    sta playfield-1,x
    dey
    bpl :+
    ldy #7
:
    dex
    bne @loop

    lda #0
    sta vramRow
calibrateReturn:
    rts

calibratePatterns:
    .addr calibratePattern0
    .addr calibratePattern1
    .addr calibratePattern2
    .addr calibratePattern3
    .addr calibratePattern4
    .addr calibratePattern5
    .addr calibratePattern6
    .addr calibratePattern7

calibratePattern0:
   .byte $7D,$7D,$EF,$7D,$7D,$7C,$7D,$7D
calibratePattern1:
   .byte $7B,$7D,$7D,$EF,$7D,$7C,$7D,$7B
calibratePattern2:
   .byte $7D,$7D,$7C,$7B,$EF,$7B,$7C,$7B
calibratePattern3:
   .byte $7B,$7B,$7B,$7D,$7B,$EF,$7B,$7D
calibratePattern4:
   .byte $EF,$7D,$7D,$7C,$7D,$7C,$7B,$7B
calibratePattern5:
   .byte $7C,$EF,$7C,$7D,$7B,$7B,$7C,$7D
calibratePattern6:
   .byte $7D,$7B,$7B,$7C,$7C,$7C,$7D,$EF
calibratePattern7:
   .byte $7C,$7D,$7C,$7B,$7C,$7C,$EF,$7C
