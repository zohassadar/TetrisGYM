; to do
; do arbitrary action
; get back into menu from game w/block tool on
; each title associated with action
; more sanity checks

MENU_VARS_HI = >menuVars

GAME_ACTIVE = $FF

; valid background chars are 0-253
NORAM = $00

MENU_TITLE_PPU = $2106
MENU_STRIPE_WIDTH = 20
MENU_ROWS = 17
MENU_STACK = $DF ; $01C8 - $01DF intended range

.enum
GOOFY_TOGGLE
RESET_DEFAULTS
CLEAR_SCOREBOARD
.endenum

menuDataStart:
.include "menudata.asm"
.out .sprintf("Menu data: %d", *-menuDataStart)

; tttnnnnnn n = mode
PAGE_DEFAULT = %00000000

; table of first items instead
; + table of item counts

VALUE_MASK = %00011111
TYPE_MASK = %11100000

; tttnnnnn
TYPE_CUSTOM = %00000000
TYPE_NUMBER = %00100000  ; n = limit
TYPE_CHOICES = %01000000 ; n = wordlist index
TYPE_FF_OFF = %01100000  ; n = limit

TYPE_HEX = %10000000 ; n = digits
TYPE_MODE_ONLY = %10100000 ; n = mode
TYPE_BCD = %11000000 ; n = digits, v bit to differentiate from hex
TYPE_SUBMENU = %11100000 ; n = menu index

DIGIT_MASK = %10100000
DIGIT_COMPARE = %10000000


menuStackPush:
    ldx menuStackPtr
    sta stack,x
    dec menuStackPtr
    rts

menuStackPop:
    inc menuStackPtr
    ldx menuStackPtr
    lda stack,x
    rts

gameMode_gameTypeMenu:
.if NO_MENU
    inc gameMode
    rts
.endif
    jsr hideSpritesAndBackground
    stagePatchThenWaitForNmi titlePalette

    ldx #RLE_NT_GAME_MENU
    jsr copyRleNametableToPpu

.if INES_MAPPER <> 0
    lda #CHRBankSet0
    jsr changeCHRBanks
.endif

; reenable display
    jsr resetScroll
    lda #NMIEnable
    sta currentPpuCtrl
    lda #RENDER_QUEUE
    sta renderMode
    jsr showSpriteAndBackground

    lda #MENU_VARS_HI
    sta byteSpriteAddr+1
    lda #0
    sta hideNextPiece
    sta byteSpriteTile
    sta vramRow
    sta gameStarted
    jsr makeNotReady

; check to see if returning from level menu or game
    ldy activeMenu
    iny
    bne @initMenu
    jsr exitSubmenuNoSfx
    jmp gameTypeLoop
@initMenu:
    lda #MENU_STACK
    sta menuStackPtr
    lda #0
    jsr enterMenu

gameTypeLoop:
    lda gameStarted
    beq @noGame
    lda #0
    sta killX2Flag
    lda practiseType
    cmp #MODE_SPEED_TEST
    bne @notSpeedTest
    lda #7
    sta gameMode
    bne @sfx
@notSpeedTest:
    lda practiseType  ; is already in A, but this is explicit
    cmp #MODE_KILLX2
    bne @notKillX2
    lda #RENDER_IDLE
    sta renderMode
    lda #0
    sta gameModeState
    lda #39
    sta levelNumber
    lda #1
    sta killX2Flag
    inc gameMode
@notKillX2:
    inc gameMode
@sfx:
    lda #$2
    sta soundEffectSlot1Init
    rts
@noGame:
    ; todo: write down which vars are used by which func
    jsr collectControllerInput
    jsr setScratch

    ldx activeItem
    lda itemTypes,x
    cmp #TYPE_CUSTOM | GOOFY_TOGGLE
    bne @notGoofyToggle

    lda #0
    sta lrAdjust

@notGoofyToggle:
    jsr addInputs
    jsr respondToInput
    jsr stageCursor

    ; scratch is not important anymore
    jsr stageVRAMRow
    jsr stageVRAMRow
    jsr stageVRAMRow
    jsr stageVRAMRow
    jsr stageVRAMRow
    ; jsr stageBackgroundTiles
    ; jsr stageCurrentValues
gameTypeLoopWait:
    jsr updateAudioWaitForNmiAndResetOamStaging
    jmp gameTypeLoop

