displayModeText:
        ldx practiseType

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
        beq @endOfPpuPatching

        ; skip for modes where seeded doesn't apply
        lda practiseType
        cmp #MODE_TSPINS
        beq @endOfPpuPatching
        cmp #MODE_TAPQTY
        beq @endOfPpuPatching
        cmp #MODE_TAP
        beq @endOfPpuPatching
        cmp #MODE_PRESETS
        beq @endOfPpuPatching
        cmp #MODE_DROUGHT
        beq @endOfPpuPatching

        ldy #$00
@nextPpuAddress:
        lda (tmp1),y
        iny
        sta PPUADDR
        lda (tmp1),y
        iny
        sta PPUADDR
@nextPpuData:
        lda (tmp1),y
        iny
        cmp #$FC
        beq @sendSeedToPPU
        cmp #$FE
        beq @nextPpuAddress
        cmp #$FD
        beq @endOfPpuPatching
        sta PPUDATA
        jmp @nextPpuData
@sendSeedToPPU:
        lda set_seed_input
        jsr twoDigsToPPU
        lda set_seed_input+1
        jsr twoDigsToPPU
        lda set_seed_input+2
        jsr twoDigsToPPU
        jmp @nextPpuAddress
@endOfPpuPatching:
        rts


; FC - draw seed
; FE - draw next address
; FD - done
seededPiecesLevelMenu:
        .byte $20,$B5,$3B,$FC
        .byte $20,$BC,$3C,$FE
        .byte $20,$D5,$3D,$3E,$3E,$3E,$3E,$3E,$3E,$3F,$FD

seededPiecesGameMode:
        .byte $20,$A2,$3B,$FC
        .byte $20,$A9,$3C,$FE
        .byte $20,$C2,$3D,$3E,$3E,$3E,$3E,$3E,$3E,$3F,$FD
