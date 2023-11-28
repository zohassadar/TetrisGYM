EMU_UNKNOWN :=  $40
FIFO_PENDING := $41
FIFO_IDLE :=    $C1
CMD_SEND_STATS := $42
CMD_SEND_COMPACT := $43

PAYLOAD_SIZE = $ed

COMPACT_SIZE = $40

COMPACT_HEADER = $A55A
COMPACT_FOOTER = $5AA5
COMPACT_UPDATE_STATE = $00
COMPACT_UPDATE_FIELD = $01


; FIFO_DATA reads unpredictable value when FIFO_STATUS != FIFO_PENDING
FIFO_DATA :=    $40f0
FIFO_STATUS :=  $40f1

messageHeader:
        ; $2b = "+". $22 = CMD_USB_WR
        .byte   $2b, $2b ^ $ff, $22, $22 ^ $ff

receiveNTCRequest:
; todo: compare to FIFO_PENDING instead and test
        lda     FIFO_STATUS
        cmp     #EMU_UNKNOWN
        beq     @ret
        cmp     #FIFO_IDLE
        beq     @ret
        lda     FIFO_DATA
        sta     ntcRequest
        jmp     receiveNTCRequest
@ret:   rts

; needed for nestrischamps:
; gameStartGameMode 1 (4 bits each)
; gameModeStatePlayState 1 (4 bits each)
; rowY 1
; completedRow 4
; lines 2 (bcd)
; levelNumber 1
; binScore 4
; nextPiece 1
; currentPiece 1
; tetriminoX 1 Needed to determine where piece is in playfield
; tetriminoY 1 same
; frameCounter 2 Used for line clearing animation
; autoRepeatX 1 current DAS
; statsByType 14
; playfield 200
; subtotal 235/0xeb

; footer : 2 * $AA
; Total 237/0xed

; needed on c# side:
; tetriminoTypeFromOrientation
; orientationTable



sendNTCData:
        lda     ntcRequest
        cmp     #CMD_SEND_STATS
        beq     @sendStats
        cmp     #CMD_SEND_COMPACT
        bne     @ret
        jmp     sendNTCDataCompact
@ret:   rts
@sendStats:
        lda     messageHeader
        sta     FIFO_DATA
        lda     messageHeader+1
        sta     FIFO_DATA
        lda     messageHeader+2
        sta     FIFO_DATA
        lda     messageHeader+3
        sta     FIFO_DATA

        lda     #PAYLOAD_SIZE     ; Length.  16 bit LE
        sta     FIFO_DATA
        lda     #$00
        sta     FIFO_DATA

        ; gameStartGameMode. 1
        lda     ntcGameStart
        asl
        asl
        asl
        asl
        ora     gameMode
        sta     FIFO_DATA

        ; gameModeStatePlayState. 1
        lda     gameModeState
        asl
        asl
        asl
        asl
        ora     playState
        sta     FIFO_DATA

        ; rowY. 1
        lda     rowY
        sta     FIFO_DATA

        ; completedRow.  4
        lda     completedRow
        sta     FIFO_DATA
        lda     completedRow+1
        sta     FIFO_DATA
        lda     completedRow+2
        sta     FIFO_DATA
        lda     completedRow+3
        sta     FIFO_DATA

        ; lines.  2
        lda     lines
        sta     FIFO_DATA
        lda     lines+1
        sta     FIFO_DATA

        ; level. 1
        lda     levelNumber
        sta     FIFO_DATA

        ; score.  4
        lda     binScore
        sta     FIFO_DATA
        lda     binScore+1
        sta     FIFO_DATA
        lda     binScore+2
        sta     FIFO_DATA
        lda     binScore+3
        sta     FIFO_DATA

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

        ; frameCounter.  2
        lda     frameCounter
        sta     FIFO_DATA
        lda     frameCounter+1
        sta     FIFO_DATA

        ; autorepeatX.  1
        lda     autorepeatX
        sta     FIFO_DATA

        ; statsByType.  14
        lda     statsByType
        sta     FIFO_DATA
        lda     statsByType+1
        sta     FIFO_DATA
        lda     statsByType+2
        sta     FIFO_DATA
        lda     statsByType+3
        sta     FIFO_DATA
        lda     statsByType+4
        sta     FIFO_DATA
        lda     statsByType+5
        sta     FIFO_DATA
        lda     statsByType+6
        sta     FIFO_DATA
        lda     statsByType+7
        sta     FIFO_DATA
        lda     statsByType+8
        sta     FIFO_DATA
        lda     statsByType+9
        sta     FIFO_DATA
        lda     statsByType+10
        sta     FIFO_DATA
        lda     statsByType+11
        sta     FIFO_DATA
        lda     statsByType+12
        sta     FIFO_DATA
        lda     statsByType+13
        sta     FIFO_DATA

        ; playfield.  200
        ldy     #(256-20) ; use offset to prevent needing cpy