.out .sprintf("bg setup & loop: %d", *-gameMode_gameTypeMenu)
setItemCount:
    asl
    tax
    lda pageIndexes+1,x
    lsr
    lsr
    lsr
    sta pageItemCount
    rts

enterSubMenu:
    ldy #$02
    sty soundEffectSlot1Init
    pha
    lda #0
    sta vramRow
    lda activeRow
    jsr menuStackPush
    lda activePage
    jsr menuStackPush
    lda activeMenu
    jsr menuStackPush
    pla
enterMenu:
    sta activeMenu
    cmp #GAME_ACTIVE
    bne @normalMenu
    rts
@normalMenu:
    lda #0
enterPage:
    sta activePage
    sta originalPage
    ldy activeMenu
    clc
    adc startPageByMenu,y
    sta actualPage
    jsr setItemCount
    lda #0
    sta vramRow
    ldx actualPage
    lda pageTypes,x
    and #VALUE_MASK
    sta unpackedPageValue
    beq @noStorePractiseType
    sta practiseType

@noStorePractiseType:
    lda pageTypes,x
    and #TYPE_MASK
    sta unpackedPageType

    ldy activeMenu
    lda pageCountByMenu,y
    ldy #$00
    sty activeColumn
    cmp #$1
    beq @storeRow
    dey ; start at page select row for multipage
    ; dec unpackedPageType ; hack for now
@storeRow:
    sty activeRow

setScratch:
    ldx actualPage
    lda activeRow
    clc
    adc startItemByPage,x
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

exitSubmenuNoSfx:
    jsr menuStackPop
    jsr enterMenu
    jsr menuStackPop
    jsr enterPage

.if KEYBOARD = 1
.warning "keyboard menu seed code is broken"
; @kbSeedLow = generalCounter
; @kbSeedHigh = generalCounter2
;         bne @checkForKbSeedEntry
;         jmp @skipSeedControl
; @checkForKbSeedEntry:
;         jsr readKbSeedEntry
;         bmi @noKeysPressed
;         sta @kbSeedLow
;         asl
;         asl
;         asl
;         asl
;         sta @kbSeedHigh
;         ldy menuSeedCursorIndex
;         dey
;         tya
;         lsr
;         tay
;         ; y = (index-1) // 2
;         ; c = (index-1) % 2
;         lda set_seed_input,y
;         bcc @highByte
; ; low byte:
;         and #$F0
;         ora @kbSeedLow
;         bcs @storeSeed
; @highByte:
;         and #$0F
;         ora @kbSeedHigh
; @storeSeed:
;         sta set_seed_input,y
;         jmp @moveRight
; @noKeysPressed:
; .else
;         beq @skipSeedControl
.endif
    jsr menuStackPop
    sta activeRow
    jmp setScratch


setupUD:
    ldy activeColumn
    bne setupUDDigitChange

setupUDRowChange:
; ud change row 1/2 - activeColumn == 0
    ldy #$00
    lda unpackedPageType
    ldx activeMenu
    lda pageCountByMenu,x
    tax
    dex
    beq @storeMin ; no page select row for single page
    dey
@storeMin:
    sty udMin
    lda pageItemCount
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

    lda #MENU_VARS_HI
    sta digitPtr+1
    ldx activeItem
    lda memoryOffsets,x

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
    lda pageCountByMenu,y
    sta lrMax
    lda #0
    sta lrMin
    rts


setupLRValueChange:
; setupLRValueChange - activeRow >= 0 && itemType < 128
    lda #MENU_VARS_HI
    sta lrPointer+1
    ldx activeItem
    lda memoryOffsets,x
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
    txa
    asl
    tax
    lda choiceSetIndexes+1,x
    lsr
    lsr
    lsr
    lsr
    tax
    inx
    inx
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
    sta udAdjust
    sta lrAdjust
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
    beq checkIfGameStartOrSubmenu
    jmp enterPage

checkIfGameStartOrSubmenu:
    lda newlyPressedButtons_player1
    and #BUTTON_START|BUTTON_A
    beq checkIfExitSubmenu

    lda activeRow
    bmi checkPageMode

    lda unpackedItemType
    cmp #TYPE_MODE_ONLY
    beq startGameFromItem

    cmp #TYPE_SUBMENU
    beq goToSubMenu

    cmp #TYPE_CUSTOM
    beq @goToCustom

@checkPageMode:
    jmp checkPageMode

@goToCustom:
    lda newlyPressedButtons_player1
    and #BUTTON_A+BUTTON_START
    beq customClearScoreboard
    branchTo unpackedItemValue, \
        customToggleGoofy, \
        customResetDefaults, \
        customClearScoreboard

