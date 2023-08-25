applyScrolltrisUpdate:
        lda scrollTrisFlag
        beq @ret
        lda gameMode
        cmp #$04
        bne @ret
        ldx #$00
        ldy #$40
@loopThroughSprites:
; y offset
        lda oamStaging,x
        sta tmp3
        lda ppuScrollY
        cmp tmp3
        bcc @noYOffset
        lda tmp3
        sec
        sbc #$10
        sta tmp3
@noYOffset:
        lda tmp3
        clc
        sbc ppuScrollY
        sta oamStaging,x
; x offset
        lda oamStaging+3,x
        clc
        sbc ppuScrollX
        sta oamStaging+3,x
        inx
        inx
        inx
        inx
        dey
        bne @loopThroughSprites
@ret:   rts


incrementScroll:
        lda scrollTrisFlag
        beq @apply
        lda gameMode
        cmp #$04
        bne @apply
        inc ppuScrollX
        inc ppuScrollY
        lda ppuScrollY
        cmp #$F0
        bne @apply
        lda #$00                      
        sta ppuScrollY
@apply:
        lda ppuScrollX
        sta PPUSCROLL
        lda ppuScrollY
        sta PPUSCROLL
        lda currentPpuCtrl
        sta PPUCTRL
        rts
