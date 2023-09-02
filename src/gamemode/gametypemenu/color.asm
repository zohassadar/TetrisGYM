currentField := harddropBuffer 
colorPos := harddropBuffer+1
presetPos := harddropBuffer+2
currentLevel := harddropBuffer+3
currentIndex := harddropBuffer+4
renderToggle := harddropBuffer+5

colorTable := $7F00

levelX := $80
levelY := $80

presetYOffset := $3F
presetX := $55
presetTile := $D0
presetAttr :=  $02


presetText:
    .byte "DEFAULT   "
    ; .byte "PRIDE     "
    ; .byte "GRAY      "
    ; .byte "NOGLITCH  "
    ; .byte "GLITCH    "
    ; .byte "OTHER     "
    ; .byte "BLAH      "
    ; .byte "BLAH      "
endPresetText:


fieldSpriteAttrs:
    .byte $FF,$FF,$FF

colorCursorY := $14
colorCursorXOffset := $1C
colorTile := $D2
colorAttr := presetAttr


levelCursorY := $A7
levelCursorX := $BE
levelTile := $D0
levelAttr := presetAttr


; fields:

FIELD_COLOR := $00
FIELD_LEVEL := $01
FIELD_PRESETS := $02

.enum
PRESET_DEFAULTS
; PRESET_PRIDE
; PRESET_GRAY
; PRESET_NO_GLITCH
; PRESET_GLITCH
.endenum

MAX_PRESETS = PRESET_DEFAULTS+1


cursorY := oamStaging+16
cursorTile := oamStaging+17
cursorAttr := oamStaging+18
cursorX := oamStaging+19


; 0 - color
; 1 - level
; 2 - presets

; select, toggle through

; colorPos, left/right change, up/down alter
; color1
; color2
; color3

; level, up/down alter


; presetPos, up/down alter, a apply
; normal
; pride
; glitch
; noglitch
; gray


attr1 := $27D3
attr2 := $27DB

toggleModes:
    .byte $03,$09


render_mode_color_menu:
    ldx currentIndex
    lda #$20
    sta PPUADDR
    lda #$83
    sta PPUADDR
    lda colorTable+1,x
    jsr twoDigsToPPU
    lda colorTable+2,x
    jsr twoDigsToPPU
    lda colorTable+3,x
    jsr twoDigsToPPU
    lda #$27
    sta PPUADDR
    lda #$D3
    sta PPUADDR
    lda #$FF
    sta PPUDATA
    sta PPUDATA
    lda #$27
    sta PPUADDR
    lda #$DB
    sta PPUADDR
    lda #$FF
    sta PPUDATA
    sta PPUDATA
    rts


setCurrentIndex:
        lda levelNumber
@mod10: cmp #$0A
        bmi @copyPalettes ; bcc fixes the colour bug
        sec
        sbc #$0A
        jmp @mod10

@copyPalettes:
        asl a
        asl a
        sta currentIndex
        rts


initializeColorTable:
    ldx #$00
@next:
    lda colorTableDefault,x
    sta colorTable,X
    dex
    bne @next
    rts


colorMenu:
        lda levelNumber
        pha
        lda #$00
        sta currentField
        sta colorPos
        sta presetPos
        sta currentLevel
        sta levelNumber
        sta vramRow


        lda #$EF
        ldx #$8c
    @rowsef:
        sta playfield-1,x
        dex
        bne @rowsef



        lda #$7B
        ldx #$13
    @rows7b:
        sta playfield+180,x
        dex
        bpl @rows7b


        lda #$7C
        ldx #$13
    @rows7c:
        sta playfield+160,x
        dex
        bpl @rows7c

        lda #$7D
        ldx #$13
    @rows7d:
        sta playfield+140,x
        dex
        bpl @rows7d

        ldx #endPresetText-presetText-1
@loadPresets:
        lda presetText,x
        sta playfield+20,x
        dex
        bpl @loadPresets

        lda #$09
        sta renderMode
        jsr updateAudioAndWaitForNmi
        jsr bufferScreen ; hides glitchy scroll
        jsr gameModeState_initGameBackground

        lda #$12
        sta nextPiece
        jsr stageSpriteForNextPiece

@loop:
        jsr setCurrentIndex
        jsr fieldSelectMenu
        jsr colorSelectMenu
        jsr levelSelectMenu
        jsr presetMenu
        jsr setCurrentIndex

        ldx renderToggle
        lda toggleModes,x
        sta renderMode
        txa
        eor #$01
        sta renderToggle

        lda frameCounter
        and #$03
        bne @dontFlicker
        lda #$FF
        sta cursorY

    @dontFlicker:

        lda #%00000010
        sta outOfDateRenderFlags
        jsr updateAudioAndWaitForNmi

        lda newlyPressedButtons_player1
        and #BUTTON_B
        beq @loop
