render_mode_play_and_demo:
        lda animationRenderFlag
        beq @playStateNotDisplayLineClearingAnimation
        jsr dumpAnimationBuffer
        lda #$00
        sta vramRow
        jmp @renderLines

@playStateNotDisplayLineClearingAnimation:
        lda playState
        cmp #$04
        beq @renderLines

        jsr render_playfield
@renderLines:

        lda scoringModifier
        bne @modernLines

        lda outOfDateRenderFlags
        and #$01
        beq @renderLevel

        lda #$20
        sta PPUADDR
        lda #$73
        sta PPUADDR
        lda lines+1
        sta PPUDATA
        lda lines
        jsr twoDigsToPPU
        jmp @doneRenderingLines

@modernLines:
        jsr renderModernLines
@doneRenderingLines:
        lda outOfDateRenderFlags
        and #$FE
        sta outOfDateRenderFlags

@renderLevel:
        lda outOfDateRenderFlags
        and #$02
        beq @renderScore

        lda practiseType
        cmp #MODE_TYPEB
        beq @renderLevelTypeB

        lda practiseType
        cmp #MODE_CHECKERBOARD
        beq @renderLevelCheckerboard

        lda #$22
        sta PPUADDR
        lda #$B9
        sta PPUADDR
        lda levelNumber
        jsr renderByteBCD
        jmp @renderLevelEnd

@renderLevelCheckerboard:
        jsr renderLevelDash
        lda checkerModifier
        sta PPUDATA
        jmp @renderLevelEnd

@renderLevelTypeB:
        jsr renderLevelDash
        lda typeBModifier
        sta PPUDATA
        ; jmp @renderLevelEnd

@renderLevelEnd:
        jsr updatePaletteForLevel
        lda outOfDateRenderFlags
        and #$FD
        sta outOfDateRenderFlags

@renderScore:
        lda outOfDateRenderFlags
        and #$04
        beq @renderHz

        ; 8 safe tile writes freed from stats / hz
        ; (lazy render hz for 10 more)
        ; 1 added in level (3 total)
        ; 2 added in lines (5 total)
        ; independent writes;
        ; 1 added in 7digit
        ; 3 added in float

        ; scorecap
        lda scoringModifier
        cmp #SCORING_HIDDEN
        bne @notHidden
        lda playState
        cmp #$0A
        beq @noFloat ; render classic score at game over
        jmp @clearScoreRenderFlags
@notHidden:
        cmp #SCORING_SCORECAP
        bne @noScoreCap
        jsr renderScoreCap
        jmp @clearScoreRenderFlags
@noScoreCap:

        lda scoringModifier
        cmp #SCORING_LETTERS
        bne @noLetters
        jsr renderLettersScore
        jmp @clearScoreRenderFlags
@noLetters:

        lda scoringModifier
        cmp #SCORING_SEVENDIGIT
        bne @noSevenDigit
        jsr renderSevenDigit
        jmp @clearScoreRenderFlags
@noSevenDigit:

        ; millions
        lda scoringModifier
        cmp #SCORING_FLOAT
        bne @noFloat
        jsr renderFloat
        jmp @clearScoreRenderFlags
@noFloat:

        jsr renderClassicScore

@clearScoreRenderFlags:
        lda outOfDateRenderFlags
        and #$FB
        sta outOfDateRenderFlags
@renderHz:
        lda outOfDateRenderFlags
        and #$10
        beq @actuallyRenderStats
        jsr renderNext
@actuallyRenderStats:
        lda outOfDateRenderFlags
        and #$40
        beq @renderTetrisFlashAndSound
        ldx currentPiece
        lda tetriminoTypeFromOrientation, x
        sta tmpCurrentPiece
