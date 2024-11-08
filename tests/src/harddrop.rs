use rusticnes_core::nes::NesState;

use crate::{ util, labels, playfield};

const TETRIS_READY: &str = r##"#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
##### ####
##### ####
##### ####
##### ####"##;

const TETRIS_READY_FULL: &str = r##"##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####"##;

const TETRIS_FULL_AFTER: &str = r##"



##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####
##### ####"##;

const TEST1_AFTER: &str = r##"



#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#"##;

const TEST2_AFTER: &str = r##"

#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#   ##
##### ####
##### ####"##;


const TETRIS_READY_PC: &str = r##"














##### ####
##### ####
##### ####
##### ####"##;


const BLANK_BOARD: &str = r##"


















"##;

pub fn test() {
    let mut emu = util::emulator(None);
    let mut max_cycles: u32;
    let mut cycles: u32;

    cycles = test_harddropped_piece(&mut emu, TETRIS_READY, TEST1_AFTER, 0x11);
    max_cycles = cycles;

    cycles = test_harddropped_piece(&mut emu, TETRIS_READY, TEST2_AFTER, 0xF);
    max_cycles = if cycles > max_cycles { cycles } else { max_cycles };

    cycles = test_harddropped_piece(&mut emu, TETRIS_READY_PC, BLANK_BOARD, 0x11);
    max_cycles = if cycles > max_cycles { cycles } else { max_cycles };

    cycles = test_harddropped_piece(&mut emu, TETRIS_READY_FULL, TETRIS_FULL_AFTER, 0x11);
    max_cycles = if cycles > max_cycles { cycles } else { max_cycles };

    println!("Hard Drop max cycles: {}", max_cycles);

    }

fn test_harddropped_piece(emu: &mut NesState, start: &str, finish: &str, piece: u8 ) -> u32 {
    emu.reset();

    for _ in 0..3 { emu.run_until_vblank(); }

    let game_mode = labels::get("gameMode") as usize;
    let main_loop = labels::get("mainLoop");
    let level_number = labels::get("levelNumber") as usize;
    let practise_type = labels::get("practiseType") as usize;
    let mode_harddrop = labels::get("MODE_HARDDROP") as u8;
    let button_up = labels::get("BUTTON_UP") as u8;
    let newly_pressed_buttons = labels::get("newlyPressedButtons") as usize;
    let active_tetrimino = labels::get("playState_playerControlsActiveTetrimino");

    emu.memory.iram_raw[practise_type] = mode_harddrop;
    emu.memory.iram_raw[game_mode] = 4;
    emu.memory.iram_raw[level_number] = 18;
    emu.registers.pc = main_loop;
    emu.memory.iram_raw[labels::get("playfieldAddr") as usize + 1] = 4;

    playfield::clear(emu);
    util::run_n_vblanks(emu, 7);
    playfield::set_str(emu, start);

    emu.memory.iram_raw[labels::get("playState") as usize] = 1;
    emu.memory.iram_raw[labels::get("autorepeatY") as usize] = 0;
    emu.memory.iram_raw[labels::get("currentPiece") as usize] = piece;
    emu.memory.iram_raw[labels::get("tetriminoX") as usize] = 0x5;
    emu.memory.iram_raw[labels::get("tetriminoY") as usize] = 0x0;
    emu.memory.iram_raw[labels::get("vramRow") as usize] = 0x20;
    emu.memory.iram_raw[newly_pressed_buttons] = button_up;
    emu.registers.pc = active_tetrimino;

    let cycles = util::cycles_to_return(emu);

    assert_eq!(finish, playfield::get_str(emu));

    return cycles;
}
