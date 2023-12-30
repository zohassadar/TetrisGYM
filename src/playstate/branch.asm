branchOnPlayStatePlayer1:
        lda playState
        jsr switch_s_plus_2a
        .addr   playState_unassignOrientationId
        .addr   playState_playerControlsActiveTetrimino
        .addr   playState_lockTetrimino
        .addr   playState_checkForCompletedRows
        .addr   shiftPlayfield3TimesThenAnimation
        .addr   playState_updateLinesAndStatistics
        .addr   playState_prepareNext ; used to be bTypeGoalCheck
        .addr   playState_receiveGarbage
        .addr   playState_spawnNextTetrimino
        .addr   playState_noop
        .addr   playState_checkStartGameOver
        .addr   playState_incrementPlayState

playState_unassignOrientationId:
        lda #$13
        sta currentPiece
        rts


shiftPlayfield3TimesThenAnimation:
        jsr playstate_shiftPlayfieldDownABit
        jsr playstate_shiftPlayfieldDownABit
        jsr playstate_shiftPlayfieldDownABit
        jmp updateLineClearingAnimation

playState_incrementPlayState:
        inc playState
playState_noop:
        rts

.include "active.asm"
.include "lock.asm"
.include "completedrows.asm"
.include "updatestats.asm"
.include "preparenext.asm"
.include "garbage.asm"
.include "spawnnext.asm"
.include "gameover_rocket.asm"

.include "util.asm"