@renderPieceStat:
        lda tmpCurrentPiece
        asl a
        tax
        lda pieceToPpuStatAddr,x
        sta PPUADDR
        lda pieceToPpuStatAddr+1,x
        sta PPUADDR
        lda statsByType+1,x
        sta PPUDATA
        lda statsByType,x
        jsr twoDigsToPPU
        lda outOfDateRenderFlags
        and #$BF
        sta outOfDateRenderFlags
@renderTetrisFlashAndSound:
        lda #$3F
        sta PPUADDR
        lda #$0E
        sta PPUADDR
        ldx #$00
        lda completedLines
        cmp #$04
        bne @setPaletteColor
        lda frameCounter
        and #$03
        bne @setPaletteColor
        ldx #$30
        lda frameCounter
        and #$07
        bne @setPaletteColor
        lda #$09
        sta soundEffectSlot1Init
@setPaletteColor:
        lda disableFlashFlag
        bne @noFlash
        stx PPUDATA
@noFlash:
; .if INES_MAPPER = 3
        ; lda #%10011000
        lda currentPpuCtrl
        sta PPUCTRL
        ; sta currentPpuCtrl
; .endif
        jsr resetScroll
        rts

pieceToPpuStatAddr:
        .dbyt   $2186,$21C6,$2206,$2246
        .dbyt   $2286,$22C6,$2306


rightCol = generalCounter
leftCol = generalCounter2
counter = generalCounter3
; clearedRowAddr = generalCounter4 ; & 5


dumpAnimationBuffer:
        lda animationRenderBuffer
        beq @ret

        lda currentPpuCtrl
        ora #$04
        sta PPUCTRL

        ldy #$00
@outerLoop:
        lda animationRenderBuffer,y
        beq @restoreCtrl
        sta PPUADDR
        iny
        lda animationRenderBuffer,y
        sta PPUADDR
        iny
        ldx animationRenderBuffer,y
        iny
@innerLoop:
        lda animationRenderBuffer,y
        sta PPUDATA
        iny
        dex
        bne @innerLoop
        beq @outerLoop

@restoreCtrl:
        lda #$00
        sta animationRenderBuffer
        sta animationRenderFlag

        lda currentPpuCtrl
        sta PPUCTRL
@ret:   
        rts


updateLineClearingAnimation:
        ldx practiseType
        cpx #MODE_MEDIUM
        beq updateLineClearingAnimationForMedium
        cpx #MODE_BIG
        bne @smallJump
        jmp updateLineClearingAnimationForBig
@smallJump:
        jmp updateLineClearingAnimationForSmall
updateLineClearingAnimationForMedium:
        lda playState
        cmp #$04
        bne @firstRet
        lda frameCounter
        and #$03
        beq @carryOn
@firstRet:
        rts
@carryOn:
        ; invisible mode show blocks intead of empty

        ldx rowY
        lda leftColumns,x
        sta leftCol
        lda rightColumns,x
        sta rightCol

        ldy tetriminoYforLineClear
        dey
        dey
        dey
        dey

        tya
        asl
        tay
        lda vramPlayfieldRows+1,y
        sta animationRenderBuffer+0
        sta animationRenderBuffer+7

        lda vramPlayfieldRows,y
        clc
        adc leftCol
        sta animationRenderBuffer+1

        lda vramPlayfieldRows,y
        clc
        adc rightCol
        sta animationRenderBuffer+8

        lda #$04
        sta animationRenderBuffer+2
        sta animationRenderBuffer+9

        ldy #$00
        ldx leftCol

.repeat 4,index
        lda completedRow,y
        bne :+
        lda SRAM_clearbuffer+(index*10),x
        jmp :++
:
        lda #EMPTY_TILE
:
        sta animationRenderBuffer+3+index

        ldx rightCol
        lda completedRow,y
        bne :+
        lda SRAM_clearbuffer+(index*10),x
        jmp :++
:
        lda #EMPTY_TILE
:
        sta animationRenderBuffer+10+index
        ldx leftCol
        iny
