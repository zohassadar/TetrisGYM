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

    let (shuffled, by_repeats) = rng::get_pre_shuffle();

    blocks.set_input( (0x77, 0x77, 0x77));
    let (s1, s2, s3) = (0x77, 0x77, 0x77);
    let sequence = rng::crunch_seed(s1, s2, s3, &shuffled, &by_repeats, 1000);
    let string = rng::get_string_from_sequence(&sequence);
    string.chars().for_each(|block| {
        assert_eq!(blocks.next(), block.into());
    });

    blocks.set_input( (0x99, 0x99, 0x99));
    let (s1, s2, s3) = (0x99, 0x99, 0x99);
    let sequence = rng::crunch_seed(s1, s2, s3, &shuffled, &by_repeats, 1000);
    let string = rng::get_string_from_sequence(&sequence);
    string.chars().for_each(|block| {
        assert_eq!(blocks.next(), block.into());
    });

    blocks.set_input( (0xAA, 0xAA, 0xAA));
    let (s1, s2, s3) = (0xAA, 0xAA, 0xAA);
    let sequence = rng::crunch_seed(s1, s2, s3, &shuffled, &by_repeats, 1000);
    let string = rng::get_string_from_sequence(&sequence);
    string.chars().for_each(|block| {
        assert_eq!(blocks.next(), block.into());
    });

    blocks.set_input( (0xBB, 0xBB, 0xBB));
    let (s1, s2, s3) = (0xBB, 0xBB, 0xBB);
    let sequence = rng::crunch_seed(s1, s2, s3, &shuffled, &by_repeats, 1000);
    let string = rng::get_string_from_sequence(&sequence);
    string.chars().for_each(|block| {
        assert_eq!(blocks.next(), block.into());
    });

    blocks.set_input( (0xCC, 0xCC, 0xCC));
    let (s1, s2, s3) = (0xCC, 0xCC, 0xCC);
    let sequence = rng::crunch_seed(s1, s2, s3, &shuffled, &by_repeats, 1000);
    let string = rng::get_string_from_sequence(&sequence);
    string.chars().for_each(|block| {
        assert_eq!(blocks.next(), block.into());
    });

    blocks.set_input( (0xDD, 0xDD, 0xDD));
    let (s1, s2, s3) = (0xDD, 0xDD, 0xDD);
    let sequence = rng::crunch_seed(s1, s2, s3, &shuffled, &by_repeats, 1000);
    let string = rng::get_string_from_sequence(&sequence);
    string.chars().for_each(|block| {
        assert_eq!(blocks.next(), block.into());
    });

    blocks.set_input( (0xEE, 0xEE, 0xEE));
    let (s1, s2, s3) = (0xEE, 0xEE, 0xEE);
    let sequence = rng::crunch_seed(s1, s2, s3, &shuffled, &by_repeats, 1000);
    let string = rng::get_string_from_sequence(&sequence);
    string.chars().for_each(|block| {
        assert_eq!(blocks.next(), block.into());
    });
}
