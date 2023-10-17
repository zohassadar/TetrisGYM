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
        lda renderMode
        cmp #$03
        bne @noCycle
        lda frameCounter
        bne @noCycle
        ldx currentTileset
        lda chrCycle,x
        sta currentTileset
        jsr changeCHRBank0
        lda currentTileset
        jsr changeCHRBank1
@noCycle:
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
irq:    rti

; This is a quick way to get 1->3->4->1
chrCycle:
        .byte    $03,$03,$03,$04,$01

