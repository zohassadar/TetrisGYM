.segment "CHR"

.if HAS_MMC
    .incbin "chr/title_menu_tileset.chr"
    .incbin "chr/game_tileset.chr"
    .incbin "chr/rocket_tileset.chr"
    .incbin "chr/game_tileset_shifted1.chr"
    .incbin "chr/game_tileset_shifted2.chr"
    .repeat $1000
    .byte $0
    .endrepeat
.elseif INES_MAPPER = 3
    .incbin "chr/rocket_tileset.chr"
    .repeat $1000
    .byte $0
    .endrepeat
    .incbin "chr/title_menu_tileset.chr"
    .incbin "chr/game_tileset.chr"
.endif

; T 0
; J 2
; Z 1
; O 0
; S 2
; L 1
; I 0