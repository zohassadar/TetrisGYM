advanceGameFloor:
        lda #0
        sta vramRow
        lda currentFloor
drawFloor:
        ; get correct offset
        tax
        ; x10
        lda #0
        sec
        sbc multBy10Table,x
        tax
        beq @skip
        ; draw block tiles+3 ($7E)
        lda #BLOCK_TILES+3
@loop:
        sta playfield-56,x
        inx
        bne @loop
@skip:
        rts