customToggleGoofy:
    lda goofyFlag
    eor #1
    sta goofyFlag
    lda heldButtons_player1
    asl
    and #$AA
    sta tmp3
    lda heldButtons_player1
    and #$AA
    lsr
    ora tmp3
    sta heldButtons_player1
customResetDefaults:
customClearScoreboard:
    rts

goToSubMenu:
    lda unpackedItemValue
    jmp enterSubMenu

startGameFromItem:
    lda unpackedPageValue
    rts

checkPageMode:
    lda newlyPressedButtons_player1
    and #BUTTON_START
    beq @noGame
    jmp setGameStartedFlag

@noGame:

    rts

checkIfExitSubmenu:
    lda newlyPressedButtons_player1
    and #BUTTON_B
    beq doSomethingWithSelect
    lda activeMenu
    bne @exitSubmenu
    lda activeRow
    bmi doSomethingWithSelect
    lda #$FF
    sta activeRow
    ldy #$02
    sty soundEffectSlot1Init
    rts
@exitSubmenu:
    jmp exitSubmenu


doSomethingWithSelect:
    ; lda selectPressed
    ; placeholder
    rts

setGameStartedFlag:
    inc gameStarted
    lda #GAME_ACTIVE
    jmp enterSubMenu


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
    lda #0
    sta vramRow
    inc soundEffectSlot1Init
    jsr copyVarsToSram
@ret:
    rts


.out .sprintf("input handling: %d", *-collectControllerInput)

menuVramRowTable:
; 16 for now
    .addr $2109
    .addr $2146
    .addr $2166
    .addr $2186
    .addr $21A6
    .addr $21C6
    .addr $21E6
    .addr $2206
    .addr $2226
    .addr $2246
    .addr $2266
    .addr $2286
    .addr $22A6
    .addr $22C6
    .addr $22E6
    .addr $2306
    .addr $2326


stageVRAMRow:

    lda vramRow   ; use OG game logic & values
    cmp #$20
    bne @stage
@ret:
    rts
@stage:

    @blankCounter = blankCounter
    @rowCounter = rowCounter
    @stringPtr = stringSetPtr
    @itemPtr = generalCounter
    @padding = generalCounter5

    lda #MENU_STRIPE_WIDTH
    sta @blankCounter
    ldx activeMenu

    lda actualPage
    jsr setItemCount
    lda actualPage
    asl
    tax
    lda pageIndexes,x
    clc
    adc #<pageLabels
    sta @itemPtr
    lda pageIndexes+1,x
    and #$7
    adc #>pageLabels
    sta @itemPtr+1

    ldx actualPage
    lda pageTypes,x
    lsr
    lsr
    lsr
    lsr
    lsr
    sta @padding

    lda vramRow
    asl
    tay

    ldx renderQueuePointer
    lda menuVramRowTable+1,y
    sta stack,x
    inx
    lda menuVramRowTable,y
    sta stack,x
    inx
    lda #MENU_STRIPE_WIDTH-1
    sta stack,x
    inx

@loop:
    lda pageItemCount
    cmp vramRow
    bcc @fillBlank

    lda (@itemPtr),y
    clc
    adc #<strTable
    php
    sta @stringPtr
    iny
    lda (@itemPtr),y
    lsr
    lsr
    lsr
    lsr
    sta stringLength
    lda (@itemPtr),y
    and #$F
    plp
    adc #>strTable
    sta @stringPtr+1

; padding goes here
    lda vramRow
    bne @startString
    lda #$FF
@pad:
    dec @padding
    bmi @startString
    sta stack,x
    dec @blankCounter
    inx
    bne @pad
@startString:

    ldy #0
@copy:
    lda (@stringPtr),y
    sta stack,x
    iny
    inx
    dec blankCounter
    dec stringLength
    bpl @copy
@fillBlank: ; should only be entered directly when end of string reached
    dec @blankCounter
    bmi @finish
    lda #$FF
    sta stack,x
    inx
    bne @fillBlank ; always taken
@finish:
    inc renderQueueLength
    stx renderQueuePointer

    lda vramRow
    beq @noValue
    lda pageItemCount
    cmp vramRow
    bcc @noValue

    txa
    sec
    sbc #8
    sta renderQueuePointer
    jsr stageCurrentValue


@noValue:
    inc vramRow
    lda vramRow
    cmp #MENU_ROWS
    bne @ret2
    lda #$20
    sta vramRow
