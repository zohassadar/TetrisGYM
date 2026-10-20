trtCalculate:
; lines kept in binary in totalLines (2 bytes)
; tetris lines multipled by 400 and stored in tetrisLines (3 bytes)
; rate stored in bcd as a percentage (1 byte)

@quotient = mathRAM
@remainder = mathRAM+3
        clc
        lda completedLines
        adc totalLines
        sta totalLines
        bcc @noCarry
        inc totalLines+1
@noCarry:
        lda completedLines
        cmp #4
        bne @noTetris

        clc
        lda #<400
        adc tetrisLines
        sta tetrisLines
        lda #>400
        adc tetrisLines+1
        sta tetrisLines+1
        bcc @noTetris
        inc tetrisLines+2

@noTetris:
; no divide by 0
        lda totalLines
        bne @notZero
        lda totalLines+1
        beq @convert
@notZero:

        lda tetrisLines
        sta @quotient
        lda tetrisLines+1
        sta @quotient+1
        lda tetrisLines+2
        sta @quotient+2

; from https://www.llx.com/Neil/a2/mult.html
        lda #0              ;initialize rem to 0
        sta @remainder
        sta @remainder+1
        sta @remainder+2
        lda #24
        sta generalCounter
@l1:
        asl @quotient       ;shift hi bit of num1 into rem
        rol @quotient+1
        rol @quotient+2     ;(vacating the lo bit, which will be used for the quotient)
        rol @remainder
        rol @remainder+1
        rol @remainder+2
        lda @remainder
        sec                 ;trial subtraction
        sbc totalLines
        tay
        lda @remainder+1
        sbc totalLines+1
        tax
        lda @remainder+2
        sbc #0
        bcc @l2             ;did subtraction succeed?
        sta @remainder+2    ;if yes, save it
        stx @remainder+1
        sty @remainder
        inc @quotient       ;and record a 1 in the quotient
@l2:
        dec generalCounter
        bne @l1
        ldx @quotient
@convert:
        lda levelDisplayTable,x
        sta trtRate
        rts