.endrepeat
        inc animationRenderFlag
        lda #$00
        sta animationRenderBuffer+14
        inc rowY
        lda rowY
        cmp #$05
        bmi @ret
        inc playState
        lda #$00
        sta vramRow
@ret:   rts

leftColumns:
        .byte   $04,$03,$02,$01,$00
rightColumns:
        .byte   $05,$06,$07,$08,$09
; Set Background palette 2 and Sprite palette 2
updatePaletteForLevel:
        lda levelNumber
@mod10: cmp #$0A
        bmi @copyPalettes ; bcc fixes the colour bug
        sec
        sbc #$0A
        jmp @mod10

@copyPalettes:
        asl a
        asl a
        tax
        lda #$00
        sta generalCounter
@copyPalette:
        lda #$3F
        sta PPUADDR
        lda #$08
        clc
        adc generalCounter
        sta PPUADDR
        lda colorTable,x
        sta PPUDATA
        lda colorTable+1,x
        sta PPUDATA
        lda colorTable+1+1,x
        sta PPUDATA
        lda colorTable+1+1+1,x
        sta PPUDATA
        lda generalCounter
        clc
        adc #$10
        sta generalCounter
        cmp #$20
        bne @copyPalette
        rts

; 4 bytes per level (bg, fg, c3, c4)
colorTable:
        .dbyt   $0F30,$2112,$0F30,$291A,$0F30,$2414,$0F30,$2A12
        .dbyt   $0F30,$2B15,$0F30,$222B,$0F30,$0016,$0F30,$0513
        .dbyt   $0F30,$1612,$0F30,$2716,$60E6,$69A5,$69C9,$1430
        .dbyt   $04A9,$2085,$69E6,$89A5,$89C9,$1430,$04A9,$2085
        .dbyt   $8960,$A549,$C920,$3056,$A5BE,$C901,$F020,$A5A4
        .dbyt   $C900,$D00E,$E6A4,$A5B7,$85A5,$20EB,$9885,$A64C
        .dbyt   $EA98,$A5A5,$C5B7,$D036,$A5A4,$C91C,$D030,$A900
        .dbyt   $85A4,$8545,$8541,$A901,$8548,$A905,$8540,$A6BF
        .dbyt   $BD56,$9985,$4220,$6999,$A5BE,$C901,$F007,$A5A6
        .dbyt   $85BF,$4CE6,$9820,$EB98,$85BF,$A900,$854E,$60A5
        .dbyt   $C0C9,$05D0,$12A6,$D3E6,$D3BD,$00DF,$4A4A,$4A4A
        .dbyt   $2907,$AABD,$4E99,$6020,$0799,$60E6,$1AA5,$1718
        .dbyt   $651A,$2907,$C907,$F008,$AABD,$4E99,$C519,$D01C
        .dbyt   $A217,$A002,$2047,$ABA5,$1729,$0718,$6519,$C907
        .dbyt   $9006,$38E9,$074C,$2A99,$AABD,$4E99,$8519,$6000
        .dbyt   $0000,$0001,$0101,$0102,$0203,$0404,$0505,$0505

incrementPieceStat:
        tax
        lda tetriminoTypeFromOrientation,x
        asl a
        tax
        lda statsByType,x
        clc
        adc #$01
        sta generalCounter
        and #$0F
        cmp #$0A
        bmi L9996
        lda generalCounter
        clc
        adc #$06
        sta generalCounter
        cmp #$A0
        bcc L9996
        clc
        adc #$60
        sta generalCounter
        lda statsByType+1,x
        clc
        adc #$01
        sta statsByType+1,x
L9996:  lda generalCounter
        sta statsByType,x
        lda outOfDateRenderFlags
        ora #$40
        sta outOfDateRenderFlags
        rts

updateLineClearingAnimationForBig:
        lda playState
        cmp #$04
        bne @firstRet
        lda frameCounter
        and #$03
        beq @carryOn
@firstRet:
        rts
