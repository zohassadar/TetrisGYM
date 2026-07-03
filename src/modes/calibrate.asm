advanceGameCalibrate:
    lda heldButtons_player1
    cmp #BUTTON_A+BUTTON_B+BUTTON_SELECT+BUTTON_START
    bne @noReset
    lda #GAMEMODE_GAMETYPEMENU
    sta gameMode
    rts
@noReset:
    lda newlyPressedButtons_player1
    and #BUTTON_A|BUTTON_B
    beq @noToggle
    lda tetriminoY
    eor #1
    sta tetriminoY
    jmp refreshPattern
@noToggle:
    @fillModifier = anydasFlag  ; placeholder
    lda newlyPressedButtons_player1
    and #BUTTON_UP|BUTTON_DOWN
    beq @upNotPressed
    inc @fillModifier
    lda @fillModifier
    and #3
    sta @fillModifier
    jmp refreshPattern
@upNotPressed:
    lda newlyPressedButtons_player1
    and #BUTTON_START
    beq @startNotPressed
    lda fallTimer
    eor #1
    sta fallTimer
    bne calibrateWaitLoop
    jmp refreshPattern
@startNotPressed:
    lda #BUTTON_SELECT
    jsr menuThrottle
    beq @selectNotPressed
    lda nextPiece
    sta currentPiece
    jsr incrementPieceStat
    inc tetriminoX
    lda tetriminoX
    cmp #7
    bne @noRollover
    lda #0
    sta tetriminoX
@noRollover:
    tax
    lda spawnTable,x
    sta nextPiece
    jmp calibrateWaitLoop

@selectNotPressed:
    lda newlyPressedButtons_player1
    and #3
    beq calibrateCheckFrameCounter
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

calibrateWaitLoop:
    jsr stageSpriteForNextPiece
    jsr updateAudioWaitForNmiAndResetOamStaging
    jmp advanceGameCalibrate

; shuffle every 128 frames
calibrateCheckFrameCounter:
    lda fallTimer
    bne calibrateWaitLoop
    lda frameCounter
    and #$7F
    beq refreshPattern
    jmp calibrateWaitLoop

gameMode_calibrate:
    jsr gameModeState_initGameBackground
    jsr gameModeState_initGameState
    ldx nextPiece
    stx currentPiece
    lda tetriminoTypeFromOrientation,x
    sta tetriminoX

refreshPattern:
    @fillModifier = anydasFlag
    lda #0
    sta vramRow
    lda tetriminoY
    bne @tilefill
    ldy #15
@fill:
    ldx #b_seed
    jsr generateNextPseudorandomNumber5x
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
    jmp calibrateWaitLoop

@tilefill:
    ldx #200
    lda @fillModifier
    beq @empty
    lda #$7A
    clc
    adc @fillModifier
    bne @tile
@empty:
    lda #EMPTY_TILE
@tile:
    sta playfield-1,x
    dex
    bne @tile
    jmp calibrateWaitLoop

.out .sprintf("Calibrate code: %d", *-advanceGameCalibrate)
