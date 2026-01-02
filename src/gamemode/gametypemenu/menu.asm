; to do
; get into game
; do arbitrary action
; get back into menu from game or level menu
; get back into menu from game w/block tool on
; each title associated with action
; memorylabel as input
; shared memory labels between options
; more sanity checks
; set defaults
; save/restore to/from sram


MEMORY_BASE = $0500

; valid background chars are 0-253
EOL = $FE
EOF = $FF

MENU_TITLE_PPU = $2104
MENU_STRIPE_WIDTH = 22
MENU_ROWS = 9

MODE_DEFAULT = 0

menuDataStart:
.include "menudata.asm"
.out .sprintf("Menu data: %d", *-menuDataStart)

; t.. mmmmm t = page type m = mode
PAGE_MULTI = %10000000
PAGE_SINGLE = %00000000

; table of first items instead
; + table of item counts

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
    lda #>MEMORY_BASE
    sta byteSpriteAddr+1
    lda #$1
    sta renderMode
    lda #0
    sta hideNextPiece
    sta byteSpriteTile
    jsr enterMenu
gameTypeLoop:
    ; todo: write down which vars are used by which func
    jsr collectControllerInput
    jsr setScratch
    jsr addInputs
    jsr respondToInput

    jsr stageCursor
    jsr stageCurrentValues

    ; scratch is not important anymore
    jsr stageBackgroundTiles
    jsr debugSpriteStaging
    jsr updateAudioWaitForNmiAndResetOamStaging
    jmp gameTypeLoop


.out .sprintf("bg setup & loop: %d", *-gameMode_gameTypeMenu)

enterSubMenu:
    ldy #$02
    sty soundEffectSlot1Init
    pha
    tsx
    stx stackPtr
    ldx menuStackPtr
    txs
    lda activeRow
    pha
    lda activePage
    pha
    lda activeMenu
    pha
    tsx
    stx menuStackPtr
    ldx stackPtr
    txs
    pla
enterMenu:
    sta activeMenu
    tax
    lda firstPages,x
enterPage:
    sta activePage
    sta originalPage
    tax

    lda pageTypes,x
    and #VALUE_MASK
    sta unpackedPageValue

    ldy #$00
    sty activeColumn
    lda pageTypes,x
    and #TYPE_MASK
    sta unpackedPageType
    bpl @storeRow
    dey ; start at page select row for multipage
@storeRow:

    sty activeRow

setScratch:
    ldx activePage
    lda activeRow
    clc
    adc firstItems,x
    sta activeItem
    tax
    lda itemTypes,x
    tay
    and #VALUE_MASK
    sta unpackedItemValue

    tya
    and #TYPE_MASK
    sta unpackedItemType

    jsr setupLR
    jmp setupUD


exitSubmenu:
    ldy #$02
    sty soundEffectSlot1Init
    tsx
    stx generalCounter
    ldx menuStackPtr
    txs
    pla
    jsr enterMenu
    pla
    jsr enterPage
    pla
    jsr setScratch
    tsx
    stx menuStackPtr
    ldx generalCounter
    txs
    rts


setupUD:
    ldy activeColumn
    bne setupUDDigitChange

setupUDRowChange:
; ud change row 1/2 - activeColumn == 0
    ldy #$00
    lda unpackedPageType
    bpl @storeMin ; no page select row for single page
    dey
@storeMin:
    sty udMin
    ldx activePage
    lda pageCounts,x
    sta udMax

    lda #>activeRow
    sta udPointer+1
    lda #<activeRow
    sta udPointer

    lda udAdjust
    eor #$FF
    clc
    adc #$01
    sta udAdjust
    rts

setupUDDigitChange:
; ud change digit 2/2 - activeColumn > 0
    dey
    tya
    lsr
    tay ; y points to digit
    php ; save for later, carry clear if hi byte
    lda #$0
    sta udMin
    sta udPointer+1 ; won't work if nybbleTemp is not zeropage
    lda #<nybbleTemp
    sta udPointer
    lda #$10
    bit unpackedItemType ; check if bcd
    bvc @storeDigitMax
    lda #$A
@storeDigitMax:
    sta udMax

    lda #>MEMORY_BASE
    sta digitPtr+1
    ldx activeItem
    lda memoryMap,x

    sta digitPtr
    lda (digitPtr),y
    plp
    bcs @storeNybble

    lsr
    lsr
    lsr
    lsr
@storeNybble:
    and #$F
    sta nybbleTemp
    rts

setupLR:
    lda activeRow
    bmi setupLRPageSelect

    lda unpackedItemType
    bpl setupLRValueChange

    and #DIGIT_MASK
    cmp #DIGIT_COMPARE
    beq setupLRColumnChange

    lda #$00
    sta lrAdjust
    rts


setupLRPageSelect:
; setupLRPageSelect  - activeRow < 0
    lda #>activePage
    sta lrPointer+1
    lda #<activePage
    sta lrPointer
    ldy activeMenu
    lda lastPages,y
    sta lrMax
    lda firstPages,y
    sta lrMin
    rts


