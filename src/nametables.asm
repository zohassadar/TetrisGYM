game_type_menu_nametable: ; RLE
        .incbin "nametables/game_type_menu_nametable_practise.bin"
level_menu_nametable: ; RLE
        .incbin "nametables/level_menu_nametable_practise.bin"
game_nametable: ; RLE
        .incbin "nametables/game_nametable_practise.bin"
enter_high_score_nametable: ; RLE
        .incbin "nametables/enter_high_score_nametable_practise.bin"
rocket_nametable: ; RLE
        .incbin "nametables/rocket_nametable.bin"
legal_nametable: ; RLE
        .incbin "nametables/legal_nametable.bin"
titleNametablePatch: ; stripe
        .byte $21, $69, $4, $1D, $12, $1D, $15, $E
        .byte $0
rocketNametablePatch: ; stripe
        .byte $20, $83, 4, $19, $1B, $E, $1c, $1c
        .byte $20, $A3, 4, $1c, $1d, $a, $1b, $1d
        .byte $0

speedtestNametablePatch:
        ; tiles
        .byte $21, $A3, $5, 0, 0, $ED, 0, 0, $EC
        .byte $22, $23, $2, 'T', 'A', 'P'
        .byte $22, $A3, $2, 'D', 'I', 'R'
        .byte $22, $28, $0, 0
        ; attrs
        .byte $23, $e2, $0, 0
        .byte $23, $ea, $0, 0
        .byte $23, $d8, $2, $55, $55, $55
        .byte $00


.include "nametables/rle.asm"
