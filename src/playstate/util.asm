isPositionValid:
        ; carry clear when valid
        lda currentPiece
        asl a
        asl a
        tax
        lda #$04
        sta generalCounter3
        clc ; carry only needs to be cleared entering loop
@checkSquare:
        ; validate y
        lda orientationYOffsets,x
        adc tetriminoY
        cmp yLimit
        bcs @ret ; y >= 20
        tay ; Used to get y * 10

        ; validate x
        lda orientationXOffsets,x
        adc tetriminoX
        cmp xLimit
        bcs @ret  ; x < 0 || x >= 10

        ; validate pos in playfield
        adc (multTableLo),y
        sta sramPlayfield
        lda #$00
        adc (multTableHi),y
        sta sramPlayfield+1

        lda #>SRAM_playfield
        clc
        adc sramPlayfield+1
        sta sramPlayfield+1
        ldy #$00
        lda #EMPTY_TILE-1
        cmp (sramPlayfield),y
        bcs @ret ; Tile found in playfield
        inx
        dec generalCounter3
        bne @checkSquare
@ret:   rts

updatePlayfield:
        ldx tetriminoY
        dex
        dex
        dex
        dex
        txa
        bpl @rowInRange
        lda #$00
@rowInRange:
        ldx currentSize
        cpx #MODE_SMALL
        bne @notSmall
        lsr
        jmp @compare
@notSmall:
        cpx #MODE_BIG
        bne @compare
        asl
@compare:
        and #$FC
        sta vramRow
@ret:   rts

updateMusicSpeed:
;         ldx #$05
;         lda multBy10Table,x
;         tay
;         ldx #$0A
; @checkForBlockInRow:
;         lda (playfieldAddr),y
;         cmp #EMPTY_TILE
;         bne @foundBlockInRow
;         iny
;         dex
;         bne @checkForBlockInRow
;         lda allegro
;         beq @ret
;         lda #$00
;         sta allegro
;         ldx musicType
;         lda musicSelectionTable,x
;         jsr setMusicTrack
;         jmp @ret

; @foundBlockInRow:
;         lda allegro
;         bne @ret
;         lda #$FF
;         sta allegro
;         lda musicType
;         clc
;         adc #$04
;         tax
;         lda musicSelectionTable,x
;         jsr setMusicTrack
@ret:   rts


; canon is adjustMusicSpeed
setMusicTrack:
.if !NO_MUSIC
        sta musicTrack
        lda gameMode
        cmp #$05
        bne @ret
        lda #$FF
        sta musicTrack
.endif
@ret:   rts
