nmi:    pha
        txa
        pha
        tya
        pha
        jsr render
        jsr copyCurrentScrollAndCtrlToPPU
        lda #$00
        sta OAMADDR
        lda #$02
        sta OAMDMA
        lda sleepCounter
        beq :+
        dec sleepCounter
:
        inc frameCounter
        bne :+
        inc frameCounter+1
:
        ldx #rng_seed
        jsr generateNextPseudorandomNumber
        jsr pollControllerButtons
.if KEYBOARD
; Read Family BASIC Keyboard
        jsr pollKeyboard
.endif
        ldy #$00
        sty oamStagingLength
        sty lagState ; clear flag after lag frame achieved
        iny          ; quick 1
        sty verticalBlankingInterval
        pla
        tay
        tsx
        lda stack+4,x
        sta nmiReturnAddr
        pla
        tax
        pla
irq:    rti
