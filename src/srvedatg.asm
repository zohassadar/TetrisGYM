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


checkSendPlayfieldState:
        lda     gameMode
        cmp     #4
        bne     ret4
        lda     playState
        cmp     #3
        bne     ret4
        lda     lineIndex
        bne     ret4
        jmp     sendPlayfieldState
ret4:   rts

checkReceiveMove:
        lda      srMoveTimer
        bne      ret4
        jmp      receiveSRMove

receiveSRMove:
        lda     FIFO_STATUS
        cmp     #FIFO_PENDING
        bne     @ret
        lda     FIFO_DATA
        sta     srMove
        lda     FIFO_DATA
        sta     srMove+1
        lda     FIFO_DATA
        sta     srMove+2
        lda     #5
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
        lda     currentPiece
        sta     FIFO_DATA
        lda     nextPiece
        sta     FIFO_DATA
        lda     levelNumber
        sta     FIFO_DATA
        lda     lines
        sta     FIFO_DATA
        lda     lines+1
        sta     FIFO_DATA
        rts
