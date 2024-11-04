use crate::{block, labels, util};
use rusticnes_core::nes::NesState;

pub struct SPS {
    emu: NesState,
}

impl SPS {
    pub fn new() -> Self {
        Self {
            emu: util::emulator(None),
        }
    }

    pub fn set_input(&mut self, seed: (u8, u8, u8)) {
        self.emu.memory.iram_raw[0xff as usize] = 0; // flag for init
        self.emu.memory.iram_raw[labels::get("spawnID") as usize] = 0;
        self.emu.memory.iram_raw[labels::get("practiseType") as usize] = 2;
        self.emu.memory.iram_raw[(labels::get("set_seed_input") + 0) as usize] = seed.0;
        self.emu.memory.iram_raw[(labels::get("set_seed") + 0) as usize] = seed.0;
        self.emu.memory.iram_raw[(labels::get("set_seed_input") + 1) as usize] = seed.1;
        self.emu.memory.iram_raw[(labels::get("set_seed") + 1) as usize] = seed.1;
        self.emu.memory.iram_raw[(labels::get("set_seed_input") + 2) as usize] = seed.2;
        self.emu.memory.iram_raw[(labels::get("set_seed") + 2) as usize] = seed.2;

    }

    pub fn next(&mut self) -> block::Block {
        if self.emu.memory.iram_raw[0xff as usize] == 0 {
            self.emu.memory.iram_raw[0xff as usize] = 1;
            self.emu.registers.pc = labels::get("initDroughtInfoAndChooseNext");
            util::run_to_return(&mut self.emu, false);
        }
        else {
            self.emu.registers.pc = labels::get("chooseNextTetrimino");
            util::run_to_return(&mut self.emu, false);
        }
        self.emu.registers.a.into()
    }
}

pub fn test() {
    let mut blocks = SPS::new();
    println!("101010");
    blocks.set_input((0x10, 0x10, 0x10));
    "ZJOTLTZJLZJSZISIJOLITJSILZJILITSISZOITIZSZJLLTIOZJZSZISIJZTIZJTSOJSJISJOOTSJTOTZSZTZSLTZTOTSIZJZIJIL".chars().enumerate().for_each(|(i, block)| {
        let next = blocks.next();
        let b = block.into();
        if next != b {

        println!("Piece #{} {:?} != {:?}", i, b, next);
        assert_eq!(1,0)
        }
    });

    println!("123456");
    blocks.set_input((0x12, 0x34, 0x56));
    "ZTZIJIJOZTSOSZJZOSLIOIJIJSTZSTTJISSTOIZJITJOZJITSOSZSJLTISJOITTLSLJTZTZOZSLJTJZSLTSOTLOJLSJSJTJILOJS".chars().enumerate().for_each(|(i, block)| {
        let next = blocks.next();
        let b = block.into();
        if next != b {

        println!("Piece #{} {:?} != {:?}", i, b, next);
        assert_eq!(1,0)
        }
    });

    println!("87AB12");
    blocks.set_input((0x87, 0xAB, 0x12));
    "OZIJSOTZSJTSTJZLOLJOJISOZOIOZJITILSSJZLOIJSTITLSOJILTSOOLZOOIJOZLTLSISIJIJTOLSIJILSLOLJLTOSOSLOIZSIS".chars().enumerate().for_each(|(i, block)| {
        let next = blocks.next();
        let b = block.into();
        if next != b {

        println!("Piece #{} {:?} != {:?}", i, b, next);
        assert_eq!(1,0)
        }
    });

    println!("133702");
    blocks.set_input((0x13, 0x37, 0x02));
    "OJSTZSIOLSIJTSZILJZJJLZLISISJTLZTSZTJOJOSJSZLITJOIOTITILTOSTJSZTSOOIOJSIITLJOZSIOJOTZTLJLIOJLITSSLSLIJIIOLOISLZJLIJJTIZIJOJISLTIJTOTZIOILSTTLTZIZJSOLOZOZOLOTZTZOTZOSIOTJJTSIZSOLTOLIZSOZOTZISLJTSZLOISO".chars().enumerate().for_each(|(i, block)| {
        let next = blocks.next();
        let b = block.into();
        if next != b {

        println!("Piece #{} {:?} != {:?}", i, b, next);
        assert_eq!(1,0)

        }
    });
}
