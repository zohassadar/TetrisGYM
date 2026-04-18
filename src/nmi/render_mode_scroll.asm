render_mode_scroll:
.if ED2NTC = 1
        lda #$20
        sta PPUADDR
        lda #$F3
        sta PPUADDR
        lda everdrivePlayerId
        bne @notIdle
        lda #$24 ; dash, hyphen, whatever
@notIdle:
        sta PPUDATA
.endif
        ; handle scroll
        lda currentPpuCtrl
        and #$FC
        sta currentPpuCtrl
        lda #0
        sta ppuScrollX

        jsr calc_menuScrollY
        cmp menuScrollY
        beq @endscroll
        ; not equal
        cmp menuScrollY
        bcc @lessThan

        inc menuScrollY

        jmp @endscroll
@lessThan:
        dec menuScrollY
@endscroll:

        lda menuScrollY
        cmp #MENU_MAX_Y_SCROLL
        bcc @uncapped
        lda #MENU_MAX_Y_SCROLL
        sta menuScrollY
@uncapped:

        sta ppuScrollY
        rts

calc_menuScrollY:
        lda practiseType
        cmp #MENU_TOP_MARGIN_SCROLL
        bcs @underflow
        lda #MENU_TOP_MARGIN_SCROLL+1
@underflow:
        sbc #MENU_TOP_MARGIN_SCROLL
        asl
        asl
        asl
        rts