; when exit happens:

        pla
        sta levelNumber
        jmp gameMode_gameTypeMenu

fieldSelectMenu:
    lda #BUTTON_SELECT
    jsr menuThrottle
    beq @ret
    lda #$01
    sta soundEffectSlot1Init
    inc currentField
    lda currentField
    cmp #$03
    bne @ret
    lda #$00
    sta currentField
@ret:
    rts



colorSelectMenu:
    lda currentField
    cmp #FIELD_COLOR
    beq @continue
    rts

@continue:

    ldy colorPos
    ldx currentIndex
@setOffset:
    inx
    dey
    bpl @setOffset
    
    lda #BUTTON_UP
    jsr menuThrottle
    beq @upNotPressed
    lda #$01
    sta soundEffectSlot1Init 
    inc colorTable,x
    lda colorTable,x

    cmp #$0d
    bne @notDangerous
    lda #$0e
    sta colorTable,x
@notDangerous:

    cmp #$40
    bne @upNotPressed
    lda #$00
    sta colorTable,x

@upNotPressed:
    lda #BUTTON_DOWN
    jsr menuThrottle
    beq @downNotPressed
    lda #$01
    sta soundEffectSlot1Init 
    
    dec colorTable,x
    lda colorTable,x

    cmp #$0d
    bne @notDangerous2
    lda #$0c
    sta colorTable,x
@notDangerous2:

    cmp #$ff
    bne @downNotPressed
    lda #$3F
    sta colorTable,x

@downNotPressed:

    lda #BUTTON_RIGHT
    jsr menuThrottle
    beq @rightNotPressed
    lda #$01
    sta soundEffectSlot1Init 
    inc colorPos
    lda colorPos
    cmp #$03
    bne @rightNotPressed
    lda #$00
    sta colorPos
@rightNotPressed:
    lda #BUTTON_LEFT
    jsr menuThrottle
    beq @leftNotPressed
    lda #$01
    sta soundEffectSlot1Init 
    dec colorPos
    bpl @leftNotPressed
    lda #$02
    sta colorPos
@leftNotPressed:
    lda #colorCursorY
    sta cursorY

    lda #colorTile
    sta cursorTile

    lda #colorAttr
    sta cursorAttr

    lda colorPos
    asl
    asl
    asl
    asl
    clc
    adc #colorCursorXOffset
    sta cursorX

@ret: rts





levelSelectMenu:
    lda currentField
    cmp #FIELD_LEVEL
    bne @ret
    lda #BUTTON_LEFT
    jsr menuThrottle
    beq @leftNotPressed
    lda #$01
    sta soundEffectSlot1Init 
    dec levelNumber
@leftNotPressed:
    lda #BUTTON_RIGHT
    jsr menuThrottle
    beq @rightNotPressed
    lda #$01
    sta soundEffectSlot1Init 
    inc levelNumber
@rightNotPressed:
    lda #levelCursorY
    sta cursorY
    lda #levelCursorX
    sta cursorX
    lda #levelAttr
    sta cursorAttr
    lda #levelTile
    sta cursorTile
@ret: rts


presetMenu:
    lda currentField
    cmp #FIELD_PRESETS
    bne @ret
    lda #BUTTON_DOWN
    jsr menuThrottle
    beq @downNotPressed
    lda #$01
    sta soundEffectSlot1Init 
    inc presetPos
    lda presetPos
    cmp #MAX_PRESETS
    bne @downNotPressed
    lda #$00
    sta presetPos
@downNotPressed:
    lda #BUTTON_UP
    jsr menuThrottle
    beq @upNotPressed
    lda #$01
    sta soundEffectSlot1Init 
    dec presetPos
    bpl @upNotPressed
    lda #MAX_PRESETS-1
    sta presetPos
@upNotPressed:
    lda presetPos
    asl
    asl
    asl
    clc
    adc #presetYOffset
    sta cursorY
    lda #presetX
    sta cursorX
    lda #presetAttr
    sta cursorAttr
    lda #presetTile
    sta cursorTile

    lda newlyPressedButtons_player1
    and #BUTTON_A
    beq @ret
    lda #$01
    sta soundEffectSlot1Init 
    ldx currentIndex
    lda colorTableDefault+1,x
    sta colorTable+1,x
    lda colorTableDefault+2,x
    sta colorTable+2,x
    lda colorTableDefault+3,x
    sta colorTable+3,x
@ret: rts



