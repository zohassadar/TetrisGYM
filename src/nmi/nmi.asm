nmi:    pha
        txa
        pha
        tya
        pha
        jsr render
        jsr copyCurrentScrollAndCtrlToPPU
        jsr copyOamStagingToOam
        lda sleepCounter
        beq @noSleep
        dec sleepCounter
        inc frameCounter
        bne @noCarry
@noSleep:
        inc frameCounter+1
@noCarry:
        ldx #rng_seed
        jsr generateNextPseudorandomNumber
        jsr pollControllerButtons
        lda #$00
        sta oamStagingLength
        sta lagState ; clear flag after lag frame achieved
.if KEYBOARD
; Read Family BASIC Keyboard
        jsr pollKeyboard
.endif
        lda #$01
        sta verticalBlankingInterval
        pla
        tay
        tsx
        lda stack+4,x
        sta nmiReturnAddr
        pla
        tax
        pla
irq:    rti
