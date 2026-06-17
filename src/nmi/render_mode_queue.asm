render_mode_queue:
    lda #>@dump01Bytes
    sta tmp2
    tsx
    txa
    tay
    ldx #$FF
    txs
@checkLength:
    lda renderQueueLength
    bne @stripe
    jmp @end
@stripe:
    pla
    sta PPUADDR
    pla
    sta PPUADDR
    pla
    tax
    lda @queueJumpTable,x
    sta tmp1
    jmp (tmp1)
.repeat 32,i
.ident(.sprintf("@dump%02dBytes", 31-i)):
    pla
    sta PPUDATA
.endrepeat
    dec renderQueueLength
    beq @end
    jmp @checkLength
@end:
    tya
    tax
    tsx
    rts

@queueJumpTable:
.repeat 32,i
    .byte <.ident(.sprintf("@dump%02dBytes", i))
.endrepeat

.assert >@dump01Bytes=>@dump31Bytes,error,"render queue needs to exist in one page"


.struct GameRender
    paletteAddr     .word
    paletteLen      .byte
    paletteTiles    .byte 32

    scoreAddr       .word
    scoreLen        .byte
    scoreTiles      .byte 7

    linesAddr       .word
    linesLen        .byte
    linesTiles      .byte 4

    levelAddr       .word
    levelLen        .byte
    levelTiles      .byte 3

    pfield0Addr     .word
    pfield0Len      .byte
    pfield0Tiles    .byte 10
    pfield1Addr     .word
    pfield1Len      .byte
    pfield1Tiles    .byte 10
    pfield2Addr     .word
    pfield2Len      .byte
    pfield2Tiles    .byte 10
    pfield3Addr     .word
    pfield3Len      .byte
    pfield3Tiles    .byte 10
.endstruct

PALETTE_ADDR = $3f00

; placeholder values
SCORE_ADDR = $2000
LINES_ADDR = $2000
LEVEL_ADDR = $2000


initializeGameRender:
    lda #>PALETTE_ADDR
    sta stack+GameRender::paletteAddr
    lda #<PALETTE_ADDR
    sta stack+GameRender::paletteAddr+1
    lda #32
    sta stack+GameRender::paletteLen

    lda #>SCORE_ADDR
    sta stack+GameRender::scoreAddr
    lda #<SCORE_ADDR
    sta stack+GameRender::scoreAddr+1
    lda #7
    sta stack+GameRender::scoreLen

    lda #>LINES_ADDR
    sta stack+GameRender::linesAddr
    lda #<LINES_ADDR
    sta stack+GameRender::linesAddr+1
    lda #4
    sta stack+GameRender::linesLen

    lda #>LEVEL_ADDR
    sta stack+GameRender::levelAddr
    lda #<LEVEL_ADDR
    sta stack+GameRender::levelAddr+1
    lda #3
    sta stack+GameRender::levelLen

setNoPlayfieldRender:
    lda #4
    sta renderQueueLength
    lda #GameRender::pfield0Addr
    sta renderQueuePointer
    rts

resetRenderQueue:
    lda #0
    sta renderQueueLength
    sta renderQueuePointer
    rts

.out .sprintf("This is this big: %d", .sizeof(GameRender))
.out .sprintf("render queue dump: %d", *-render_mode_queue)
