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
FIFO_DATA = $40F0
FIFO_STATUS =  $40F1

EMU_UNKNOWN = $40
FIFO_PENDING = $41
FIFO_IDLE = $C1

CMD_SEND_STATS = $42 ; removed
CMD_SEND_COMPACT = $43
CMD_SEND_SEED = $44 ; not yet
CMD_SEND_INPUT = $45

PAYLOAD_SIZE    = $ED

COMPACT_SIZE    = $36

COMPACT_HEADER  = $A55A
COMPACT_FOOTER  = $5AA5

COMPACT_UPDATE_STATE = $00
COMPACT_UPDATE_FIELD = $01


messageHeader:
        ; $2B = "+". $22 = CMD_USB_WR
        .BYTE $2B
        .BYTE $2B ^ $FF
        .BYTE $22
        .BYTE $22 ^ $FF

sendNTCData:
        lda     FIFO_STATUS
        cmp     #FIFO_PENDING
        beq     @checkSeed
@ret:
        rts

@checkSeed:
        lda     FIFO_DATA
        cmp     #CMD_SEND_SEED
        bne     @checkCompact
        jmp     readySeed

@checkCompact:
        cmp     #CMD_SEND_COMPACT
        beq     @sendCompact

        cmp     #CMD_SEND_INPUT
        bne     @ret

        lda     FIFO_DATA
        sta     cachedInputFromEverdrive
        lda     #$01
        sta     cachedInputFlag
        rts

@sendCompact:
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
        jmp     @sendCompactField

@sendState:
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

        lda     set_seed_input
        sta     FIFO_DATA
        lda     set_seed_input+1
        sta     FIFO_DATA
        lda     set_seed_input+2
        sta     FIFO_DATA
        lda     heartsAndReady
        sta     FIFO_DATA

        .repeat 14,i
        lda     statsByType+i
        sta     FIFO_DATA
        .endrepeat

        lda     #$00
        jmp     @pad10

@sendCompactField:
        lda     #COMPACT_UPDATE_FIELD
        sta     FIFO_DATA
        stx     FIFO_DATA

        ldy     multBy10Table,x
        .repeat 40,i
        lda     playfield+i,y
        sta     FIFO_DATA
        .endrepeat

        lda     #$00
        beq     @pad4
@pad10:
        .repeat 6
        sta     FIFO_DATA
        .endrepeat
@pad4:
        .repeat 4
        sta     FIFO_DATA
        .endrepeat

        lda     #>COMPACT_FOOTER
        sta     FIFO_DATA

        lda     #<COMPACT_FOOTER
        sta     FIFO_DATA

        rts


readySeed:
        ; ignore if game is active
        lda     gameMode
        cmp     #$04
        bne     @setSeedAndReset

        ; maybe topped out
        lda     playState
        cmp     #$0A
        beq     @setSeedAndReset

        ; maybe in high score entry screen
        lda     gameModeState
        cmp     #$03
        beq     @setSeedAndReset

        rts
@setSeedAndReset:
        ; clear stack
        ldx     #$FF
        txs

        ; level select
        lda     #$03
        sta     gameMode

        lda     #MODE_SEED
        sta     practiseType

        ; seed from controller
        lda     FIFO_DATA
        sta     set_seed_input
        lda     FIFO_DATA
        sta     set_seed_input+1
        lda     FIFO_DATA
        sta     set_seed_input+2

        ; ready 18
        lda     #8
        sta     classicLevel

        ; line cap on
        lda     #1
        sta     linecapFlag

        ; default to classic level and double killscreen
        lda     #0
        sta     linecapHow
        sta     linecapWhen
        sta     levelControlMode

        ; level 39
        lda     #INITIAL_LINECAP_LEVEL
        sta     linecapLevel

        jmp     mainLoop



; header 2, stats 14, frame type 1, shared 6, state 17, pad 22, footer 2
; header, shared, frame type, state, stats, footer
stateBytesPadding := (54-(2+4+1+17+14+2))
.assert stateBytesPadding = 14, error, "alignment issue"
