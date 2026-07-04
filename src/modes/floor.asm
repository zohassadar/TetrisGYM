initGameFloor:
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

drawFloorTopRow:
        lda #$14
        sec
        sbc currentFloor
        cmp #$14  ; skip floor 0
        beq @ret
        tax
        ldy multBy10Table,x
        ldx #$0A
        lda #BLOCK_TILES+3
@drawFloorSurface:
        sta playfield,y
        iny
        dex
        bne @drawFloorSurface
@ret:
        rts
