render_mode_pause:
        jsr resetWtfScroll
        lda pausedOutOfDateRenderFlags
        and #$02
        beq @skipSaveSlotPatch
        jsr saveSlotNametablePatch
@skipSaveSlotPatch:
        lda #0
        sta pausedOutOfDateRenderFlags

        lda playState
        cmp #$04
        beq @done
        jsr render_playfield
@done:
        jsr resetScroll
        rts
