EMU_UNKNOWN :=  $40
FIFO_PENDING := $41
FIFO_IDLE :=    $C1

; FIFO_DATA reads unpredictable value when FIFO_STATUS != FIFO_PENDING
FIFO_DATA :=    $40f0
FIFO_STATUS :=  $40f1

messageHeader:
        ; $2b = +
        ; $22 = CMD_USB_WR
        .byte   $2b, ~$2b, $22, ~$22

displayBetterMoveIfThere:
        lda     srMoveTimer
        beq     @ret
        lda     tetriminoX
        pha
        lda     tetriminoY
        pha
        lda     currentPiece
        pha
        lda     srMove
        sta     currentPiece
        lda     srMove+1
        sta     tetriminoY
        lda     srMove+2
        sta     tetriminoX
        jsr     stageSpriteForCurrentPiece

        ; set up frame based flicker
        lda     frameCounter
        and     #$01
        asl
        asl
        clc
        adc     #$0D
        sta     generalCounter

        ; change tile
        lda     oamStaging-15,x
        adc     generalCounter
        sta     oamStaging-15,x
        lda     oamStaging-11,x
        adc     generalCounter
        sta     oamStaging-11,x
        lda     oamStaging-7,x
        adc     generalCounter
        sta     oamStaging-7,x
        lda     oamStaging-3,x
        adc     generalCounter
        sta     oamStaging-3,x

        pla
        sta     currentPiece
        pla
        sta     tetriminoY
        pla
        sta     tetriminoX
        dec     srMoveTimer
@ret:   rts


checkReceiveMove:
        lda     srMoveTimer
        bne     @ret
        lda     gameMode
        cmp     #4
        bne     @ret
        lda     playState
        cmp     #3
        bne     @ret
        lda     FIFO_STATUS
        cmp     #FIFO_PENDING
        bne     @ret
        lda     FIFO_DATA
        sta     srMove
        lda     FIFO_DATA
        sta     srMove+1
        lda     FIFO_DATA
        sta     srMove+2
        lda     #$A
        sta     srMoveTimer
@ret:   rts


sendPlayfieldState:
        lda     messageHeader
        sta     FIFO_DATA
        lda     messageHeader+1
        sta     FIFO_DATA
        lda     messageHeader+2
        sta     FIFO_DATA
        lda     messageHeader+3
        sta     FIFO_DATA

        lda     #205 ; playfield (200) + currentPiece + nextPiece + levelNumber + lines + lines+1
        sta     FIFO_DATA
        lda     #$00
        sta     FIFO_DATA
        ldx     #0
@copyPlayfield:
        lda     playfield,x
        sta     FIFO_DATA
        inx
        cpx     #200
        bne     @copyPlayfield
        lda     currentPiece    ; index 200
        sta     FIFO_DATA
        lda     nextPiece       ; index 201
        sta     FIFO_DATA
        lda     levelNumber     ; index 202
        sta     FIFO_DATA
        lda     lines           ; index 203
        sta     FIFO_DATA
        lda     lines+1         ; index 204
        sta     FIFO_DATA
        rts
