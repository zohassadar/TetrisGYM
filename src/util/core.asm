clearPlayfield:
        lda #EMPTY_TILE
        ldx #$C8
@loop:
        sta $0400, x
        dex
        bne @loop
        rts

clearNametable:
        lda #$20
        sta PPUADDR
        lda #$0
        sta PPUADDR
        lda #EMPTY_TILE
        ldx #4
        ldy #$BF
@clearTile:
        sta PPUDATA
        dey
        bne @clearTile
        sta PPUDATA
        ldy #$FF
        dex
        bne @clearTile
        rts

drawBlackBGPalette:
        lda #$3F
        sta PPUADDR
        lda #$0
        sta PPUADDR
        ldx #$10
@loadPaletteLoop:
        lda #$F
        sta PPUDATA
        dex
        bne @loadPaletteLoop
        rts

resetScroll:
        lda #0
        sta ppuScrollX
        sta PPUSCROLL
        sta ppuScrollY
        sta PPUSCROLL
        rts

random10:
        ldx #rng_seed
        jsr generateNextPseudorandomNumber5x
        lda rng_seed
        and #$0F
        cmp #$0A
        bpl random10
        rts

; canon is waitForVerticalBlankingInterval
updateAudioWaitForNmiAndResetOamStaging:
        jsr updateAudio_jmp
        lda #$00
        sta verticalBlankingInterval
        nop

checkForNmi:
        lda verticalBlankingInterval
; label used for crash code to determine if nmi happened here or at the previous instruction
nmiLoopMidpoint:
        beq checkForNmi

.if KEYBOARD = 1
; Read Family BASIC Keyboard
        jsr pollKeyboard
.endif
resetOAMStaging:
; Hide a sprite by moving it down offscreen, by writing any values between #$EF-#$FF here.
; Sprites are never displayed on the first line of the picture, and it is impossible to place
; a sprite partially off the top of the screen.
; https://www.nesdev.org/wiki/PPU_OAM
        ldx #$00
        lda #$FF
@hideY:
        sta oamStaging,x
        inx
        inx
        inx
        inx
        bne @hideY
        rts

; 7  bit  0
; ---- ----
; BGRs bMmG
; |||| ||||
; |||| |||+- Greyscale (0: normal color, 1: greyscale)
; |||| ||+-- 1: Show background in leftmost 8 pixels of screen, 0: Hide
; |||| |+--- 1: Show sprites in leftmost 8 pixels of screen, 0: Hide
; |||| +---- 1: Enable background rendering
; |||+------ 1: Enable sprite rendering
; ||+------- Emphasize red (green on PAL/Dendy)
; |+-------- Emphasize green (red on PAL/Dendy)
; +--------- Emphasize blue

hideSpritesAndBackground:
        lda #RENDER_IDLE
        sta renderMode
        lda #0
        sta PPUMASK
        rts

showSpriteAndBackground:
        lda renderMode
        pha
        lda #RENDER_IDLE
        sta renderMode
        jsr waitForNmi
        lda #%00011110
        sta PPUMASK
        pla
        sta renderMode
        rts

updateAudioAndWaitForNmi:
        jsr updateAudio_jmp
waitForNmi:
        lda #$00
        sta verticalBlankingInterval
@checkForNmi:
        lda verticalBlankingInterval
        beq @checkForNmi
        rts

copyAddrAtReturnAddressToTmp_incrReturnAddrBy2:
        tsx
        lda stack+3,x
        sta tmpBulkCopyToPpuReturnAddr
        lda stack+4,x
        sta tmpBulkCopyToPpuReturnAddr+1
        ldy #$01
        lda (tmpBulkCopyToPpuReturnAddr),y
        sta tmp1
        iny
        lda (tmpBulkCopyToPpuReturnAddr),y
        sta tmp2
        clc
        lda #$02
        adc tmpBulkCopyToPpuReturnAddr
        sta stack+3,x
        lda #$00
        adc tmpBulkCopyToPpuReturnAddr+1
        sta stack+4,x
        rts

;reg x: zeropage addr of seed
generateNextPseudorandomNumber5x:
        jsr generateNextPseudorandomNumber
generateNextPseudorandomNumber4x:
        jsr generateNextPseudorandomNumber
generateNextPseudorandomNumber3x:
        jsr generateNextPseudorandomNumber
generateNextPseudorandomNumber2x:
        jsr generateNextPseudorandomNumber
generateNextPseudorandomNumber:
        lda tmp1,x
        eor tmp2,x
        lsr
        lsr
        ror tmp1,x
        ror tmp2,x
        lda oneThirdPRNG
        sbc #$00
        bpl @noReset
        lda #$2
@noReset:
        sta oneThirdPRNG
        rts

; reg a: value; reg x: start page; reg y: end page (inclusive)
memset_page:
        pha
        txa
        sty tmp2
        clc
        sbc tmp2
        tax
        pla
        ldy #$00
        sty tmp1
@setByte:
        sta (tmp1),y
        dey
        bne @setByte
        dec tmp2
        inx
        bne @setByte
        rts
