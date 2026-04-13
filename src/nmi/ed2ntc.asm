EMU_UNKNOWN :=  $40
FIFO_PENDING := $41
FIFO_IDLE :=    $C1
CMD_SEND_STATS := $42
CMD_SEND_COMPACT := $43

PAYLOAD_SIZE    = $ed

COMPACT_SIZE    = $36

COMPACT_HEADER  = $A55A
COMPACT_FOOTER  = $5AA5
COMPACT_UPDATE_STATE = $00
COMPACT_UPDATE_FIELD = $01


; note about everdrive's fifo queue

; sta, lda, cmp, or any operation that puts $40F0 or $C0F0 on the
; address bus will be interpreted the same by the everdrive.
; for example the following all have the same effect of transferring a byte to
; the fifo queue:
;
; lda $01
; sta $40F0
;
; lda $01
; sta $C0F0
;
; lda $01
; lda $40F0
;
; lda $01
; lda $C0F0
;
; lda $01
; and $C0F0
;
; etc...

; FIFO_DATA reads unpredictable value when FIFO_STATUS != FIFO_PENDING
FIFO_DATA :=    $40f0
FIFO_STATUS :=  $40f1

messageHeader:
        ; $2b = "+". $22 = CMD_USB_WR
        .byte   $2b, $2b ^ $ff, $22, $22 ^ $ff


sendNTCData:
        lda     FIFO_STATUS
        cmp     #FIFO_PENDING
        beq     @checkData
@ret:
        rts
@checkData:
        lda     FIFO_DATA
        cmp     #CMD_SEND_COMPACT
        bne     @ret
        lda     messageHeader
        sta     FIFO_DATA
        lda     messageHeader+1
        sta     FIFO_DATA
        lda     messageHeader+2
        sta     FIFO_DATA
        lda     messageHeader+3
        sta     FIFO_DATA

        lda     #COMPACT_SIZE   ; Length.  16 bit LE
        sta     FIFO_DATA
        lda     #$00
        sta     FIFO_DATA

; options for both kinds of updates
        ; header 2
        lda     #>COMPACT_HEADER
        sta     FIFO_DATA

        lda     #<COMPACT_HEADER
        sta     FIFO_DATA

        lda     frameCounter
        sta     FIFO_DATA
        lda     frameCounter+1
        sta     FIFO_DATA
        lda     gameMode
        sta     FIFO_DATA
        lda     playState
        sta     FIFO_DATA
        sharedBytesLength = 4

        ldx     vramRow
        cpx     #$20            ; send game data when playfield isn't rendering
        beq     @sendState
        lda     playState
        cmp     #$04            ; send game data when animation is showing
        beq     @sendState
        jmp     sendCompactField
@sendState:
        ; subtotal 8

        ; frame type 1
        lda     #COMPACT_UPDATE_STATE
        sta     FIFO_DATA

        lda     rowY
        sta     FIFO_DATA
        lda     completedRow
        sta     FIFO_DATA
        lda     completedRow+1
        sta     FIFO_DATA
        lda     completedRow+2
        sta     FIFO_DATA
        lda     completedRow+3
        sta     FIFO_DATA
        lda     lines
        sta     FIFO_DATA
        lda     lines+1
        sta     FIFO_DATA
        lda     levelNumber
        sta     FIFO_DATA
        lda     binScore
        sta     FIFO_DATA
        lda     binScore+1
        sta     FIFO_DATA
        lda     binScore+2
        sta     FIFO_DATA
        lda     binScore+3
        sta     FIFO_DATA
        lda     nextPiece
        sta     FIFO_DATA
        lda     currentPiece
        sta     FIFO_DATA
        lda     tetriminoX
        sta     FIFO_DATA
        lda     tetriminoY
        sta     FIFO_DATA
        lda     autorepeatX
        sta     FIFO_DATA

        ; statsByType.  14
        .repeat 14,i
        lda     statsByType+i
        sta     FIFO_DATA
        .endrepeat

        ldx     #stateBytesPadding
        jmp     padCompact

sendCompactField:
        ; subtotal 8

        ; frame type 1
        lda     #COMPACT_UPDATE_FIELD
        sta     FIFO_DATA
        ; vramRow 1
        stx     FIFO_DATA

        ldy     multBy10Table,x
.repeat 40,i
        lda     playfield+i,y
        sta     FIFO_DATA
.endrepeat

        ; padding 4
        ldx     #4
padCompact:
        lda     #0
@pad:
        sta     FIFO_DATA
        dex
        bne     @pad

        ;footer 2
        lda     #>COMPACT_FOOTER
        sta     FIFO_DATA

        lda     #<COMPACT_FOOTER
        sta     FIFO_DATA

        rts


; header 2, stats 14, frame type 1, shared 6, state 17, pad 22, footer 2
; header, shared, frame type, state, stats, footer
stateBytesPadding := (54-(2+4+1+17+14+2))
.assert stateBytesPadding = 14, error, "alignment issue"