setupLRValueChange:
; setupLRValueChange - activeRow >= 0 && itemType < 128
    lda #>MEMORY_BASE
    sta lrPointer+1
    ldx activeItem
    lda memoryMap,x
    sta lrPointer
    ldy #$0
    lda unpackedItemType
    and #TYPE_MASK
    cmp #TYPE_FF_OFF
    bne @storeMin
    dey
@storeMin:
    sty lrMin
    ldx unpackedItemValue
    cmp #TYPE_CHOICES
    bne @storeMax
    lda stringListCounts,x
    tax
@storeMax:
    stx lrMax
    rts

setupLRColumnChange:
; setupLRColumnChange itemType & %10100000 == %10000000
    lda #0
    sta lrMin
    lda #>activeColumn
    sta lrPointer+1
    lda #<activeColumn
    sta lrPointer
    lda unpackedItemValue
    tay
    iny
    sty lrMax
    rts


.out .sprintf("setup: %d", *-enterSubMenu)

collectControllerInput:
    lda #$00
    sta selectPressed
    sta startOrAPressed
    sta BPressed
    sta udAdjust
    sta lrAdjust

    lda newlyPressedButtons_player1
    tax
    and #BUTTON_START | BUTTON_A ; do different things for these instead?
    beq @checkB
    inc startOrAPressed
    jmp @checkCardinals
@checkB:
    txa
    and #BUTTON_B
    beq @checkSelect
    inc BPressed
    jmp @checkCardinals
@checkSelect:
    txa
    and #BUTTON_SELECT
    beq @checkCardinals
    inc selectPressed

@checkCardinals:


; maybe also folded saves bytes?
    lda #BUTTON_UP
    jsr menuThrottle
    beq @upNotPressed
    inc udAdjust
    rts
@upNotPressed:
    lda #BUTTON_DOWN
    jsr menuThrottle
    beq @downNotPressed
    dec udAdjust
    rts
@downNotPressed:
    lda #BUTTON_LEFT
    jsr menuThrottle
    beq @leftNotPressed
    dec lrAdjust
    rts
@leftNotPressed:
    lda #BUTTON_RIGHT
    jsr menuThrottle
    beq @rightNotPressed
    inc lrAdjust
    rts
@rightNotPressed:
    rts


respondToInput:
    ldy activeColumn
    beq enterNewPage
    lda udAdjust
    beq enterNewPage

rePackDigit:
    dey
    tya
    lsr
    tay
    bcs @smallDigit
    lda (digitPtr),y
    and #$0F
    sta (digitPtr),y
    lda nybbleTemp
    asl
    asl
    asl
    asl
    ora (digitPtr),y
    sta (digitPtr),y

    jmp enterNewPage

@smallDigit:
    lda (digitPtr),y
    and #$F0
    ora nybbleTemp
    sta (digitPtr),y

enterNewPage:
    lda activePage
    cmp originalPage
    beq goSomewhere
    jmp enterPage

goSomewhere:
    lda startOrAPressed
    beq leaveSomewhere

    lda unpackedItemType
    cmp #TYPE_SUBMENU
    bne startGame

    lda unpackedItemValue
    jmp enterSubMenu

startGame:
    ; todo - put code here
    rts

leaveSomewhere:
    lda BPressed
    beq doSomethingWithSelect
    lda activeMenu
    beq doSomethingWithSelect
    jmp exitSubmenu


doSomethingWithSelect:
    ; lda selectPressed
    ; placeholder
    rts


addInputs:
    ldx #0 ; upDown
    jsr @doActualAdd
    ldx #MENU_PTR_DISTANCE ; leftRight
@doActualAdd:
    lda soundEffectSlot1Init
    bne @ret ; skip leftRight if up/down input was received
    lda udAdjust,x
    beq @ret ; skip if nothing to do
    clc
    adc (udPointer,x)
    sta (udPointer,x)
    ldy udMax,x
    beq @sfx ; 0 means unlimited.  expected values 2-31
    cmp udMax,x
    beq @rollToMin
    clc
    adc #$1
    cmp udMin,x
    bne @sfx
    ldy udMax,x
    dey
    tya
    bne @storeDigit
@rollToMin:
    lda udMin,x
@storeDigit:
    sta (udPointer,x)
@sfx:
    inc soundEffectSlot1Init
@ret:
    rts


.out .sprintf("input handling: %d", *-collectControllerInput)

stageBackgroundTiles:
; page index points to split address tables
; tables are pointers into strings
; word1,0,word2,0,word3,-1

    ldx activePage
    @blankCounter = blankCounter
    @rowCounter = rowCounter
    @stringPtr = stringSetPtr

    lda pageStringsetsLo,x
    sta @stringPtr
    lda pageStringsetsHi,x
    sta @stringPtr+1

    lda #>MENU_TITLE_PPU
    sta stack
    lda #<MENU_TITLE_PPU
    sta stack+1
    lda #MENU_ROWS
    sta @rowCounter
    ldx #$2

