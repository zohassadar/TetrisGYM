FIFO_IDLE :=    $C1
EMU_UNKNOWN :=  $40

CMD_SEND_STATS := $42

FIFO_DATA :=    $40f0
FIFO_STATUS :=  $40f1

messageHeader: ; $2b = "+". $22 = CMD_USB_WR
        .byte  $2b, $2b ^ $ff, $22, $22 ^ $ff

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

sendEdlinkHeader:
        ldx     #$00
@headerLoop:
        lda     messageHeader,x
        sta     FIFO_DATA
        inx
        cpx     #$04
        bne     @headerLoop
        rts


sendEdlinkData:
        lda     edlinkFlag
        cmp     #CMD_SEND_STATS
        bne     @ret
        jsr     sendEdlinkHeader
        lda     #$05            ; Length.  16 bit LE
        sta     FIFO_DATA
        lda     #$00
        sta     FIFO_DATA
        lda     frameCounter
        sta     FIFO_DATA
        lda     frameCounter
        sta     FIFO_DATA
        lda     frameCounter
        sta     FIFO_DATA
        lda     frameCounter
        sta     FIFO_DATA
        lda     frameCounter
        sta     FIFO_DATA
        lda     #$00
        sta     edlinkFlag
@ret:   rts
