nmi:    pha
        txa
        pha
        tya
        pha
        lda #$00
        sta oamStagingLength
        jsr render
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


chrCycle:
        .byte    $DE,$03,$ED,$04,$05,$01