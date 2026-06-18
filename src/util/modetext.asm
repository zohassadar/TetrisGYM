displayModeText:

        lda #$00
        sta anydasFlag
; set anydasFlag
        lda disableDasFlag
        bne @anydas
        lda noWallChargeFlag
        bne @anydas
        lda entryChargeModifier
        bne @anydas
        lda palFlag
        bne @pal

; set regional differences
        ldx #NTSC_DAS
        ldy #NTSC_ARR
        bne @testAnydas
@pal:
        ldx #PAL_DAS
        ldy #PAL_ARR

; test das & arr values
@testAnydas:
        cpx dasModifier
        bne @anydas

        cpy arrModifier
        beq @notanydas
@anydas:
        jsr @notanydas
        lda tmp2
        sec
        sbc #32
        sta tmp2
        lda tmp1
        sbc #0
        sta tmp1
        sta PPUADDR
        lda tmp2
        sta PPUADDR
        lda gameMode
        cmp #3
        bne @notMenu
        stagePatch menuAnydasPatch
        jmp render_mode_queue
@notMenu:
        lda gameModeState
        bne @ret
        stagePatch gameAnydasPatch
        jmp render_mode_queue

@notanydas:
        lda practiseType
        asl
        sta generalCounter
        asl
        clc
        adc generalCounter
        tax
@drawMode:
        lda tmp1
        sta PPUADDR
        lda tmp2
        sta PPUADDR
@startLoop:
        ldy #6
@writeChar:
        lda modeText-6, x
        sta PPUDATA
        inx
        dey
        bne @writeChar

; cover TYPE with seed if seeded b type
        lda practiseType
        cmp #MODE_TYPEB
        bne @ret
        lda typeBSeedFlag
        beq @ret
        lda tmp1
        sta PPUADDR
        lda tmp2
        clc
        adc #2
        sta PPUADDR
        lda b_seed_input
        jsr twoDigsToPPU
        lda b_seed_input+1
        jsr twoDigsToPPU
@ret:
        rts

patchSeed:
        ; skip if not seeded
        lda seedEnabled
        beq @ret
        lda seededPieces
        beq @ret
        sty PPUADDR
        stx PPUADDR

        lda set_seed_input
        jsr twoDigsToPPU
        lda set_seed_input+1
        jsr twoDigsToPPU
        lda set_seed_input+2
        jsr twoDigsToPPU
        lda gameMode
        cmp #3
        bne @notMenu
        stagePatch menuSeedPatch
        jmp render_mode_queue
@notMenu:
        lda gameModeState
        bne @ret
        stagePatch gameSeedPatch
        jmp render_mode_queue
@ret:
        rts

menuSeedPatch:
    .byte $20,$B5,$0,$3B
    .byte $20,$BC,$0,$3C
    .byte $20,$D5,$7,$3D,$3E,$3E,$3E,$3E,$3E,$3E,$3F
    .byte $0

gameSeedPatch:
    .byte $20,$A2,$0,$35
    .byte $20,$A9,$0,$36
    .byte $20,$C2,$7,$76,$37,$37,$37,$37,$37,$37,$77
    .byte $0

menuAnydasPatch:
    .byte $20,$55,$7,$38,$39,$39,$39,$39,$39,$39,$3A
    .byte $20,$75,$7,$3B,"A","N","Y","D","A","S",$3C
    .byte $0

gameAnydasPatch:
    .byte $20,$42,$7,$74,$34,$34,$34,$34,$34,$34,$75
    .byte $20,$62,$7,$35,"A","N","Y","D","A","S",$36
    .byte $0
