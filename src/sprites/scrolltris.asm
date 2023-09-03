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
        ; sec ; for reverse
        sbc ppuScrollY
        sta oamStaging,x
        ; inc oamStaging,x ; for reverse
; x offset
        lda oamStaging+3,x
        clc
        ; sec ; for reverse
        sbc ppuScrollX
        sta oamStaging+3,x
        ; inc oamStaging+3,x ; for reverse
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
        ; dec ppuScrollX ; reverse
        ; dec ppuScrollY ; reverse
        inc ppuScrollX
        inc ppuScrollY
        lda ppuScrollY
        ; cmp #$FF ; reverse
        cmp #$F0
        bne @apply
        ; lda #$EF ; reverse
        lda #$00                      
        sta ppuScrollY
@apply:
        lda ppuScrollX
        sta PPUSCROLL
        lda ppuScrollY
        sta PPUSCROLL
        lda currentPpuCtrl
        sta PPUCTRL
@ret:   rts
