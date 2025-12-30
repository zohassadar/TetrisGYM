; mathRAM is 18 bytes of unused zeropage
SCRATCH = mathRAM
SCRATCH2 = $80
MEMORY_BASE = $0790

MENU_TITLE_PPU = $210B
MENU_ROW_PPU = $2104

menuDataStart:
.include "menudata.asm"
.out .sprintf("Menu data: %d", *-menuDataStart)


VALUE_MASK = %00011111
TYPE_MASK = %11100000

; n = mode?
TYPE_TITLE = %00000000

BLOCK_MODE_ONLY = 1 ; unused


; tttnnnnn
; n = limit
TYPE_NUMBER = %00100000
; n = stringlist
TYPE_CHOICES = %01000000
; n = limit
TYPE_FF_OFF = %01100000

; shortcut
TYPE_BOOL = TYPE_CHOICES | STRINGLIST_BOOL

TYPE_HEX = %10000000
TYPE_BCD = %11000000

DIGIT_MASK = %10100000
DIGIT_COMPARE = %10000000

TYPE_MODE_ONLY = %10100000

; n = menu index
TYPE_SUBMENU = %11100000

MENU_STACK = $DF

gameMode_gameTypeMenu:
.if NO_MENU
    inc gameMode
    rts
.endif
    jsr updateAudioWaitForNmiAndDisablePpuRendering
    jsr disableNmi
    jsr bulkCopyToPpu
    .addr title_palette
    jsr copyRleNametableToPpu
    .addr game_type_menu_nametable
.if INES_MAPPER <> 0
    lda #CHRBankSet0
    jsr changeCHRBanks
.endif
    lda #NMIEnable
    sta currentPpuCtrl
    jsr waitForVBlankAndEnableNmi
    jsr updateAudioWaitForNmiAndResetOamStaging
    jsr updateAudioWaitForNmiAndEnablePpuRendering
    jsr updateAudioWaitForNmiAndResetOamStaging

    jsr makeNotReady

    lda #MENU_STACK
    sta menuStackPtr
    lda #$1
    sta renderMode
    lda #0
    sta activeMenu
    sta hideNextPiece
    jsr enterMenu

gameTypeLoop:

    jsr collectControls
    jsr debugSpriteStaging

;     lda newlyPressedButtons_player1
;     cmp #BUTTON_START
;     bne @wait
;     inc gameMode
;     rts
; @wait:
    jsr stageBackgroundTiles
    jsr stageCurrentValues
    jsr stageCursor
    jsr updateAudioWaitForNmiAndResetOamStaging
    jmp gameTypeLoop


enterSubMenu:
    ldy #$02
    sty soundEffectSlot1Init
    pha
    tsx
    stx generalCounter
    ldx menuStackPtr
    txs
    lda activeMenu
    pha
    lda activeItem
    pha
    lda activePage
    pha
    tsx
    stx menuStackPtr
    ldx generalCounter
    txs
    pla
enterMenu:
    tax
    stx activeMenu
    ldy firstPages,x
    sty activePage
    ldx firstItems,y
    lda itemTypes,x
    and #VALUE_MASK
    beq @normal
    inx
@normal:
    stx activeItem
    rts

exitSubmenu:
    ldy #$02
    sty soundEffectSlot1Init
    tsx
    stx generalCounter
    ldx menuStackPtr
    txs
    pla
    sta activePage
    pla
    sta activeItem
    pla
    sta activeMenu
    tsx
    stx menuStackPtr
    ldx generalCounter
    txs
    rts


collectControls:
    @digitTemp := SCRATCH2
    @digitPtr := SCRATCH2 + 1 ; 2
    @originalPage := SCRATCH2 + 3
    @originalType := SCRATCH2 + 4
    @originalCol := SCRATCH2 + 5

; activeItem, @digitTemp
    @upDownPtr := SCRATCH2 + 6 ; 2
    @upDownAdjust := SCRATCH2 + 8 ; 1 or -1
    @upDownMin := SCRATCH2 + 9
    @upDownMax := SCRATCH2 + 10

; pages, mem values, columns
    @leftRightPtr := SCRATCH2 + 12 ; 2
    @leftRightAdjust := SCRATCH2 + 14 ; 1 or -1
    @leftRightMin := SCRATCH2 + 15
    @leftRightMax := SCRATCH2 + 16

    ldx activePage
    stx @originalPage

    ldx activeItem
    lda itemTypes,x
    sta @originalType

    lda newlyPressedButtons_player1
    tax
    and #BUTTON_START | BUTTON_A ; do different things for these instead?
    beq @checkB

    ldx activeItem
    lda itemTypes,x
    and #TYPE_MASK
    cmp #TYPE_SUBMENU
    bne @checkB
    lda itemTypes,x
    and #VALUE_MASK
    tax
    jmp enterSubMenu