@nextRow:
    lda #MENU_STRIPE_WIDTH-2
    sta @blankCounter

@loop:
    ldy #0
    lda (@stringPtr),y
    tay
    iny
    beq @fillBlank ; stop advancing pointer when $FF is reached
    inc @stringPtr
    bne @noCarry
    inc @stringPtr+1
@noCarry:
    iny
    beq @fillBlank ; $FE also blanks line but after advancing pointer
    sta stack,x
    dec @blankCounter
    inx
    bne @loop ; always taken
@fillBlank: ; should only be entered directly when end of string reached
    dec @blankCounter
    bmi @finishRow
    lda #$FF
    sta stack,x
    inx
    bne @fillBlank ; always taken

@finishRow:
; check if all rows drawn
    dec @rowCounter
    beq @shiftTitleRow

; set next row based on last row
    lda stack-(MENU_STRIPE_WIDTH-1),x
    clc
    adc #$40
    sta stack+1,x
    lda stack-MENU_STRIPE_WIDTH,x
    adc #$00
    sta stack,x
    inx
    inx
    bne @nextRow ; always taken
@shiftTitleRow:
; bump title row 4 tiles to the right
    lda stack+1
    eor #%1100
    sta stack+1
    rts

.out .sprintf("background staging: %d", *-stageBackgroundTiles)

stageCurrentValues:
    @counter = blankCounter
    @itemCount = rowCounter

    lda #$00
    sta @counter
    lda #>MEMORY_BASE
    sta byteSpriteAddr+1
    ldx activePage
    lda firstItems,x
    sta activeItem
    lda pageCounts,x
    sta @itemCount

@memoryStageLoop:
    lda @counter
    asl
    asl
    asl
    asl
    clc
    adc #$50
    sta spriteYOffset
    lda #$D0
    sta spriteXOffset

    ldy activeItem
    lda memoryMap,y
    sta byteSpriteAddr
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
    lda (byteSpriteAddr),y
    bpl @drawNumber
    ldx #0
    jsr @setStringList
    jmp @pullFromStringList

@drawString:
    txa
    and #%11111
    tax
    jsr @setStringList
    lda (byteSpriteAddr),y
    tay
@pullFromStringList:
    lda spriteXOffset
    clc
    adc #$10
    sta spriteXOffset
    lda (stringSetPtr),y
    jsr stringSpriteAlignRightA

    jmp @nextByte

@setStringList:
    lda stringListIndexes,x
    clc
    adc #<stringLists
    sta stringSetPtr
    lda #$00
    adc #>stringLists
    sta stringSetPtr+1
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
    clc
    adc #1
    sta byteSpriteLen
    asl
    asl
    asl
    asl
    sta generalCounter2
    sec
    lda spriteXOffset
    sbc generalCounter2
    sec
    sbc #$F0
    sta spriteXOffset
    jsr byteSprite
    jmp @nextByte

@drawNumber:
    lda #$01
    sta byteSpriteLen
    jsr byteSprite

@nextByte:
    inc activeItem
    inc @counter
    lda @counter
    cmp @itemCount
    beq @ret
    jmp @memoryStageLoop
@ret:
    rts
.out .sprintf("value staging: %d", *-stageCurrentValues)


stageCursor:
    lda activeRow
    bpl @notTitle

    lda #$3F
    sta spriteYOffset
    lda #$10
    sta spriteXOffset
    lda #$23 ; page select
    sta spriteIndexInOamContentLookup
    jmp loadSpriteIntoOamStaging

@notTitle:
    asl
    asl
    asl
    asl
    clc
    adc #$4F
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
    adc #$C9
    sta spriteXOffset
    ldx activeItem
    lda itemTypes,x
    and #VALUE_MASK
    sec
    sbc #1
    lsr
    asl
    asl
    asl
    asl
    eor #$FF
    clc
    adc #$01
    clc
    adc spriteXOffset
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

.out .sprintf("cursor staging: %d", *-stageCursor)

render_mode_menu:
    tsx
    txa
    ldx #$ff
    txs
    tax
    ldy #MENU_ROWS
@nextRow:
    pla
    sta PPUADDR
    pla
    sta PPUADDR
    .repeat MENU_STRIPE_WIDTH - 2
    pla
    sta PPUDATA
    .endrepeat
    dey
    bne @nextRow
    txs
    rts

.out .sprintf("render dump: %d", *-render_mode_menu)

debugSpriteStaging:
    lda #$30
    sta spriteYOffset
    lda #$A8
    sta spriteXOffset
    lda #$00
    sta byteSpriteAddr+1
    lda #activeMenu
    sta byteSpriteAddr
    lda #4
    sta byteSpriteLen
    jsr byteSprite
    lda #>MEMORY_BASE
    sta byteSpriteAddr+1
    rts

.out .sprintf("debug staging: %d", *-debugSpriteStaging)
.out .sprintf("total: %d", *-gameMode_gameTypeMenu)
