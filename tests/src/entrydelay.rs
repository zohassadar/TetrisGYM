use rustico_core::nes::NesState;

use crate::video::Video;
use crate::{labels, playfield, util, video};

pub fn test() {
    let mut emu = util::emulator(None);
    let mut view = Video::new();
    test_entrydelay(&mut emu, false, 0, 0, 10, &mut view);
    test_entrydelay(&mut emu, false, 1, 0, 10, &mut view);
    test_entrydelay(&mut emu, false, 2, 0, 12, &mut view);
    test_entrydelay(&mut emu, false, 3, 0, 12, &mut view);
    test_entrydelay(&mut emu, false, 4, 0, 12, &mut view);
    test_entrydelay(&mut emu, false, 5, 0, 12, &mut view);
    test_entrydelay(&mut emu, false, 6, 0, 14, &mut view);
    test_entrydelay(&mut emu, false, 7, 0, 14, &mut view);
    test_entrydelay(&mut emu, false, 8, 0, 14, &mut view);
    test_entrydelay(&mut emu, false, 9, 0, 14, &mut view);
    test_entrydelay(&mut emu, false, 10, 0, 16, &mut view);
    test_entrydelay(&mut emu, false, 11, 0, 16, &mut view);
    test_entrydelay(&mut emu, false, 12, 0, 16, &mut view);
    test_entrydelay(&mut emu, false, 13, 0, 16, &mut view);
    test_entrydelay(&mut emu, false, 14, 0, 18, &mut view);
    test_entrydelay(&mut emu, false, 15, 0, 18, &mut view);
    test_entrydelay(&mut emu, false, 16, 0, 18, &mut view);
    test_entrydelay(&mut emu, false, 17, 0, 18, &mut view);
    test_entrydelay(&mut emu, false, 18, 0, 18, &mut view);
    test_entrydelay(&mut emu, false, 19, 0, 18, &mut view);

    test_entrydelay(&mut emu, true, 19, 0, 38, &mut view);
    test_entrydelay(&mut emu, true, 19, 1, 37, &mut view);
    test_entrydelay(&mut emu, true, 19, 2, 36, &mut view);
    test_entrydelay(&mut emu, true, 19, 3, 35, &mut view);

    test_entrydelay(&mut emu, true, 18, 0, 38, &mut view);
    test_entrydelay(&mut emu, true, 18, 1, 37, &mut view);
    test_entrydelay(&mut emu, true, 18, 2, 36, &mut view);
    test_entrydelay(&mut emu, true, 18, 3, 35, &mut view);

    test_entrydelay(&mut emu, true, 17, 0, 38, &mut view);
    test_entrydelay(&mut emu, true, 17, 1, 37, &mut view);
    test_entrydelay(&mut emu, true, 17, 2, 36, &mut view);
    test_entrydelay(&mut emu, true, 17, 3, 35, &mut view);

    test_entrydelay(&mut emu, true, 16, 0, 38, &mut view);
    test_entrydelay(&mut emu, true, 16, 1, 37, &mut view);
    test_entrydelay(&mut emu, true, 16, 2, 36, &mut view);
    test_entrydelay(&mut emu, true, 16, 3, 35, &mut view);

    test_entrydelay(&mut emu, true, 15, 0, 38, &mut view);
    test_entrydelay(&mut emu, true, 15, 1, 37, &mut view);
    test_entrydelay(&mut emu, true, 15, 2, 36, &mut view);
    test_entrydelay(&mut emu, true, 15, 3, 35, &mut view);

    test_entrydelay(&mut emu, true, 14, 0, 38, &mut view);
    test_entrydelay(&mut emu, true, 14, 1, 37, &mut view);
    test_entrydelay(&mut emu, true, 14, 2, 36, &mut view);
    test_entrydelay(&mut emu, true, 14, 3, 35, &mut view);

    test_entrydelay(&mut emu, true, 13, 0, 34, &mut view);
    test_entrydelay(&mut emu, true, 13, 1, 33, &mut view);
    test_entrydelay(&mut emu, true, 13, 2, 36, &mut view);
    test_entrydelay(&mut emu, true, 13, 3, 35, &mut view);

    test_entrydelay(&mut emu, true, 12, 0, 34, &mut view);
    test_entrydelay(&mut emu, true, 12, 1, 33, &mut view);
    test_entrydelay(&mut emu, true, 12, 2, 36, &mut view);
    test_entrydelay(&mut emu, true, 12, 3, 35, &mut view);

    test_entrydelay(&mut emu, true, 11, 0, 34, &mut view);
    test_entrydelay(&mut emu, true, 11, 1, 33, &mut view);
    test_entrydelay(&mut emu, true, 11, 2, 36, &mut view);
    test_entrydelay(&mut emu, true, 11, 3, 35, &mut view);

    test_entrydelay(&mut emu, true, 10, 0, 34, &mut view);
    test_entrydelay(&mut emu, true, 10, 1, 33, &mut view);
    test_entrydelay(&mut emu, true, 10, 2, 36, &mut view);
    test_entrydelay(&mut emu, true, 10, 3, 35, &mut view);

    test_entrydelay(&mut emu, true, 9, 0, 34, &mut view);
    test_entrydelay(&mut emu, true, 9, 1, 33, &mut view);
    test_entrydelay(&mut emu, true, 9, 2, 32, &mut view);
    test_entrydelay(&mut emu, true, 9, 3, 31, &mut view);

    test_entrydelay(&mut emu, true, 8, 0, 34, &mut view);
    test_entrydelay(&mut emu, true, 8, 1, 33, &mut view);
    test_entrydelay(&mut emu, true, 8, 2, 32, &mut view);
    test_entrydelay(&mut emu, true, 8, 3, 31, &mut view);

    test_entrydelay(&mut emu, true, 7, 0, 34, &mut view);
    test_entrydelay(&mut emu, true, 7, 1, 33, &mut view);
    test_entrydelay(&mut emu, true, 7, 2, 32, &mut view);
    test_entrydelay(&mut emu, true, 7, 3, 31, &mut view);

    test_entrydelay(&mut emu, true, 6, 0, 34, &mut view);
    test_entrydelay(&mut emu, true, 6, 1, 33, &mut view);
    test_entrydelay(&mut emu, true, 6, 2, 32, &mut view);
    test_entrydelay(&mut emu, true, 6, 3, 31, &mut view);

    test_entrydelay(&mut emu, true, 5, 0, 30, &mut view);
    test_entrydelay(&mut emu, true, 5, 1, 29, &mut view);
    test_entrydelay(&mut emu, true, 5, 2, 32, &mut view);
    test_entrydelay(&mut emu, true, 5, 3, 31, &mut view);

    test_entrydelay(&mut emu, true, 4, 0, 30, &mut view);
    test_entrydelay(&mut emu, true, 4, 1, 29, &mut view);
    test_entrydelay(&mut emu, true, 4, 2, 32, &mut view);
    test_entrydelay(&mut emu, true, 4, 3, 31, &mut view);
    //
    test_entrydelay(&mut emu, true, 3, 0, 30, &mut view);
    test_entrydelay(&mut emu, true, 3, 1, 29, &mut view);
    test_entrydelay(&mut emu, true, 3, 2, 32, &mut view);
    test_entrydelay(&mut emu, true, 3, 3, 31, &mut view);

    test_entrydelay(&mut emu, true, 2, 0, 30, &mut view);
    test_entrydelay(&mut emu, true, 2, 1, 29, &mut view);
    test_entrydelay(&mut emu, true, 2, 2, 32, &mut view);
    test_entrydelay(&mut emu, true, 2, 3, 31, &mut view);

    test_entrydelay(&mut emu, true, 1, 0, 30, &mut view);
    test_entrydelay(&mut emu, true, 1, 1, 29, &mut view);
    test_entrydelay(&mut emu, true, 1, 2, 28, &mut view);
    test_entrydelay(&mut emu, true, 1, 3, 27, &mut view);

    test_entrydelay(&mut emu, true, 0, 0, 30, &mut view);
    test_entrydelay(&mut emu, true, 0, 1, 29, &mut view);
    test_entrydelay(&mut emu, true, 0, 2, 28, &mut view);
    test_entrydelay(&mut emu, true, 0, 3, 27, &mut view);
}

