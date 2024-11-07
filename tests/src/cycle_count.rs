use crate::{util, score, labels, playfield};

pub fn count_cycles() {
    // count_hz_cycles();
    // count_max_score_cycles();
    // count_mode_score_cycles();
    count_crunch_cycles();
}

fn count_hz_cycles() {
    // check max hz calculation amount
    let mut emu = util::emulator(None);

    let hz_flag = labels::get("hzFlag") as usize;
    let game_mode = labels::get("gameMode") as usize;
    let x = labels::get("tetriminoX") as usize;
    let y = labels::get("tetriminoY") as usize;
    let main_loop = labels::get("mainLoop");
    let level_number = labels::get("levelNumber") as usize;
    let debounce = labels::get("hzDebounceThreshold") as usize;

    util::run_n_vblanks(&mut emu, 3);

    emu.memory.iram_raw[hz_flag] = 1;
    emu.memory.iram_raw[level_number] = 18;
    emu.memory.iram_raw[game_mode] = 4;
    emu.registers.pc = main_loop;

    util::run_n_vblanks(&mut emu, 5);

    let mut highest = 0;

    for buttons in &[
        "L.L.L.L.L",
        "RR...R...R...R.R.",
        ".....L.L..L.L.",
        "LLL..L.L...L.R.R..L...R....L....L...L....L",
        "R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R.R",
    ] {
        buttons.chars().for_each(|button| {
            emu.memory.iram_raw[x] = 5;
            emu.memory.iram_raw[y] = 0;
            util::set_controller(&mut emu, button);
            highest = highest.max(util::cycles_to_vblank(&mut emu));
        });

        util::run_n_vblanks(&mut emu, debounce + 1);
    }

    println!("hz display most cycles to vblank: {}", highest);
}

fn count_max_score_cycles() {
    // check max scoring cycle amount
    let mut emu = util::emulator(None);

    let completed_lines = labels::get("completedLines") as usize;
    let add_points = labels::get("addPointsRaw");
    let level_number = labels::get("levelNumber") as usize;

    let mut score = move |score: u32, lines: u8, level: u8| {
        score::set(&mut emu, score);
        emu.registers.pc = add_points;
        emu.memory.iram_raw[completed_lines] = lines;
        emu.memory.iram_raw[level_number] = level;
        util::cycles_to_return(&mut emu)
    };

    let mut highest = 0;

    for level in 0..=255 {
        for lines in 0..=4 {
            let count = score(999999, lines, level);

            if count > highest {
                highest = count;
            }
        }
    }

    println!("scoring routine most cycles: {}", highest);
}

fn count_crunch_cycles() {
    let mut highest_init: u32 = 0;
    let mut highest_line: u32 = 0;
    let mut init_setting: u32 = 0xff;
    let mut line_setting: u32 = 0xff;

    let mut emu = util::emulator(None);

    let init_routine = labels::get("advanceGameCrunch") as u16;
    let line_routine = labels::get("advanceSides") as u16;
    let crunch_modifier = labels::get("crunchModifier") as usize;
    let playfield_addr = labels::get("playfieldAddr") as usize;

    for crunch_setting in (0..=0xF).rev() {
        emu.reset();
        util::run_n_vblanks(&mut emu, 5);
        emu.memory.iram_raw[crunch_modifier] = crunch_setting as u8;
        emu.memory.iram_raw[playfield_addr + 1] = 4;
        emu.registers.pc = line_routine;
        emu.registers.a = 1;
        let line_cycles = util::cycles_to_return(&mut emu);
        println!("{} setting {:X}", line_cycles, crunch_setting);
        if line_cycles > highest_line {
            highest_line = line_cycles;
            line_setting = crunch_setting;
        }

        emu.reset();
        util::run_n_vblanks(&mut emu, 5);
        emu.memory.iram_raw[crunch_modifier] = crunch_setting as u8;
        emu.memory.iram_raw[playfield_addr + 1] = 4;
        emu.registers.pc = init_routine;
        let init_cycles = util::cycles_to_return(&mut emu);
        println!("{} setting {:X}", init_cycles, crunch_setting);
        if init_cycles > highest_init {
            highest_init = init_cycles;
            init_setting = crunch_setting;
        }
    }

    println!("Highest crunch init: {} setting {:X}", highest_init, init_setting);
    println!("Highest crunch line: {} setting {:X}", highest_line, line_setting);
}

fn count_mode_score_cycles() {
    // check clock cycles frames in each mode
    let mut emu = util::emulator(None);

    for mode in 0..labels::get("MODE_GAME_QUANTITY") {

        emu.reset();

        for _ in 0..3 { emu.run_until_vblank(); }

        let practise_type = labels::get("practiseType") as usize;
        let game_mode = labels::get("gameMode") as usize;
        let main_loop = labels::get("mainLoop");
        let level_number = labels::get("levelNumber") as usize;


        emu.memory.iram_raw[practise_type] = mode as _;
        emu.memory.iram_raw[level_number] = 235;
        emu.memory.iram_raw[game_mode] = 4;
        emu.registers.pc = main_loop;

        for _ in 0..5 { emu.run_until_vblank(); }

        let (mut highest, mut _level, mut lines) = (0, 0, 0);

        for line in 0..5 {
            emu.memory.iram_raw[labels::get("vramRow") as usize] = 0;

            playfield::clear(&mut emu);

            playfield::set_str(&mut emu, match line {
                0 => "",
                1 => "##### ####",
                2 => "##### ####\n##### ####",
                3 => "##### ####\n##### ####\n##### ####",
                4 => "##### ####\n##### ####\n##### ####\n##### ####",
                _ => unreachable!("line"),
            });

            emu.memory.iram_raw[labels::get("currentPiece") as usize] = 0x11;
            emu.memory.iram_raw[labels::get("tetriminoX") as usize] = 0x5;
            emu.memory.iram_raw[labels::get("tetriminoY") as usize] = 0x12;
            emu.memory.iram_raw[labels::get("autorepeatY") as usize] = 0;

            for _ in 0..45 {
                let cycles = util::cycles_to_vblank(&mut emu);

                if cycles > highest {
                    highest = cycles;
                    _level = emu.memory.iram_raw[level_number];
                    lines = line;
                }
            }
        }

        println!("cycles to vblank {} lines {} mode {}", highest, lines, mode);
    }
}