@ret2:
    rts
; .out .sprintf("background staging: %d", *-stageBackgroundTiles)

stageCurrentValue:
    ldx actualPage
    lda startItemByPage,x
    clc
    adc vramRow
    sec
    sbc #1
    tay
    sty activeItem
    lda memoryOffsets,y
    sta byteSpriteAddr
    lda #MENU_VARS_HI
    sta byteSpriteAddr+1
    lda itemTypes,y
    tax
    ldy #0
    and #TYPE_MASK
    bmi @digitInputOrEdge

    cmp #TYPE_CHOICES
    beq @drawString

    cmp #TYPE_NUMBER
    bne @drawFFOff
@setupOneByte:
    lda #$02
    bne @drawOneByte

@drawFFOff:
    lda (byteSpriteAddr),y
    bpl @setupOneByte
    ldx #CHOICESET_OFFON
    jsr @setStringList
    jmp @startCopy

@drawString:
    txa
    and #%11111
    tax
    jsr @setStringList
    lda (byteSpriteAddr),y
    asl
    tay
@startCopy:
    lda (stringSetPtr),y
    clc
    adc #<strTable
    pha
    php
    iny
    lda (stringSetPtr),y
    lsr
    lsr
    lsr
    lsr
    clc
    adc #1
    sta generalCounter
    lda (stringSetPtr),y
    and #$F
    plp
    adc #>strTable
    sta stringSetPtr+1
    pla
    sta stringSetPtr
    lda generalCounter
    jsr setStackOffset

    ldy #0
@nextChar:
    lda (stringSetPtr),y
    sta stack,x
    inx
    iny
    dec generalCounter
    bne @nextChar

@endCopy:
    jmp @ret

@setStringList:
    txa
    asl
    tax
    lda choiceSetIndexes,x
    clc
    adc #<choiceSets
    sta stringSetPtr
    lda choiceSetIndexes+1,x
    and #$F
    adc #>choiceSets
    sta stringSetPtr+1
    rts

@digitInputOrEdge:
    and #TYPE_MASK
    cmp #TYPE_MODE_ONLY
    beq @ret
    cmp #TYPE_SUBMENU
    beq @ret
    txa
    and #%11111
@drawOneByte:
    pha
    sec
    sbc #1
    lsr
    clc
    adc #$1
    sta generalCounter
    pla

    jsr setStackOffset
    ldy #$00
@digitLoop:
    lda (byteSpriteAddr),y
    pha
    lsr
    lsr
    lsr
    lsr
    sta stack,x
    inx
    pla
    and #$0F
    sta stack,x
    inx
    iny
    dec generalCounter
    bne @digitLoop
@ret:

    lda renderQueuePointer
    clc
    adc #8
    sta renderQueuePointer
    rts

setStackOffset:
    eor #$FF
    clc
    adc #$09
    clc
    adc renderQueuePointer
    tax
    rts



stageCursor:
    ldx activeMenu
    lda pageCountByMenu,x
    cmp #$1
    beq @singlePage
    ldx oamStagingLength
    sta oamStaging+9,x
    lda #$4F
    sta oamStaging+5,x

    lda #$CB
    sta oamStaging+0,x
    sta oamStaging+4,x
    sta oamStaging+8,x

    lda #$C8
    sta oamStaging+3,x
    clc
    adc #$08
    sta oamStaging+7,x
    adc #$08
    sta oamStaging+11,x

    lda #$00
    sta oamStaging+2,x
    sta oamStaging+6,x
    sta oamStaging+10,x

    ldy activePage
    iny
    tya
    sta oamStaging+1,x
    txa
    clc
    adc #$C
    sta oamStagingLength

@singlePage:

    lda activeRow
    bpl @notTitle

    lda #$3F
    sta spriteYOffset
    lda #$10
    sta spriteXOffset
    lda #$23 ; page select
    sta spriteIndex
    jmp loadSpriteIntoOamStaging

@notTitle:
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
    adc #$B9
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
    sta spriteIndex
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
    .repeat MENU_STRIPE_WIDTH
    pla
    sta PPUDATA
    .endrepeat
    dey
    bne @nextRow
    txs
    rts


.out .sprintf("render dump: %d", *-render_mode_menu)


.out .sprintf("total: %d", *-gameMode_gameTypeMenu)

renderQueuePush:
    ldx renderQueuePointer
    sta stack,x
    inc renderQueuePointer
    rts
