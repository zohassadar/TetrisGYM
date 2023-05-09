.segment "CHR"

.if HAS_MMC
.if PRIDE = 1
    .incbin "chr/title_menu_tileset_pride.chr"
.else
    .incbin "chr/title_menu_tileset.chr"
.endif
    .incbin "chr/game_tileset.chr"
    .incbin "chr/rocket_tileset.chr"
.elseif INES_MAPPER = 3
    .incbin "chr/rocket_tileset.chr"
    .repeat $1000
    .byte $0
    .endrepeat
.if PRIDE = 1
    .incbin "chr/title_menu_tileset_pride.chr"
.else
    .incbin "chr/title_menu_tileset.chr"
.endif
    .incbin "chr/game_tileset.chr"
.endif
