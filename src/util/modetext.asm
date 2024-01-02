displayModeText:
        ldx practiseType
        ; cpx #MODE_SEED
        ; bne @drawModeName
        ; ; draw seed instead
        ; lda tmp1
        ; sta PPUADDR
        ; lda tmp2
        ; sta PPUADDR
        ; lda set_seed_input
        ; jsr twoDigsToPPU
        ; lda set_seed_input+1
        ; jsr twoDigsToPPU
        ; lda set_seed_input+2
        ; jsr twoDigsToPPU
        ; rts

@drawModeName:
        ; ldx practiseType
        lda #0
@loopAddr:
        cpx #0
        beq @addr
        clc
        adc #6
        dex
        jmp @loopAddr
@addr:
        ; offset in X
        tax

        lda tmp1
        sta PPUADDR
        lda tmp2
        sta PPUADDR

        ldy #6
@writeChar:
        lda modeText, x
        sta PPUDATA
        inx
        dey
        bne @writeChar
        rts


patchSeed:
        ; skip if not seeded
        lda seededPieces
        beq @ret
        sty PPUADDR
        stx PPUADDR
        lda #$3B
        sta PPUDATA
        lda set_seed_input
        jsr twoDigsToPPU
        lda set_seed_input+1
        jsr twoDigsToPPU
        lda set_seed_input+2
        jsr twoDigsToPPU
        lda #$3C
        sta PPUDATA
        sty PPUADDR
        txa
        clc
        adc #$20
        sta PPUADDR
        ldx #$07
@boxLoop:
        lda bottomOfBox,x
        sta PPUDATA
        dex
        bpl @boxLoop
@ret:   rts


bottomOfBox:
        .byte $3F,$3E,$3E,$3E,$3E,$3E,$3E,$3D

