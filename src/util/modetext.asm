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
        ldx #MODE_ANYDAS*6
        lda tmp2
        sec
        sbc #33
        sta tmp2
        lda tmp1
        sbc #0
        sta tmp1
        sta PPUADDR
        lda tmp2
        sta PPUADDR

; lots of opportunity for efficiency here
        lda gameMode
        cmp #3
        beq @setupMenuAnydas
        lda gameModeState
        beq @setupGameAnydas
        rts ; skip when in high score entry screen

@setupGameAnydas:
        lda #$35
        sta PPUDATA
        jsr @startLoop
        lda #$36
        sta PPUDATA
        jmp @setupTopOfBox

@setupMenuAnydas:
        lda #$3B
        sta PPUDATA
        jsr @startLoop
        lda #$3C
        sta PPUDATA

@setupTopOfBox:
        lda tmp2
        sec
        sbc #32
        sta tmp2
        lda tmp1
        sbc #0
        sta PPUADDR
        lda tmp2
        sta PPUADDR


        ldx #7
        lda gameMode
        cmp #3
        beq @menuAnydasBoxLoop

@gameAnydasBoxLoop:
        lda topOfBoxGame,x
        sta PPUDATA
        dex
        bpl @gameAnydasBoxLoop
        rts

@menuAnydasBoxLoop:
        lda topOfBoxMenu,x
        sta PPUDATA
        dex
        bpl @menuAnydasBoxLoop
        rts



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
        lda gameMode
        cmp #3
        beq @setupGameTiles

; hack
        lda #$35
        sta PPUDATA
        lda set_seed_input
        jsr twoDigsToPPU
        lda set_seed_input+1
        jsr twoDigsToPPU
        lda set_seed_input+2
        jsr twoDigsToPPU
        lda #$36
        jmp @nextRow

@setupGameTiles:
        lda #$3B
        sta PPUDATA
        lda set_seed_input
        jsr twoDigsToPPU
        lda set_seed_input+1
        jsr twoDigsToPPU
        lda set_seed_input+2
        jsr twoDigsToPPU
        lda #$3C

@nextRow:
        sta PPUDATA
        sty PPUADDR
        txa
        clc
        adc #$20
        sta PPUADDR

        ldx #$07
        lda gameMode
        cmp #3
        beq @menuBoxLoop
@gameBoxLoop:
        lda bottomOfBoxGame,x
        sta PPUDATA
        dex
        bpl @gameBoxLoop
        rts


@menuBoxLoop:
        lda bottomOfBoxMenu,x
        sta PPUDATA
        dex
        bpl @menuBoxLoop
@ret:   rts


bottomOfBoxMenu:
        .byte $3F,$3E,$3E,$3E,$3E,$3E,$3E,$3D
bottomOfBoxGame:
        .byte $77,$37,$37,$37,$37,$37,$37,$76
topOfBoxMenu:
        .byte $3A,$39,$39,$39,$39,$39,$39,$38
topOfBoxGame:
        .byte $75,$34,$34,$34,$34,$34,$34,$74