@checkB:
    txa
    and #BUTTON_B
    beq @checkSelect

    lda activeMenu
    beq @checkSelect
    jmp exitSubmenu

@checkSelect:
    txa
    and #BUTTON_SELECT
    beq @checkCardinals
; scramble if TYPE_DIGIT

@checkCardinals:
    lda #$00
    sta @upDownAdjust
    sta @leftRightAdjust

    lda #BUTTON_UP
    jsr menuThrottle
    beq @upNotPressed
    inc @upDownAdjust
@upNotPressed:
    lda #BUTTON_DOWN
    jsr menuThrottle
    beq @downNotPressed
    dec @upDownAdjust
@downNotPressed:
    lda #BUTTON_LEFT
    jsr menuThrottle
    beq @leftNotPressed
    dec @leftRightAdjust
@leftNotPressed:
    lda #BUTTON_RIGHT
    jsr menuThrottle
    beq @rightNotPressed
    inc @leftRightAdjust
@rightNotPressed:

; upDownConditions
    ldy activeColumn
    sty @originalCol
    beq @setupItemSelect

; setup digit input
    dey
    tya
    lsr
    tay
    php
    lda #$0
    sta @upDownMin
    sta @upDownPtr+1 ; won't work if SCRATCH is not zeropage
    lda #<@digitTemp
    sta @upDownPtr
    lda #$10
    bit @originalType ; check if bcd
    bvc @storeDigitMax
    lda #$A
@storeDigitMax:
    sta @upDownMax

    lda #>MEMORY_BASE
    sta @digitPtr+1
    ldx activeItem
    lda memoryMap,x

    sta @digitPtr
    lda (@digitPtr),y
    plp
    bcs @andAndStore

    lsr
    lsr
    lsr
    lsr
@andAndStore:
    and #$F
    sta @digitTemp
    jmp @checkLeftRightConditions

@setupItemSelect:
    ldx activePage
    ldy firstItems,x
    lda itemTypes,y
    and #TYPE_MASK
    bne @normal
    lda itemTypes,y
    and #VALUE_MASK
    beq @normal
    iny

@normal:
    sty @upDownMin
    ldy lastItems,x
    iny
    sty @upDownMax
    lda #>activeItem
    sta @upDownPtr+1
    lda #<activeItem
    sta @upDownPtr
    lda @upDownAdjust
    eor #$FF
    clc
    adc #$01
    sta @upDownAdjust

@checkLeftRightConditions:
    ldx activePage
    lda firstItems,x
    cmp activeItem
    bne @notFirstItem

; setup left right page select
    lda #>activePage
    sta @leftRightPtr+1
    lda #<activePage
    sta @leftRightPtr
    ldy activeMenu
    lda lastPages,y
    sta @leftRightMax
    lda firstPages,y
    sta @leftRightMin
    jmp @addThenCheckActivePage



@notFirstItem:
    ldx activeItem
    lda itemTypes,x
    and #DIGIT_MASK
    cmp #DIGIT_COMPARE
    bne @notColumnSelect

; setup left right column select
    lda #0
    sta @leftRightMin
    lda #>activeColumn
    sta @leftRightPtr+1
    lda #<activeColumn
    sta @leftRightPtr
    ldx activeItem
    lda itemTypes,x
    and #%1111
    tay
    iny
    sty @leftRightMax
    jmp @addThenCheckActivePage


; setup memory adjust probably
@notColumnSelect:
    lda itemTypes,x
    and #TYPE_MASK
    cmp #TYPE_SUBMENU
    beq @doNothing
    cmp #TYPE_MODE_ONLY
    beq @doNothing

    lda #>MEMORY_BASE
    sta @leftRightPtr+1
    ldx activeItem
    lda memoryMap,x
    sta @leftRightPtr
    ldy #$0
    lda itemTypes,x
    and #TYPE_MASK
    cmp #TYPE_FF_OFF
    bne @storeMin
    dey
@storeMin:
    sty @leftRightMin
    cmp #TYPE_CHOICES
    php
    lda itemTypes,x
    and #%11111
    plp
    bne @storeMax
    tax
    lda stringListCounts,x
@storeMax:
    sta @leftRightMax


    jmp @addThenCheckActivePage