@playfieldChunk:
        ldx     multBy10Table - (256-20),y
        lda     playfield,x
        sta     FIFO_DATA
        lda     playfield+1,x
        sta     FIFO_DATA
        lda     playfield+2,x
        sta     FIFO_DATA
        lda     playfield+3,x
        sta     FIFO_DATA
        lda     playfield+4,x
        sta     FIFO_DATA
        lda     playfield+5,x
        sta     FIFO_DATA
        lda     playfield+6,x
        sta     FIFO_DATA
        lda     playfield+7,x
        sta     FIFO_DATA
        lda     playfield+8,x
        sta     FIFO_DATA
        lda     playfield+9,x
        sta     FIFO_DATA
        lda     playfield+10,x
        sta     FIFO_DATA
        lda     playfield+11,x
        sta     FIFO_DATA
        lda     playfield+12,x
        sta     FIFO_DATA
        lda     playfield+13,x
        sta     FIFO_DATA
        lda     playfield+14,x
        sta     FIFO_DATA
        lda     playfield+15,x
        sta     FIFO_DATA
        lda     playfield+16,x
        sta     FIFO_DATA
        lda     playfield+17,x
        sta     FIFO_DATA
        lda     playfield+18,x
        sta     FIFO_DATA
        lda     playfield+19,x
        sta     FIFO_DATA
        iny
        iny
        bne     @playfieldChunk


@addFooter:
        lda     #$AA
        sta     FIFO_DATA
        sta     FIFO_DATA
        lda     #$00
        sta     ntcRequest
        rts


sendNTCDataCompact:
        lda     messageHeader
        sta     FIFO_DATA
        lda     messageHeader+1
        sta     FIFO_DATA
        lda     messageHeader+2
        sta     FIFO_DATA
        lda     messageHeader+3
        sta     FIFO_DATA

        lda     #COMPACT_SIZE     ; Length.  16 bit LE
        sta     FIFO_DATA
        lda     #$00
        sta     FIFO_DATA
        
; options for both kinds of updates
        ; header 2
        lda    #>COMPACT_HEADER
        sta    FIFO_DATA

        lda    #<COMPACT_HEADER
        sta    FIFO_DATA

        ; frameCounter.  2
        lda     frameCounter
        sta     FIFO_DATA
        lda     frameCounter+1
        sta     FIFO_DATA

        ; gameModeStatePlayState. 1
        lda     gameModeState
        asl
        asl
        asl
        asl
        ora     playState
        sta     FIFO_DATA

        ldx     vramRow
        cpx     #$20   ; send game data when playfield isn't rendering
        beq     @sendState
        lda     playstate
        cmp     #$04   ; send game data when animation is showing
        beq     @sendState
        jmp     sendCompactField
@sendState:
        ; subtotal 5

        ; frame type 1
        lda     #COMPACT_UPDATE_STATE
        sta     FIFO_DATA

        ; gameStartGameMode. 1
        lda     ntcGameStart
        asl
        asl
        asl
        asl
        ora     gameMode
        sta     FIFO_DATA

        ; rowY. 1
        lda     rowY
        sta     FIFO_DATA

        ; completedRow.  4
        lda     completedRow
        sta     FIFO_DATA
        lda     completedRow+1
        sta     FIFO_DATA
        lda     completedRow+2
        sta     FIFO_DATA
        lda     completedRow+3
        sta     FIFO_DATA

        ; lines.  2
        lda     lines
        sta     FIFO_DATA
        lda     lines+1
        sta     FIFO_DATA

        ; level. 1
        lda     levelNumber
        sta     FIFO_DATA

        ; score.  4
        lda     binScore
        sta     FIFO_DATA
        lda     binScore+1
        sta     FIFO_DATA
        lda     binScore+2
        sta     FIFO_DATA
        lda     binScore+3
        sta     FIFO_DATA

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

        ; autorepeatX.  1
        lda     autorepeatX
        sta     FIFO_DATA

        ; statsByType.  14
        lda     statsByType
        sta     FIFO_DATA
        lda     statsByType+1
        sta     FIFO_DATA
        lda     statsByType+2
        sta     FIFO_DATA
        lda     statsByType+3
        sta     FIFO_DATA
        lda     statsByType+4
        sta     FIFO_DATA
        lda     statsByType+5
        sta     FIFO_DATA
        lda     statsByType+6
        sta     FIFO_DATA
        lda     statsByType+7
        sta     FIFO_DATA
        lda     statsByType+8
        sta     FIFO_DATA
        lda     statsByType+9
        sta     FIFO_DATA
        lda     statsByType+10
        sta     FIFO_DATA
        lda     statsByType+11
        sta     FIFO_DATA
        lda     statsByType+12
        sta     FIFO_DATA
        lda     statsByType+13
        sta     FIFO_DATA
        ; subtotal 38

        ; padding 24
        ldx     #24
        jmp     padCompact



sendCompactField:
        ; subtotal 5

        ; frame type 1
        lda     #COMPACT_UPDATE_FIELD
        sta     FIFO_DATA
        ; vramRow 1
        stx     FIFO_DATA

        ldy     multBy10Table,x

        ; playfield 40
        ldx     #40
@sendFieldByte:
        lda     playfield,y
        sta     FIFO_DATA
        iny
        dex
        bne     @sendFieldByte

        ; padding 15
        ldx     #15
padCompact:
        lda     #0
@pad:
        sta     FIFO_DATA
        dex
        bne     @pad

        ;footer 2
        lda    #>COMPACT_FOOTER
        sta    FIFO_DATA

        lda    #<COMPACT_FOOTER
        sta    FIFO_DATA

        rts
