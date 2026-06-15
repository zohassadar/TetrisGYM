stageDasMeterSprites:
@dasValue = generalCounter
@tile = generalCounter2
@redCompare = generalCounter3
@orangeCompare = generalCounter4
@dasMax = generalCounter5
@halfTile = tmpX
    lda #0
    sta @halfTile
@yCoordinate = 211
@xStart = 103
    lda dasMeterFlag
    beq @noMeter
    lda playState
    bne @meter
@noMeter:
    rts
@meter:
    lda autorepeatX
    bpl @notNegative
    lda #0
@notNegative:
    sta @dasValue

    lda dasModifier
    sta @dasMax

    cmp #17
    bcc @setCompare

; half values for 17 or more (max 30 currently)
    lsr @dasMax
    lsr @dasValue

@setCompare:
    lda @dasMax
    lsr
    lsr
    sta @orangeCompare
    inc @orangeCompare ; 5 when ntsc vanilla
    lsr
    sta @redCompare
    inc @redCompare ; 3 when ntsc vanilla

    lda #$FE
    sta @tile
    lda @dasValue
    lsr
    sta @dasValue
    rol @halfTile
    cmp @orangeCompare
    bcs @stageSprites
    dec @tile
    cmp @redCompare
    bcs @stageSprites
    dec @tile
@stageSprites:
    ldx oamStagingLength
    ldy #@xStart
    lda @dasValue
    beq @drawHalfTile
    cmp #9
    bcc @loop
    lda #8
    sta @dasValue
@loop:
    lda @tile
    sta oamStaging+1,x
    tya
    sta oamStaging+3,x
    lda #@yCoordinate
    sta oamStaging+0,x
    lda #3
    sta oamStaging+2,x
    inx
    inx
    inx
    inx
    tya
    clc
    adc #8
    tay
    dec @dasValue
    stx oamStagingLength
    bne @loop

; check to see if carry was set for half width tile
    lda @halfTile
    beq @ret
@drawHalfTile:
    lda @tile
    sec
    sbc #32
    sta oamStaging+1,x
    tya
    sta oamStaging+3,x
    lda #3
    sta oamStaging+2,x
    lda #@yCoordinate
    sta oamStaging+0,x
    inx
    inx
    inx
    inx
    stx oamStagingLength
@ret:
    rts

; render_mode_play_and_demo_then_dasmeter:
;     lda #$23
;     sta PPUADDR
;     lda #$89
;     sta PPUADDR
;     ldx autorepeatX
;     beq @ret
;     lda dasMeterTile
; @drawDas:
;     sta PPUDATA
;     dex
;     bne @drawDas
;     ldx dasValue
;     beq @ret
;     lda #$FF
; @drawNonDas:
;     sta PPUDATA
;     dex
;     bne @drawNonDas
; @ret:
;     jsr render_mode_play_and_demo
;     rts
