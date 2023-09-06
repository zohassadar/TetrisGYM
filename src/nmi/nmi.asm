nmi:    pha
        txa
        pha
        tya
        pha
        lda #$00
        sta oamStagingLength
        jsr render
.if SUPPORTS_SCROLLTRIS
        jsr incrementScroll
.endif
        dec sleepCounter
        lda sleepCounter
        cmp #$FF
        bne @jumpOverIncrement
        inc sleepCounter
@jumpOverIncrement:
        jsr copyOamStagingToOam
        lda frameCounter
        clc
        adc #$01
        sta frameCounter
        lda #$00
        adc frameCounter+1
        sta frameCounter+1
        ldx #rng_seed
        ldy #$02
        jsr generateNextPseudorandomNumber
        jsr copyCurrentScrollAndCtrlToPPU
        lda #$01
        sta verticalBlankingInterval
        jsr pollControllerButtons
.if KEYBOARD
; Read Family BASIC Keyboard
        jsr pollKeyboard
.endif
        pla
        tay
        pla
        tax
        pla
        rti

irq:    pha
        txa
        pha
        tya
        pha
        ldy #$1A
@burn:
        dey
        bne @burn
        lda MMC5_IRQ_STATUS
        ldx wtfCurrent
        lda chrCycle,x
        sta wtfCurrent
        jsr changeCHRBank0
        lda wtfCurrent
        jsr changeCHRBank1
        lda #$80
        sta MMC5_IRQ_STATUS
        lda wtfNext
        clc
        adc #$05
        sta wtfNext
        sta MMC5_IRQ_COMPARE
        pla
        tay
        pla
        tax
        pla
        rti


; DEAD not in use.  This is a quick way to get 1->3->4->1
chrCycle:
        .byte    $DE,$03,$ED,$04,$01

resetWtfScroll:
        cli
        lda #$01
        sta wtfCurrent
        jsr changeCHRBank0
        lda wtfCurrent
        jsr changeCHRBank1
        lda #$80
        sta MMC5_IRQ_STATUS
        inc wtfCounter
        lda wtfCounter
        cmp #$80
        bne @dontReset
        lda #wtfFloor
        sta wtfCounter
@dontReset:
        lsr
        lsr
        lsr
        sta MMC5_IRQ_COMPARE
        sta wtfNext
        ; lda outOfDateRenderFlags
        ; ora #$04
        ; sta outOfDateRenderFlags
        rts