@doNothing:
    lda #$00
    sta @leftRightAdjust


@addThenCheckActivePage:
    jsr addInputs

    ldy @originalCol
    beq @noRePack
    dey
    tya
    lsr
    tay
    bcs @smallDigit
    lda (@digitPtr),y
    and #$0F
    sta (@digitPtr),y
    lda @digitTemp
    asl
    asl
    asl
    asl
    ora (@digitPtr),y
    sta (@digitPtr),y

    jmp @noRePack
@smallDigit:
    lda (@digitPtr),y
    and #$F0
    ora @digitTemp
    sta (@digitPtr),y
@noRePack:

    ldx activePage
    cpx @originalPage
    beq @ret
    lda firstItems,x
    sta activeItem

@ret:
    rts




addInputs:
    ldx #0 ; upDown
    jsr @doActualAdd
    ldx #6 ; leftRight
@doActualAdd:
    @ptr = SCRATCH2 + 6 ; 2
    @adjust = SCRATCH2 + 8 ; 1 or -1
    @min = SCRATCH2 + 9 ; actual minimum
    @max = SCRATCH2 + 10 ; 1 above actual maximum
    lda @adjust,x
    beq @ret
    clc
    adc (@ptr,x)
    sta (@ptr,x)
    ldy @max,x
    beq @sfx ; 0 means unlimited.  expected values 2-31
    cmp @max,x
    beq @rollToMin
    clc
    adc #$1
    cmp @min,x
    bne @sfx
    ldy @max,x
    dey
    tya
    bne @storeDigit
@rollToMin:
    lda @min,x
@storeDigit:
    sta (@ptr,x)
@sfx:
    lda #$01
    sta soundEffectSlot1Init
@ret:
    rts


stageBackgroundTiles:
    @stackPtr = SCRATCH
    @stringPtr = SCRATCH+2
    @ppuAddr = SCRATCH+4
    @counter = SCRATCH+16
    @renderItem = SCRATCH+17

    ldx activePage
    lda firstItems,x
    sta @renderItem

    lda #>stack
    sta @stackPtr+1
    ldx #$00
    lda #>MENU_TITLE_PPU
    sta stack,x
    inx
    lda #<MENU_TITLE_PPU
    sta stack,x
    inx
    lda #>MENU_ROW_PPU
    sta @ppuAddr+1
    lda #<MENU_ROW_PPU
    sta @ppuAddr
    stx @stackPtr
    jsr @draw16BlanksToStackPlusX
    jsr @drawStringToStackBuffer
    ldy #$8
@nextRow:
    clc
    lda @ppuAddr
    adc #$40
    sta @ppuAddr
    sta stack+1,x
    lda #$00
    adc @ppuAddr+1
    sta @ppuAddr+1
    sta stack,x
    inx
    inx
    stx @stackPtr
    jsr @draw16BlanksToStackPlusX
    jsr @drawStringToStackBuffer
    dey
    bne @nextRow
    rts

@draw16BlanksToStackPlusX:
    lda #$10
    sta @counter
    lda #$FF
@nextTile:
    sta stack,x
    inx
    dec @counter
    bne @nextTile
    rts

@drawStringToStackBuffer:
    txa
    pha
    tya
    pha
    ldy #$00

    ldx activePage
    lda lastItems,x
    cmp @renderItem
    bcc @noString

    ldx @renderItem
    inc @renderItem
    lda stringListLo,x
    sta @stringPtr
    lda stringListHi,x
    sta @stringPtr+1

; store length then bump pointer so y can start loop at 0
    lda (@stringPtr),y
    beq @noString ; allow for blank strings
    tax
    inc @stringPtr
    bne @copy
    inc @stringPtr+1
@copy:
    lda (@stringPtr),y
    sta (@stackPtr),y
    iny
    dex
    bne @copy

@noString:
    pla
    tay
    pla
    tax
@ret:
    rts

stageCurrentValues:
    @counter = SCRATCH
    @stageItem = SCRATCH + 1
    @lastItem = SCRATCH + 2
    @bcdIndex = SCRATCH + 3
    @stringList = SCRATCH + 14 ; 2
    @memoryIndex = SCRATCH + 16 ; 2
    lda #>MEMORY_BASE
    sta @memoryIndex+1
    ldx activePage
    lda firstItems,x
    cmp lastItems,x
    bne @stageValues
    rts
@stageValues:
    tay
    iny
    sty @stageItem
    lda lastItems,x
    sta @lastItem

    lda #$00
    sta @counter

