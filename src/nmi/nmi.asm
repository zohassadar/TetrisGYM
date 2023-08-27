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
        ldy #$1E
@burn:
        dey
        bne @burn
        lda MMC5_IRQ_STATUS
        lda wtfCurrentBank
        eor #$02
        sta wtfCurrentBank
        sta MMC5_CHR_BANK0
        sta MMC5_CHR_BANK1
        lda #$80
        sta MMC5_IRQ_STATUS
        lda wtfNextScanline
        clc
        adc #$0F
        sta wtfNextScanline
        sta MMC5_IRQ_COMPARE
        pla
        tay
        pla
        tax
        pla
        rti
