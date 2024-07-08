use crate::{block, labels, util};
use rusticnes_core::nes::NesState;
use rustyseed::rng;

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
        self.emu.memory.iram_raw[labels::get("spawnID") as usize] = 0;
        self.emu.memory.iram_raw[(labels::get("set_seed_input") + 0) as usize] = seed.0;
        self.emu.memory.iram_raw[(labels::get("set_seed") + 0) as usize] = seed.0;
        self.emu.memory.iram_raw[(labels::get("set_seed_input") + 1) as usize] = seed.1;
        self.emu.memory.iram_raw[(labels::get("set_seed") + 1) as usize] = seed.1;
        self.emu.memory.iram_raw[(labels::get("set_seed_input") + 2) as usize] = seed.2;
        self.emu.memory.iram_raw[(labels::get("set_seed") + 2) as usize] = seed.2;
    }

    pub fn next(&mut self) -> block::Block {
        self.emu.registers.pc = labels::get("pickTetriminoSeed");

        util::run_to_return(&mut self.emu, false);

        self.emu.memory.iram_raw[labels::get("spawnID") as usize].into()
    }
}

pub fn test() {
    let mut blocks = SPS::new();

    blocks.set_input((0x10, 0x10, 0x10));
    "ZJOTLTZJLZJSZISIJOLITJSILZJILITSISZOITIZSZJLLTIOZJZSZISIJZTIZJTSOJSJISJOOTSJTOTZSZTZSLTZTOTSIZJZIJIL".chars().for_each(|block| {
        assert_eq!(blocks.next(), block.into());
    });

    blocks.set_input((0x12, 0x34, 0x56));
    "ZTZIJIJOZTSOSZJZOSLIOIJIJSTZSTTJISSTOIZJITJOZJITSOSZSJLTISJOITTLSLJTZTZOZSLJTJZSLTSOTLOJLSJSJTJILOJS".chars().for_each(|block| {
        assert_eq!(blocks.next(), block.into());
    });

    blocks.set_input((0x87, 0xAB, 0x12));
    "OZIJSOTZSJTSTJZLOLJOJISOZOIOZJITILSSJZLOIJSTITLSOJILTSOOLZOOIJOZLTLSISIJIJTOLSIJILSLOLJLTOSOSLOIZSIS".chars().for_each(|block| {
        assert_eq!(blocks.next(), block.into());
    });

    blocks.set_input((0x13, 0x37, 0x02));
    "OJSTZSIOLSIJTSZILJZJJLZLISISJTLZTSZTJOJOSJSZLITJOIOTITILTOSTJSZTSOOIOJSIITLJOZSIOJOTZTLJLIOJLITSSLSLIJIIOLOISLZJLIJJTIZIJOJISLTIJTOTZIOILSTTLTZIZJSOLOZOZOLOTZTZOTZOSIOTJJTSIZSOLTOLIZSOZOTZISLJTSZLOISO".chars().for_each(|block| {
        assert_eq!(blocks.next(), block.into());
    });

    blocks.set_input((0x00, 0x02, 0x06));
    "STJTJSILJSIIZLJLJOSOTIJSTOIOLIZIZIOTSLOSZTZOLSZTIJZIOIJLJLJTZJOLZJSZILSJTLIOTJSSLIJOZJOTITZSSTTIOITJ".chars().for_each(|block| {
        assert_eq!(blocks.next(), block.into());
    });

    let (shuffled, by_repeats) = rng::get_pre_shuffle();

    static LENGTH: i32 = 10;
    for seed in 0..0x1000000 {
        if seed % 0x100000 == 0 {
            println!("{:X}", seed >> 20);
        }
        let s1 = ((seed >> 16) & 0xFF) as u8;
        let s2 = ((seed >> 8) & 0xFF) as u8;
        let s3 = (seed & 0xFF) as u8;
        if s1 == 0 && s2 & 0xFE == 0 { continue };
        if s3 & 0x08 == 0x08 || s2 & 0x01 == 0x01 { continue };
        let sequence = rng::crunch_seed(s1, s2, s3, &shuffled, &by_repeats, LENGTH);
        let string = rng::get_string_from_sequence(&sequence);
        blocks.set_input((s1, s2, s3));
        let gym_string: String = (0..LENGTH).map(|_| format!("{:#?}", blocks.next())).collect();

        assert_eq!((format!("{seed:06X}"),gym_string), (format!("{seed:06X}"),string));
    }
}
