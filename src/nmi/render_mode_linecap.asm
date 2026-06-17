render_mode_linecap_menu:
        lda renderFlags
        and #RENDER_LINES
        beq @static
        ; render level / lines
        lda #0
        sta renderFlags
        lda #$21
        sta PPUADDR
        lda #$F3
        sta PPUADDR
        jsr render_linecap_level_lines

@static:
        rts

render_linecap_level_lines:
        lda linecapWhen
        cmp #LINECAP_LINES
        beq @linecapLines
        cmp #LINECAP_LEVEL
        bne @ret
        lda linecapLevel
        jmp renderByteBCD

@linecapLines:
        lda linecapLines
        sta PPUDATA
        lda linecapLines+1
        jsr twoDigsToPPU
@ret:
        rts