@memoryStageLoop:
    lda @counter
    asl
    asl
    asl
    asl
    clc
    adc #$50
    sta spriteYOffset
    lda #$B0
    sta spriteXOffset

    lda @stageItem
    clc
    adc @counter
    tay
    lda memoryMap,y
    sta @memoryIndex
    lda itemTypes,y
    tax
    ldy #0
    and #TYPE_MASK
    bmi @digitInputOrEdge

    cmp #TYPE_CHOICES
    beq @drawString

    cmp #TYPE_NUMBER
    beq @drawNumber

; set bool stringlist
    lda (@memoryIndex),y
    bpl @drawNumber
    ldx #0
    jsr @setStringList
    jmp @pullFromStringList

@drawString:
    txa
    and #%11111
    tax
    jsr @setStringList
    lda (@memoryIndex),y
    tay
@pullFromStringList:
    lda (@stringList),y
    jsr stringSpriteAlignRightA

    jmp @nextByte

@setStringList:
    lda stringListIndexes,x
    clc
    adc #<stringLists
    sta @stringList
    lda #$00
    adc #>stringLists
    sta @stringList+1
    rts

@digitInputOrEdge:
    and #TYPE_MASK
    cmp #TYPE_MODE_ONLY
    beq @nextByte
    cmp #TYPE_SUBMENU
    beq @nextByte
    txa
    and #%11111
    sec
    sbc #1
    lsr
    sta generalCounter
    ldy #$00
@bcdInput:
    lda (@memoryIndex),y
    jsr drawByteToOamStaging
    lda spriteXOffset
    clc
    adc #$10
    sta spriteXOffset
    iny
    dec generalCounter
    bpl @bcdInput
    bmi @nextByte

@drawNumber:
    lda (@memoryIndex),y

@stageSprite:
    jsr drawByteToOamStaging

@nextByte:
    inc @counter
    lda @counter
    clc
    adc @stageItem
    sec
    sbc @lastItem
    cmp #1
    beq @ret
    jmp @memoryStageLoop
@ret:
    rts


stageCursor:
    ldx activePage
    lda activeItem
    sec
    sbc firstItems,x
    bne @notTitle

    lda #$3F
    sta spriteYOffset
    lda #$10
    sta spriteXOffset
    lda #$23 ; page select
    sta spriteIndexInOamContentLookup
    jmp @stage

@notTitle:
    asl
    asl
    asl
    asl
    clc
    adc #$3F
    sta spriteYOffset
; digit input
    ldx activeColumn
    beq @notColumn
    sec
    sbc #$09
    sta spriteYOffset
    txa
    asl
    asl
    asl
    clc
    adc #$A9
    sta spriteXOffset
    lda #$1B  ; digit select
    bne @store
@notColumn:
    lda #$14
    sta spriteXOffset
    lda #$1D  ; option select
@store:
    sta spriteIndexInOamContentLookup
@stage:
    jmp loadSpriteIntoOamStaging
gotoEdgeCase:
    rts

drawByteToOamStaging:
    ldx oamStagingLength
; tile
    pha
    lsr
    lsr
    lsr
    lsr
    sta oamStaging+1,x
    pla
    and #$F
    sta oamStaging+5,x
; y
    lda spriteYOffset
    sta oamStaging,x
    sta oamStaging+4,x
; attr
    lda #$00
    sta oamStaging+2,x
    sta oamStaging+6,x
; x
    lda spriteXOffset
    sta oamStaging+3,x
    clc
    adc #$08
    sta oamStaging+7,x

; bump length
    txa
    clc
    adc #$8
    sta oamStagingLength

    rts


render_mode_menu:
    tsx
    txa
    ldx #$ff
    txs
    tax
    ldy #$9
@nextRow:
    pla
    sta PPUADDR
    pla
    sta PPUADDR
    .repeat 16
    pla
    sta PPUDATA
    .endrepeat
    dey
    bne @nextRow
    txs
    rts


debugSpriteStaging:
    lda #$30
    sta spriteYOffset

    lda #$A8
    sta spriteXOffset
    lda activeMenu
    jsr drawByteToOamStaging

    lda #$B8
    sta spriteXOffset
    lda activePage
    jsr drawByteToOamStaging

    lda #$C8
    sta spriteXOffset
    lda activeItem
    jsr drawByteToOamStaging

    lda #$D8
    sta spriteXOffset
    lda activeColumn
    jmp drawByteToOamStaging



menuEnd:

.out .sprintf("Menu code: %d", *-gameMode_gameTypeMenu)