@carryOn:
        ; invisible mode show blocks intead of empty

        ldx rowY
        lda leftColumns,x
        lsr
        sta leftCol
        lda #$00
        sta bigModeLeftOne
        rol bigModeLeftOne
        ; copy 1 to most significant bit to compare later that doesn't destroy accum
        lda bigModeLeftOne
        sta bigModeLeftBit
        ror bigModeLeftBit
        ror bigModeLeftBit

        lda rightColumns,x
        lsr
        sta rightCol
        lda #$00
        sta bigModeRightOne
        rol bigModeRightOne
        lda bigModeRightOne
        sta bigModeRightBit
        ror bigModeRightBit
        ror bigModeRightBit

        ldy tetriminoYforLineClear
        dey
        dey
        dey
        dey

        tya
        asl
        asl ; extra for big mode
        tay
        lda vramPlayfieldRows+1,y
        sta animationRenderBuffer+0
        sta animationRenderBuffer+11


        lda vramPlayfieldRows,y
        clc
        adc leftCol
        adc leftCol
        adc bigModeLeftOne
        sta animationRenderBuffer+1

        lda vramPlayfieldRows,y
        clc
        adc rightCol
        adc rightCol
        adc bigModeRightOne
        sta animationRenderBuffer+12

        lda #$08
        sta animationRenderBuffer+2
        sta animationRenderBuffer+13

        ldy #$00
        ldx leftCol

.repeat 4,index
        lda completedRow,y
        bne :++
        lda SRAM_clearbuffer+(index*5),x
        cmp #EMPTY_TILE
        beq :++
        clc
        adc #$10
        bit bigModeLeftBit
        bpl :+
        adc #$10
:
        sta animationRenderBuffer+3+(index*2)

        adc #$20
        sta animationRenderBuffer+4+(index*2)
        jmp :++
:
        lda #EMPTY_TILE
        sta animationRenderBuffer+3+(index*2)
        sta animationRenderBuffer+4+(index*2)
:
        ldx rightCol

        lda completedRow,y
        bne :++
        lda SRAM_clearbuffer+(index*5),x
        cmp #EMPTY_TILE
        beq :++
        clc
        adc #$10
        bit bigModeRightBit
        bpl :+
        adc #$10
:
        sta animationRenderBuffer+14+(index*2)
        adc #$20
        sta animationRenderBuffer+15+(index*2)
        jmp :++
:
        lda #EMPTY_TILE
        sta animationRenderBuffer+14+(index*2)
        sta animationRenderBuffer+15+(index*2)
:
        ldx leftCol
        iny
.endrepeat
        inc animationRenderFlag
        lda #$00
        sta animationRenderBuffer+44
        inc rowY
        lda rowY
        cmp #$05
        bmi @ret
        lda #$00
        sta vramRow
        inc playState
@ret:   rts


updateLineClearingAnimationForSmall:
        lda tetriminoYforLineClear
        and #$01
        bne @odd
        jmp updateLineClearingAnimationForSmallEven
@odd:
        jmp updateLineClearingAnimationForSmallOdd


.macro makeident lname, count
    .ident(.concat(lname,.sprintf("%d", count))):
.endmacro


.macro checkSmallMode index, _completedRow
        lda #$C0
        sta generalCounter4

@checkUpperLeft:
        lda SRAM_clearbuffer+(index*40),x
        bmi @checkUpperRight
        lda _completedRow+(index*2)
        bne @checkLowerLeft
        lda #$01
        ora generalCounter4
        sta generalCounter4
@checkUpperRight:
        lda SRAM_clearbuffer+(index*40)+1,x
        bmi @checkLowerLeft
        lda #$2
        ora generalCounter4
        sta generalCounter4
@checkLowerLeft:
        lda SRAM_clearbuffer+(index*40)+20,x
        bmi @checkLowerRight
        lda _completedRow+(index*2)+1
        bne @plantTile
        lda #$04
        ora generalCounter4
        sta generalCounter4
