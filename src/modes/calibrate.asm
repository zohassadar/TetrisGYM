advanceGameCalibrate:
    lda practiseType
    cmp #MODE_CALIBRATE
    beq @calibrate
    rts
@leftRightAdjust:
    .byte $0,$1,$FF,$1
@calibrate:
    lda newlyPressedButtons_player1
    and #3
    beq @checkFrameCounter
    tax
    lda levelNumber
    clc
    adc @leftRightAdjust,x
    sta levelNumber
    bmi @resetTo9
    cmp #10
    bcc @renderLevel
    lda #0
    sta levelNumber
    beq @renderLevel
@resetTo9:
    lda #9
    sta levelNumber
@renderLevel:
    lda levelNumber
    sta lines+1
    asl
    asl
    asl
    asl
    ora levelNumber
    sta lines
    sta bcd32
    sta bcd32+1
    sta bcd32+2
    jsr presetScoreFromBCD
    lda #RENDER_LINES|RENDER_LEVEL|RENDER_SCORE
    sta renderFlags
    rts
@checkFrameCounter:
    lda frameCounter
    and #$7F
    beq initializeGameCalibrate
    rts
initializeGameCalibrate:
    lda #15
    sta generalCounter
@fill:
    ldx #b_seed
    jsr generateNextPseudorandomNumber2x
    ldx #rng_seed
    jsr generateNextPseudorandomNumber3x
    ldy oneThirdPRNG
    lda @tiles,y
    ldx generalCounter
    sta mathRAM,x
    dec generalCounter
    bpl @fill

    lda rng_seed+1
    and #7
    tax
    lda #$EF
    sta mathRAM,x
    sta mathRAM+8,x

    ldy #200
    lda rng_seed
    and #15
    tax
@loop:
    lda mathRAM,x
    sta playfield-1,y
    dex
    bpl :+
    ldx #15
:
    dey
    bne @loop
    lda #0
    sta vramRow
    rts

@tiles:
   .byte $7B,$7C,$7D


.out .sprintf("Calibrate code: %d", *-advanceGameCalibrate)
