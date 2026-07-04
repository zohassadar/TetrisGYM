; the engine from the original game

loadSpriteIntoOamStaging:
        clc
        lda spriteIndex
        rol a
        tax
        lda oamContentLookup,x
        sta generalCounter
        inx
        lda oamContentLookup,x
        sta generalCounter2
        ldx oamStagingLength
        ldy #$00
@whileNotFF:
        lda (generalCounter),y
        cmp #$FF
        beq @ret
        clc
        adc spriteYOffset
        sta oamStaging,x
        inx
        iny
        lda (generalCounter),y
        sta oamStaging,x
        inx
        iny
        lda (generalCounter),y
        sta oamStaging,x
        inx
        iny
        lda (generalCounter),y
        clc
        adc spriteXOffset
        sta oamStaging,x
        inx
        iny
        lda #$04
        clc
        adc oamStagingLength
        sta oamStagingLength
        jmp @whileNotFF

@ret:   rts

.enum
SPRITE_LEVELSELECTCURSOR
SPRITE_GAMETYPECURSOR
SPRITE_MENUSTART
SPRITE_BLANK
SPRITE_TPIECE
SPRITE_JPIECE
SPRITE_ZPIECE
SPRITE_OPIECE
SPRITE_SPIECE
SPRITE_LPIECE
SPRITE_IPIECE
SPRITE_HIGHSCORENAMECURSOR
SPRITE_DEBUGLEVELEDIT
SPRITE_STATESAVE
SPRITE_STATELOAD
SPRITE_HEARTCURSOR
SPRITE_HEART
SPRITE_READY
SPRITE_CUSTOMLEVELCURSOR
SPRITE_INGAMEHEART
SPRITE_SEEDCURSORA
SPRITE_SEEDCURSORB
SPRITE_PRACTISETYPECURSORA
SPRITE_PRACTISETYPECURSORB
SPRITE_MENUPAGESELECTA
SPRITE_MENUPAGESELECTB
.endenum

oamContentLookup:
        .addr   spriteLevelSelectCursor
        .addr   spriteGameTypeCursor
        .addr   spriteMenuStartOption
        .addr   spriteBlank
        .addr   spriteTPiece
        .addr   spriteJPiece
        .addr   spriteZPiece
        .addr   spriteOPiece
        .addr   spriteSPiece
        .addr   spriteLPiece
        .addr   spriteIPiece
        .addr   spriteHighScoreNameCursor
        .addr   spriteDebugLevelEdit
        .addr   spriteStateSave
        .addr   spriteStateLoad
        .addr   spriteHeartCursor
        .addr   spriteHeart
        .addr   spriteReady
        .addr   spriteCustomLevelCursor
        .addr   spriteIngameHeart
        .addr   spriteSeedCursorA
        .addr   spriteSeedCursorB
        .addr   spritePractiseTypeCursorA
        .addr   spritePractiseTypeCursorB
        .addr   spriteMenuPageSelectA
        .addr   spriteMenuPageSelectB
;         .addr   spriteMenuPageSelect2 ; $24
; Sprites are sets of 4 bytes in the OAM format, terminated by FF. byte0=y, byte1=tile, byte2=attrs, byte3=x
; YY AA II XX
spriteLevelSelectCursor:
        .byte   $00,$FC,$20,$00,$00,$FC,$20,$08
        .byte   $08,$FC,$20,$00,$08,$FC,$20,$08
        .byte   $FF
spriteGameTypeCursor:
        .byte   $00,$27,$00,$00,$00,$27,$40,$3A
        .byte   $FF
spriteMenuPageSelectA:
        .byte   $00,$27,$40,$00
        .byte   $00,$27,$00,$D9
        .byte   $FF
spriteMenuPageSelectB:
        .byte   $00,$27,$40,$04
        .byte   $00,$27,$00,$D5
        .byte   $FF
spriteMenuStartOption:
        .byte   $FE,$69,$00,$00
        .byte   $FF
spriteBlank:
        .byte   $00,$FF,$00,$00,$FF
spriteTPiece:
        .byte   $00,$7B,$02,$FC,$00,$7B,$02,$04
        .byte   $00,$7B,$02,$0C,$08,$7B,$02,$04
        .byte   $FF
spriteJPiece:
        .byte   $00,$7D,$02,$FC,$00,$7D,$02,$04
        .byte   $00,$7D,$02,$0C,$08,$7D,$02,$0C
        .byte   $FF
spriteZPiece:
        .byte   $00,$7C,$02,$FC,$00,$7C,$02,$04
        .byte   $08,$7C,$02,$04,$08,$7C,$02,$0C
        .byte   $FF
spriteOPiece:
        .byte   $00,$7B,$02,$00,$00,$7B,$02,$08
        .byte   $08,$7B,$02,$00,$08,$7B,$02,$08
        .byte   $FF
spriteSPiece:
        .byte   $00,$7D,$02,$04,$00,$7D,$02,$0C
        .byte   $08,$7D,$02,$FC,$08,$7D,$02,$04
        .byte   $FF
spriteLPiece:
        .byte   $00,$7C,$02,$FC,$00,$7C,$02,$04
        .byte   $00,$7C,$02,$0C,$08,$7C,$02,$FC
        .byte   $FF
spriteIPiece:
        .byte   $04,$7B,$02,$F8,$04,$7B,$02,$00
        .byte   $04,$7B,$02,$08,$04,$7B,$02,$10
        .byte   $FF
spriteHighScoreNameCursor:
        .byte   $00,$FD,$20,$00,$FF
spriteDebugLevelEdit:
        .byte   $00,'X',$00,$00
        .byte   $FF
spriteStateLoad:
        .byte   $00,'L',$03,$00,$00,'O',$03,$08
        .byte   $00,'A',$03,$10,$00,'D',$03,$18
        .byte   $00,'E',$03,$20,$00,'D',$03,$28
        .byte   $FF
spriteStateSave:
        .byte   $00,'S',$03,$00,$00,'A',$03,$08
        .byte   $00,'V',$03,$10,$00,'E',$03,$18
        .byte   $00,'D',$03,$20
        .byte   $FF
spriteSeedCursorA:
        .byte   $00,$6B,$00,$00
        .byte   $FF
spriteSeedCursorB:
        .byte   $00,$6B,$00,$00
        .byte   $FF
spritePractiseTypeCursorA:
        .byte   $00,$27,$40,$FA
        .byte   $00,$27,$00,$06
        .byte   $FF
spritePractiseTypeCursorB:
        .byte   $00,$27,$40,$F8
        .byte   $00,$27,$00,$08
        .byte   $FF
spriteHeartCursor:
        .byte   $00,$6c,$00,$00,$FF
spriteHeart:
        .byte   $00,$6e,$00,$00,$FF
spriteReady:
        .byte   $00,'R',$01,$00,$08,'E',$01,$00
        .byte   $10,'A',$01,$00,$18,'D',$01,$00
        .byte   $20,'Y',$01,$FF
        .byte   $FF
spriteCustomLevelCursor:
        .byte   $00,$6A,$00,$00,$21,$6A,$80,$00
        .byte   $FF
spriteIngameHeart:
        .byte   $00,$2c,$00,$00,$FF
