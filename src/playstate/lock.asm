playState_lockTetrimino:
        jsr isPositionValid
        bne gameOver

        jmp notGameOver
gameOver:
.ifdef UNSAFE
        ; check for normal topout
        lda tetriminoY
        bne @noCanDo
        lda tetriminoX
        cmp #5
        bne @noCanDo
        jmp normalTopout
@noCanDo:
        lda #$00
        sta soundEffectSlot0Init
        lda #$02
        sta soundEffectSlot2Init
        jsr reduceScore
        lda #$80
        sta sleepCounter
@wait:
        lda #3
        sta spriteA
        lda #PAUSE_SPRITE_X-4
        sta spriteXOffset
        lda #PAUSE_SPRITE_Y-40
        sta spriteYOffset
        lda #$1f
        sta spriteIndexInOamContentLookup
        jsr stringSprite
        lda #$00
        sta spriteA
        jsr practiseGameHUD
        lda frameCounter
        and #7
        bne @checkIfStaging
        lda blinkingVar
        eor #8
        sta blinkingVar
@checkIfStaging:
        lda blinkingVar
        and #8
        bne @skipStagingCurrent
        jsr stageSpriteForCurrentPiece
@skipStagingCurrent:
        jsr stageSpriteForNextPiece
        jsr updateAudioWaitForNmiAndResetOamStaging
@idleLoop:
        lda #BUTTON_DPAD|BUTTON_A|BUTTON_B
        bit newlyPressedButtons_player1
        bne @resume
        lda sleepCounter
        bne @wait
@resume:
.repeat 4,i
        lda binScore+i
        bne @resetPiece
.endrepeat
        jmp normalTopout
@resetPiece:
        ldx currentPiece
        ldy tetriminoTypeFromOrientation,x
        lda spawnTable,y
        sta currentPiece
        lda #$00
        sta tetriminoY
        sta previous
        lda #$05
        sta tetriminoX
        lda #$01
        sta playState
        jmp playState_playerControlsActiveTetrimino
.endif

normalTopout:
        lda renderFlags ; Flag needed to reveal hidden score
        ora #RENDER_SCORE
        sta renderFlags
        lda #$02
        sta soundEffectSlot0Init
        lda #$0A ; playState_checkStartGameOver
        sta playState
        lda #$F0
        sta curtainRow
        jsr updateAudio2

        ; reset checkerboard score
        lda practiseType
        cmp #MODE_CHECKERBOARD
        bne @noChecker
        lda #0
        sta binScore
        sta binScore+1
        jsr setupScoreForRender
@noChecker:
        ; make invisible tiles visible
        lda #$00
        sta invisibleFlag
        sta vramRow
        rts

notGameOver:
        lda vramRow
        cmp #$20
        bmi @ret
        lda tetriminoY
        asl a
        sta generalCounter
        asl a
        asl a
        clc
        adc generalCounter
        adc tetriminoX
        sta generalCounter
        lda currentPiece
        asl a
        asl a
        sta generalCounter2
        asl a
        clc
        adc generalCounter2
        tax
        ldy #$00
        lda #$04
        sta generalCounter3
; Copies a single square of the tetrimino to the playfield
@lockSquare:
        lda orientationTable,x
        asl a
        sta generalCounter4
        asl a
        asl a
        clc
        adc generalCounter4
        clc
        adc generalCounter
        sta positionValidTmp
        inx
        lda orientationTable,x
        sta generalCounter5
        inx
        lda orientationTable,x
        clc
        adc positionValidTmp
        tay
        lda generalCounter5
        ; BLOCK_TILES
        sta (playfieldAddr),y
        inx
        dec generalCounter3
        bne @lockSquare
        lda practiseType
        cmp #MODE_LOWSTACK
        bne @notAboveLowStack
        jsr checkIfAboveLowStackLine
        bcc @notAboveLowStack
        ldx #<lowStackNopeGraphic
        ldy #>lowStackNopeGraphic
        sec
        lda #19
        sbc lowStackRowModifier
        cmp #$09
        bcs @drawOnUpperHalf
; draw on lower half
        adc #$03 ; carry already clear
        bne @copyGraphic
@drawOnUpperHalf:
        sbc #$04 ; carry already set
@copyGraphic:
        jsr copyGraphicToPlayfieldAtCustomRow
        jmp gameOver
@notAboveLowStack:
        lda #$00
        sta lineIndex
        jsr updatePlayfield
        jsr updateMusicSpeed
        inc playState
@ret:   rts
