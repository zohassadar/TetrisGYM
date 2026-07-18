gameModeState_initGameState:
        jsr clearPlayfield
        ldx #$0F
        lda #$00
; statsByType
@initStatsByType:
        sta $03EF,x
        dex
        bne @initStatsByType
        lda #$05
        sta tetriminoX

        ;init for crash frame parity
        lda frameCounter
        and #$01
        sta startParity

        ; set seed init
        lda set_seed_input
        sta set_seed
        lda set_seed_input+1
        sta set_seed+1
        lda set_seed_input+2
        sta set_seed+2

        ; convert bcd linecap high byte to binary
        lda linecapLines
        lsr
        lsr
        lsr
        lsr
        tay
        lda multBy10Table,y
        sta generalCounter
        lda linecapLines
        and #$F
        clc
        adc generalCounter
        sta linecapLinesBinHi


        ; paceResult init
        lda #$B0
        sta paceResult
        lda #$00
        sta paceSign
        sta paceResult+1
        sta paceResult+2
        sta gameTimer
        sta gameTimer+1
        sta gameTimerStop

        ; misc
        sta spawnDelay
        sta saveStateSpriteDelay
        sta saveStateDirty
        sta completedLines ; reset during tetris bugfix
        sta presetIndex ; actually for tspinQuantity
        sta linesTileQueue
        sta linesBCDHigh
        sta linecapState
        sta dasOnlyShiftDisabled
        sta invisibleFlag
        sta currentFloor
        sta crashState
        sta trtLineCounter
        sta trtLineCounter+1
        sta trtScratch+5
        sta trtLines
        sta trtLines+1
        sta secretGrade
        lda nextBoxStart
        sta hideNextPiece

; initialize currentFloor if necessary
        lda floorModifier
        beq @notFloor
        sta currentFloor
@notFloor:

        lda invisibleOptionFlag
        beq @notInvisible
        sta invisibleFlag
@notInvisible:

        lda practiseType
        cmp #MODE_TAPQTY
        bne @noTapQty
        jsr random10
        sta tqtyNext
        sta tqtyCurrent
@noTapQty:

        jsr clearPoints
        ; 0 in A

        ; OEM stuff (except score stuff now)
        sta tetriminoY
        sta vramRow
        sta fallTimer
        sta pendingGarbage
        sta lines
        sta lines+1
        sta lineClearStatsByType
        sta lineClearStatsByType+1
        sta lineClearStatsByType+2
        sta lineClearStatsByType+3
        sta allegro
        sta holdDownPoints
        sta spawnID
        lda #RENDER_PLAY
        sta renderMode
        ldx #$A0
        lda palFlag
        beq @ntsc
        ldx #$B4
@ntsc:
        stx autorepeatY
        jsr chooseNextTetrimino
        sta currentPiece
        jsr incrementPieceStat
        ldx #rng_seed
        jsr generateNextPseudorandomNumber
        jsr chooseNextTetrimino
        sta nextPiece
        jsr transitionModeSetup
        lda practiseType
        cmp #MODE_TYPEB
        bne @notTypeB
        lda bTypeLines
        sta lines
@notTypeB:

        lda practiseType
        cmp #MODE_CHECKERBOARD
        bne @noChecker
        lda checkerModifier
        rol
        rol
        rol
        rol
        and #$F0
        sta bcd32+1
        lda #0
        sta bcd32
        sta bcd32+2
        sta bcd32+3
        jsr presetScoreFromBCD
@noChecker:

        lda #RENDER_STATS|RENDER_HZ|RENDER_SCORE|RENDER_LEVEL|RENDER_LINES
        sta renderFlags
        jsr updateAudioWaitForNmiAndResetOamStaging

        lda practiseType
        cmp #MODE_TYPEB
        bne @noTypeBPlayfield
        jsr initPlayfieldForTypeB
@noTypeBPlayfield:

        jsr hzStart
        lda #0
        sta hzSpawnDelay
        jsr initializeTopRowBuffer
        jsr practiseInitGameState
        jsr resetScroll

        ldx musicType
        lda musicSelectionTable,x
        jsr setMusicTrack
        inc gameModeState ; 2

initGameState_return:
        rts

transitionModeSetup:
        lda runwayFlag
        beq initGameState_return
        lda #0
        sta factorB24+1
        sta factorB24+2
        sta lines+1

        ldx runwayLines
        lda levelDisplayTable,x
        sta lines
        ldx #4
@shift:
        asl lines
        rol lines+1
        dex
        bne @shift

        sta bcd32+0
        lda #<100000
        sta factorA24+0
        lda #>100000
        sta factorA24+1
        lda #^100000
        sta factorA24+2

        lda runwayScore
        sta factorB24
        jsr unsigned_mul24
        lda product24+0
        sta binScore+0
        lda product24+1
        sta binScore+1
        lda product24+2
        sta binScore+2
        jmp setupScoreForRender

presetScoreFromBCD:
        jsr BCD_BIN
        lda binary32
        sta binScore
        lda binary32+1
        sta binScore+1
        lda binary32+2
        sta binScore+2
        jmp setupScoreForRender

initPlayfieldForTypeB:
; decide which seed to use
        lda typeBSeedFlag
        beq @notSeeded

; seeded
        lda b_seed_input
        sta b_seed
        lda b_seed_input+1
        sta b_seed+1
        jmp @checkModifier

@notSeeded:
        lda rng_seed
        sta b_seed
        sta b_seed_input
        lda rng_seed+1
        sta b_seed+1
        sta b_seed_input+1


@checkModifier:
        lda typeBModifier
        cmp #$6
        bmi @normalStart
        sbc #$5
        asl
        adc #$0c
        jmp @abnormalStart
@normalStart:
        lda #$0C
@abnormalStart:
        sta generalCounter
L87E7:  lda generalCounter
        beq L884A
        lda #$14
        sec
        sbc generalCounter
        sta generalCounter2
        lda #$00
        sta vramRow
        lda #$09
        sta generalCounter3
L87FC:  ldx #b_seed
        jsr generateNextPseudorandomNumber
        lda b_seed
        and #$07
        tay
        lda rngTable,y
        sta generalCounter4
        ldx generalCounter2
        lda multBy10Table,x
        clc
        adc generalCounter3
        tay
        lda generalCounter4
        sta playfield,y
        lda generalCounter3
        beq L8824
        dec generalCounter3
        jmp L87FC

L8824:  ldx #b_seed
        jsr generateNextPseudorandomNumber
        lda b_seed
        and #$0F
        cmp #$0A
        bpl L8824
        sta generalCounter5
        ldx generalCounter2
        lda multBy10Table,x
        clc
        adc generalCounter5
        tay
        lda #EMPTY_TILE
        sta playfield,y
        jsr updateAudioAndWaitForNmi
        dec generalCounter
        bne L87E7
L884A:
        ldx typeBModifier
        lda typeBBlankInitCountByHeightTable,x
        tay
        lda #EMPTY_TILE
L885D:  sta playfield,y
        dey
        ; cpy #$0 ; dey sets z flag
        bne L885D
        lda #$00
        sta vramRow
        rts

        ; 0 3 5 8 10 12 -> 14 16 18
typeBBlankInitCountByHeightTable:
        .byte $C8,$AA,$96,$78,$64,$50,$3C,$28,$14
rngTable:
        .byte EMPTY_TILE,BLOCK_TILES,EMPTY_TILE,BLOCK_TILES+1
        .byte BLOCK_TILES+2,BLOCK_TILES+2,EMPTY_TILE,EMPTY_TILE