fn test_entrydelay(
    emu: &mut NesState,
    lineclear: bool,
    rows: usize,
    fc: u8,
    expected: usize,
    view: &mut Video,
) {
    emu.reset();

    util::run_n_vblanks(emu, 4);
    let game_mode = labels::get("gameMode") as usize;
    let play_state = labels::get("playState") as usize;
    let game_mode_state = labels::get("gameModeState") as usize;
    let tetrimino_x = labels::get("tetriminoX") as usize;
    let tetrimino_y = labels::get("tetriminoY") as usize;
    let main_loop = labels::get("mainLoop");
    let level_number = labels::get("levelNumber") as usize;
    let current_piece = labels::get("currentPiece") as usize;
    let frame_counter = labels::get("frameCounter") as usize;
    let autorepeat_y = labels::get("autorepeatY") as usize;

    emu.memory.iram_raw[level_number] = 29;
    emu.memory.iram_raw[game_mode] = 4;
    emu.memory.iram_raw[game_mode_state] = 0;
    emu.registers.pc = main_loop;
    while emu.memory.iram_raw[play_state] != 1 {
        emu.run_until_vblank();
    }
    emu.memory.iram_raw[tetrimino_x] = 5;
    emu.memory.iram_raw[tetrimino_y] = 0;
    emu.memory.iram_raw[autorepeat_y] = 0;
    emu.memory.iram_raw[current_piece] = 18;
    let mut playfield: String = "".to_string();
    if lineclear {
        playfield.push_str("\n###    ###");
    };
    for _ in 0..rows {
        playfield.push_str("\n    #");
    }
    playfield::set_str(emu, &playfield);
    let mut frames = 0;
    while emu.memory.iram_raw[play_state] != 2 {
        view.render(emu);
        emu.run_until_vblank();
    }
    emu.memory.iram_raw[frame_counter] = fc;
    while emu.memory.iram_raw[play_state] != 1 {
        view.render(emu);
        frames += 1;
        emu.run_until_vblank();
    }
    view.render(emu);
    assert_eq!(frames, expected);
    println!("lineclear={} fc={} row={} frames={}", lineclear, fc, 19 - rows, frames);
    // validate initialized

    // emu.memory.iram_raw[labels::get("currentPiece") as usize] = 0x12;
    // emu.memory.iram_raw[labels::get("tetriminoX") as usize] = 0x5;
    // emu.memory.iram_raw[labels::get("tetriminoY") as usize] = 0x12;
    // emu.memory.iram_raw[labels::get("autorepeatY") as usize] = 0;
    // emu.memory.iram_raw[labels::get("vramRow") as usize] = 0;
    //
    // // skip lock tetrimino and setup a tetris to be cleared
    // emu.memory.iram_raw[labels::get("playState") as usize] = 3;
    // for block in 0x4a0..0x4c8 {
    //     emu.memory.iram_raw[block as usize] = 0x7b;
    //     };
    //
    // // cycle through remainder of entry delay and animation
    // for _ in 0..32 {
    //     emu.run_until_vblank();
    // }
    //
    // // validate tetris was scored and playfield looks the same
    // assert_eq!(emu.memory.iram_raw[lines], 4);
    // assert_eq!(expected_playfield, playfield::get_str(emu));
    //
    // // validate allegro not set
    // assert_eq!(emu.memory.iram_raw[allegro], 0);
}
