advanceGameCalibrate:
    @fillModifier = anydasFlag  ; placeholder
    lda practiseType
    cmp #MODE_CALIBRATE
    beq @calibrate
    rts
@calibrate:
    lda newlyPressedButtons_player1
    and #BUTTON_UP|BUTTON_DOWN
    beq @upNotPressed
    inc @fillModifier
    lda @fillModifier
    and #3
    sta @fillModifier
    jmp initializeGameCalibrate
@upNotPressed:
    lda newlyPressedButtons_player1
    and #3
    beq @checkFrameCounter
    lsr
    bcs @rightPressed

; left pressed
    dec levelNumber
    bpl @renderLevel
    lda #9
    sta levelNumber
    bne @renderLevel

@rightPressed:
    inc levelNumber
    lda levelNumber
    cmp #$0A
    bcc @renderLevel
    lda #0
    sta levelNumber

@renderLevel:
    lda levelNumber

; optional 7 digit
    ldy scoringModifier
    cpy #2
    beq @sevenDigit
    lda #0
@sevenDigit:
    sta bcd32+3

; fill score & lines, render & exit
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

; shuffle every 128 frames
@checkFrameCounter:
    lda frameCounter
    and #$7F
    beq initializeGameCalibrate
    rts

initializeGameCalibrate:
    @fillModifier = anydasFlag
    lda #0
    sta vramRow
    lda @fillModifier
    bne @tilefill
    ldy #15
@fill:
    ldx #b_seed
    jsr generateNextPseudorandomNumber2x
    ldx #rng_seed
    jsr generateNextPseudorandomNumber3x
    lda oneThirdPRNG
    clc
    adc #$7B
    sta mathRAM,y
    dey
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
    rts

@tilefill:
    lda #$7B
    clc
    adc @fillModifier
    ldx #200
@tile:
    sta playfield-1,x
    dex
    bne @tile
    rts


.out .sprintf("Calibrate code: %d", *-advanceGameCalibrate)
