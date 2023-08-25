FIFO_DATA :=    $40f0
FIFO_STATUS :=  $40f1

EMU_UNKNOWN :=  $40
FIFO_IDLE :=    $C1
CMD_SEND_STATS := $42

messageHeader:
        ; $2b = "+". $22 = CMD_USB_WR
        .byte   $2b, $2b ^ $ff, $22, $22 ^ $ff

sendEdlinkHeader:
        ldx     #$00
@headerLoop:
        lda     messageHeader,x
        sta     FIFO_DATA
        inx
        cpx     #$04
        bne     @headerLoop
        rts

receiveEdlinkCommand:
        lda     FIFO_STATUS
        cmp     #EMU_UNKNOWN
        beq     @ret
        cmp     #FIFO_IDLE
        beq     @ret
        lda     FIFO_DATA
        sta     edlinkFlag
        jmp     receiveEdlinkCommand
@ret:   rts

; needed for nestrischamps:
; gameMode 1 
; playState 1
; rowY 1
; completedRow
; lines 2 (bcd)
; levelNumber 1
; binScore 4
; nextPiece 1
; currentPiece 1
; tetriminoX 1 Needed to determine where piece is in playfield
; tetriminoY 1 same
; statsByType 14
; playfield 200
; Total 232/0xe8

; needed on c# side:
; tetriminoTypeFromOrientation
; orientationTable

sendEdlinkData:
        lda     edlinkFlag
        cmp     #CMD_SEND_STATS
        bne     @ret
        jsr     sendEdlinkHeader
        lda     #$e8          ; Length.  16 bit LE
        sta     FIFO_DATA
        lda     #$00
        sta     FIFO_DATA

        ; gameMode. 1
        lda     gameMode
        sta     FIFO_DATA

        ; playState. 1
        lda     playState
        sta     FIFO_DATA

        ; rowY. 1
        lda     rowY
        sta     FIFO_DATA

        ; completedRow.  4
        ldx     #$00
@completedRowLoop:
        lda     completedRow,x
        sta     FIFO_DATA
        inx
        cpx     #$04
        bne     @completedRowLoop

        ; lines.  2
        lda     lines
        sta     FIFO_DATA
        lda     lines+1
        sta     FIFO_DATA

        ; level. 1
        lda     levelNumber
        sta     FIFO_DATA

        ; score.  4
        ldx     #$00
@scoreLoop:
        lda     binScore,x
        sta     FIFO_DATA
        inx
        cpx     #$04
        bne     @scoreLoop

        ; nextPiece.  1
        lda     nextPiece
        sta     FIFO_DATA

        ; currentPiece.  1
        lda     currentPiece
        sta     FIFO_DATA

        ; tetrimonoX.  1
        lda     tetriminoX
        sta     FIFO_DATA

        ; tetriminoY.  1
        lda     tetriminoY
        sta     FIFO_DATA

        ; statsByType.  14
        ldx     #$00
@statsLoop:
        lda     statsByType,x
        sta     FIFO_DATA
        inx
        cpx     #$0e
        bne     @statsLoop

        ; playfield.  200
        ldx     #$00
@playfieldLoop:
        lda     playfield,x
        sta     FIFO_DATA
        inx
        cpx     #$c8
        bne     @playfieldLoop

        lda     #$00
        sta     edlinkFlag
@ret:   rts