.segment "CHR"

.if HAS_MMC
    .incbin "chr/title_menu_tileset.chr"
.if DARKMODE = 1
    .incbin "chr/game_tileset_darkmode.chr"
.else
    .incbin "chr/game_tileset.chr"
.endif
    .incbin "chr/rocket_tileset.chr"
.elseif INES_MAPPER = 3
    .incbin "chr/rocket_tileset.chr"
    .repeat $1000
    .byte $0
    .endrepeat
    .incbin "chr/title_menu_tileset.chr"
.if DARKMODE = 1
    .incbin "chr/game_tileset_darkmode.chr"
.else
    .incbin "chr/game_tileset.chr"
.endif
.endif
