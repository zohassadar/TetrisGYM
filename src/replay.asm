addReplayFrame:
    ldx #$0F
@allPages:
    stx MMC5_MODE0_RAM_BANK
    stx $7B88
    ldy $7B88
    dex
    bpl @allPages
    rts



; binScore 4
; score 3
; rng_seed 2
; spawnCount
; set_seed
; tetriminoX
; tetriminoY
; currentPiece
; levelNumber
