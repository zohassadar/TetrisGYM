multBy10Table:
        .byte   $00,$0A,$14,$1E,$28,$32,$3C,$46
        .byte   $50,$5A,$64,$6E,$78,$82,$8C,$96
        .byte   $A0,$AA,$B4,$BE,$C8,$D2,$DC
multBy32Table:
        .byte 0,32,64,96,128,160,192,224
multBy100Table:
        .byte $0, $64, $c8, $2c, $90
        .byte $f4, $58, $bc, $20, $84

multBy5Table:
        .byte   $00,$05,$0a,$0f,$14,$19,$1e,$23
        .byte   $28,$2d,$32,$37,$3C

multBy10HiByte:
multBy5HiByte:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00

multBy20Table:
        .byte   $00,$14,$28,$3c,$50,$64,$78,$8c
        .byte   $a0,$b4,$c8,$dc,$f0,$04,$18,$2c
        .byte   $40,$54,$68,$7c,$90,$a4,$b8,$cc
        .byte   $e0,$f4,$08,$1c,$30,$44,$58,$6c
        .byte   $80,$94,$a8,$bc,$d0,$e4,$f8,$0c
        .byte   $20,$34,$48

multBy20HiByte:
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$01,$01,$01
        .byte   $01,$01,$01,$01,$01,$01,$01,$01
        .byte   $01,$01,$02,$02,$02,$02,$02,$02
        .byte   $02,$02,$02,$02,$02,$02,$02,$03
        .byte   $03,$03,$03

multTablesLoHi:
        .byte >multBy20Table, >multBy10Table, >multBy5Table
multTablesLoLo:
        .byte <multBy20Table, <multBy10Table, <multBy5Table

multTablesHiHi:
        .byte >multBy20HiByte, >multBy10HiByte, >multBy5HiByte
multTablesHiLo:
        .byte <multBy20HiByte, <multBy10HiByte, <multBy5HiByte


yLimits:
        .byte $2A,$16,$0C

xLimits:
        .byte $14,$0A,$05

xStartingPositions:
        .byte $0A,$05,$02
spriteDoubleCount:
        .byte $02,$03,$04

yOffsets:
        .byte 39, 31, 15

setModeValues:
        ldx practiseType
        lda multTablesLoLo,x
        sta multTableLo
        lda multTablesLoHi,x
        sta multTableLo+1
        lda multTablesHiLo,x
        sta multTableHi
        lda multTablesHiHi,x
        sta multTableHi+1
        lda yLimits,x
        sta yLimit
        lda xLimits,x
        sta xLimit
        lda xStartingPositions,x
        sta xStart
        lda spriteDoubleCount,x
        sta spriteDoubles
        lda yOffsets,x
        sta yOffset
        rts





resetPlayfields:
        lda #EMPTY_TILE
        ldx #>playfield
        ldy #>playfield ; used to be 5, but we dont need to clear 2p playfield
        jsr memset_page
        ldx #>SRAM_playfield
        ldy #>SRAM_playfield+3
        lda #EMPTY_TILE
        jmp memset_page


moveBigPlayfieldToRenderPage:
        lda vramRow
        lsr
        tay
        ldx multBy5Table,y

        ldy vramRow
        lda multBy10Table,y
        tay
        lda #$A
        sta generalCounter
@pieceLoop:
        lda SRAM_playfield+10,x
        bmi @loop
        clc
        adc #$10
        sta playfield,y
        adc #$10
        sta playfield+1,y
        adc #$10
        sta playfield+10,y
        adc #$10
        sta playfield+11,y
@loop:
        iny
        iny
        inx
        dec generalCounter
        beq @endLoop
        lda generalCounter
        cmp #$5
        bne @pieceLoop
        tya
        clc
        adc #$0A
        tay
        jmp @pieceLoop
@endLoop:
        jsr updateAudioWaitForNmiAndResetOamStaging
        jmp mainLoop


yStorage = generalCounter
rowCounter = generalCounter2
columnCounter = generalCounter3
plantedTile = generalCounter4




moveSmallPlayfieldToRenderPage:
        lda #$04
        sta rowCounter
        ldy vramRow
        ldx multBy10Table,y
        lda vramRow
        asl
        tay
        iny
        iny
@newRow:
        lda multBy20Table,y
        sta sramPlayfield
        lda multBy20HiByte,y
        clc
        adc #>SRAM_playfield
        sta sramPlayfield+1
        iny
        lda multBy20Table,y
        sta sramPlayfieldBR
        lda multBy20HiByte,y
        clc
        adc #>SRAM_playfield
        sta sramPlayfieldBR+1
        iny
        sty generalCounter

        lda #$0A
        sta columnCounter

        ldy #$00

@innerLoop:
        lda #$C0
        sta plantedTile

        lda (sramPlayfield),y
        bmi @noTile
        lda #$01
        ora plantedTile
        sta plantedTile
@noTile:
        lda (sramPlayfieldBR),y
        bmi @noTile2
        lda #$04
        ora plantedTile
        sta plantedTile
@noTile2:
        iny
        lda (sramPlayfield),y
        bmi @noTile3
        lda #$02
        ora plantedTile
        sta plantedTile
@noTile3:
        lda (sramPlayfieldBR),y
        bmi @noTile4
        lda #$08
        ora plantedTile
        sta plantedTile
@noTile4:
        lda plantedTile
        sta playfield,x
        inx
        iny
        dec columnCounter
        bne @innerLoop

        dec rowCounter
        beq @endLoop

        ldy generalCounter
        jmp @newRow

@endLoop:
        jsr updateAudioWaitForNmiAndResetOamStaging
        jmp mainLoop 




moveMediumPlayfieldToRenderPage:
        ldy #$C8
        ldx #$00
@copyLoop:
        lda SRAM_playfield+20,x
        sta playfield,x
        inx
        dey
        bne @copyLoop

        jsr updateAudioWaitForNmiAndResetOamStaging
        jmp mainLoop

playfieldBytesToCopy:
        .byte 119, 39, 19

andValueForTetriminoY:
        .byte $FE,$FF,$FF ; start at nearest even number

maskValueForTetriminoY:
        .byte $01,$00,$00 ; start at nearest even number


copyPlayfieldToBuffer:
        ldx practiseType
        lda tetriminoY
        and andValueForTetriminoY,x
        tay
        cpy #$02
        bcs @yInRange
        ldy #$02
@yInRange:
        dey
        dey
        lda (multTableLo),y
        sta sramPlayfield
        clc
        lda #>SRAM_playfield
        adc (multTableHi),y
        sta sramPlayfield+1

        ldx practiseType
        ldy playfieldBytesToCopy,x
        
@copyLoop:
        lda (sramPlayfield),y
        sta SRAM_clearbuffer,y
        dey
        bpl @copyLoop ; works only because max expected is 119

        ; todo Fix this!!
        lda tetriminoY
        clc
        adc #$02
        sta rowBottom ; where uncleared rows goe
        sec
        sbc #$04
        sta rowTop ; increases for every line cleared
        sec
        sbc #$01
        sta rowBeingMoved

        rts

; '01111011'
; '01111100'
; '01111101'
; '11101111'