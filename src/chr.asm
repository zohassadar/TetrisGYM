.segment "CHR"

.if HAS_MMC
    .incbin "chr/title_menu_tileset.chr"
    .incbin "chr/game_tileset.chr"
    .incbin "chr/rocket_tileset.chr"
    .incbin "chr/game_tileset_dark.chr"
.elseif INES_MAPPER = 3
    .incbin "chr/rocket_tileset.chr"
    .incbin "chr/game_tileset_dark.chr"
    .incbin "chr/title_menu_tileset.chr"
    .incbin "chr/game_tileset.chr"
.endif