@checkLowerRight:
        lda SRAM_clearbuffer+(index*40)+21,x
        bmi @plantTile
        lda #$08
        ora generalCounter4
        sta generalCounter4
@plantTile:
        lda generalCounter4
.endMacro


updateLineClearingAnimationForSmallEven:
        lda playState
        cmp #$04
        bne @firstRet
        lda frameCounter
        and #$03
        beq @carryOn
@firstRet:
        rts
@carryOn:
        ; invisible mode show blocks intead of empty
        ldx rowY
        lda leftColumns,x
        asl
        sta leftCol

        lda rightColumns,x
        asl
        sta rightCol
        
        ldy tetriminoYforLineClear
        dey
        dey
        dey
        dey

        ; tya
        ; asl
        ; asl ; extra for big mode
        ; tay
        lda vramPlayfieldRows+1,y
        sta animationRenderBuffer+0
        sta animationRenderBuffer+5

        
        lda vramPlayfieldRows,y
        clc
        adc leftColumns,x
        sta animationRenderBuffer+1


        lda vramPlayfieldRows,y
        clc
        adc rightColumns,x
        sta animationRenderBuffer+6

        lda #$02
        sta animationRenderBuffer+2
        sta animationRenderBuffer+7

        ldy #$00
        ldx leftCol

.repeat 2,index
        makeident "foo", index ; https://codebase64.org/doku.php?id=base:create_labels_on_the_fly_using_macros
        checkSmallMode index, completedRow
        sta animationRenderBuffer+index+3

        ldx rightCol

        makeident "fum", index ; https://codebase64.org/doku.php?id=base:create_labels_on_the_fly_using_macros
        checkSmallMode index, completedRow

        sta animationRenderBuffer+index+8
        ldx leftCol
.endrepeat
        inc animationRenderFlag
        lda #$00
        sta animationRenderBuffer+10
        inc rowY
        lda rowY
        cmp #$05
        bmi @ret4
        lda #$00
        sta vramRow
        inc playState
@ret4:  rts





updateLineClearingAnimationForSmallOdd:
        lda playState
        cmp #$04
        bne @firstRet
        lda frameCounter
        and #$03
        beq @carryOn
@firstRet:
        rts
@carryOn:
        ; invisible mode show blocks intead of empty
        ldx rowY
        lda leftColumns,x
        asl
        sta leftCol

        lda rightColumns,x
        asl
        sta rightCol
        
        ldy tetriminoYforLineClear
        dey
        dey
        dey
        dey

        tya ; kill odd bit
        lsr
        asl
        tay
        ; tya
        ; asl
        ; asl ; extra for big mode
        ; tay
        lda vramPlayfieldRows+1,y
        sta animationRenderBuffer+0
        sta animationRenderBuffer+6

        
        lda vramPlayfieldRows,y
        clc
        adc leftColumns,x
        sta animationRenderBuffer+1


        lda vramPlayfieldRows,y
        clc
        adc rightColumns,x
        sta animationRenderBuffer+7

        lda #$03
        sta animationRenderBuffer+2
        sta animationRenderBuffer+8

        ldy #$00
        ldx leftCol

.repeat 3,index
        makeident "fee", index ; https://codebase64.org/doku.php?id=base:create_labels_on_the_fly_using_macros
        checkSmallMode index, completedRow-1
        sta animationRenderBuffer+index+3

        ldx rightCol

        makeident "fii", index ; https://codebase64.org/doku.php?id=base:create_labels_on_the_fly_using_macros
        checkSmallMode index, completedRow-1

        sta animationRenderBuffer+index+9
        ldx leftCol
.endrepeat
        inc animationRenderFlag
        lda #$00
        sta animationRenderBuffer+12
        inc rowY
        lda rowY
        cmp #$05
        bmi @ret4
        lda #$00
        sta vramRow
        inc playState
@ret4:  rts


