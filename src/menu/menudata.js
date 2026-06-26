const seedFlag = ["TYPE_BOOL", "Seed Enabled", "seedEnabled"];
const seedInput = ["TYPE_HEX", "seed", 6, "set_seed_input"];
const linecapWhen = [
    "TYPE_CHOICES",
    "linecap",
    ["off", "level", "lines"],
    "linecapWhen",
];
const linecapHow = [
    "TYPE_CHOICES",
    "linecap how",
    ["ks*2", "floor", "inviz", "halt"],
    "linecapHow",
];
const linecapLevel = ["TYPE_NUMBER", "linecap level", 0, "linecapLevel"];
const linecapLines = ["TYPE_BCD", "linecap lines", 4, "linecapLines"];
const dasOnly = ["TYPE_BOOL", "das only", "dasOnlyFlag"];
const vitsScoreFlag = ["TYPE_BOOL", "vits scoring", "vitsScoreFlag"];

const scoringModifier = [
    "TYPE_CHOICES",
    "scoring",
    ["classic", "letters", "7digit", "m", "capped", "hidden"],
    "scoringModifier",
];
const paceModifier = ["TYPE_FF_OFF", "Pace", 16, "paceModifier"];
const hzFlag = ["TYPE_BOOL", "HZ DISPLAY", "hzFlag"];
const inputDisplayFlag = ["TYPE_BOOL", "Input Display", "inputDisplayFlag"];
const disableFlash = ["TYPE_BOOL", "Disable Flash", "disableFlashFlag"];
const darkMode = [
    "TYPE_CHOICES",
    "dark mode",
    ["off", "on", "neon", "lite", "teal", "og"],
    "darkModifier",
];

const paletteSelection = [
    "TYPE_CHOICES",
    "palette",
    ["vanilla", "pride", "white", "custom"],
    "paletteModifier",
];

const customPaletteMenu = {
    "palette[mode=default]": [
        ["TYPE_HEX", "0", 6, "customLevel0"],
        ["TYPE_HEX", "1", 6, "customLevel1"],
        ["TYPE_HEX", "2", 6, "customLevel2"],
        ["TYPE_HEX", "3", 6, "customLevel3"],
        ["TYPE_HEX", "4", 6, "customLevel4"],
        ["TYPE_HEX", "5", 6, "customLevel5"],
        ["TYPE_HEX", "6", 6, "customLevel6"],
        ["TYPE_HEX", "7", 6, "customLevel7"],
        ["TYPE_HEX", "8", 6, "customLevel8"],
        ["TYPE_HEX", "9", 6, "customLevel9"],
        ["TYPE_CUSTOM", "load vanilla", "LOAD_VANILLA"],
        ["TYPE_CUSTOM", "load pride", "LOAD_PRIDE"],
        ["TYPE_CUSTOM", "load white", "LOAD_WHITE"],
        ["TYPE_CUSTOM", "load bugged", "LOAD_BUGGED"],
        ["TYPE_NUMBER", "bug offset", 0, "buggedModifier"],
    ],
};

const goToCustomPalette = ["TYPE_SUBMENU", "custom palette", customPaletteMenu];
const crashModifier = [
    "TYPE_CHOICES",
    "crash",
    ["off", "show", "top", "crash"],
    "crashModifier",
];
const strictCrashFlag = ["TYPE_BOOL", "strict crash", "strictFlag"];
const disablePause = ["TYPE_BOOL", "disable pause", "disablePauseFlag"];
const debugFlag = ["TYPE_BOOL", "block tool", "debugFlag"];
const palFlag = ["TYPE_BOOL", "pal mode", "palFlag"];
const keyboardFlag = ["TYPE_BOOL", "keyboard", "keyboardFlag"];
const qualFlag = ["TYPE_BOOL", "qual", "qualFlag"];
const goofyFlag = ["TYPE_CUSTOM", "toggle goofy", "GOOFY_TOGGLE"];
const clearScores = ["TYPE_CUSTOM", "clear scores", "CLEAR_SCOREBOARD"];
const resetDefaults = ["TYPE_CUSTOM", "reset defaults", "RESET_DEFAULTS"];

const floorModifier = ["TYPE_NUMBER", "floor", 16, "floorModifier"];
const crunchLeftModifier = [
    "TYPE_NUMBER",
    "crunch left",
    4,
    "crunchLeftModifier",
];
const crunchRightModifier = [
    "TYPE_NUMBER",
    "crunch right",
    4,
    "crunchRightModifier",
];
const invisibleFlag = ["TYPE_BOOL", "invisible", "invisibleOptionFlag"];
const ghostPiece = ["TYPE_BOOL", "ghost", "ghostPieceFlag"];
const hardDrop = ["TYPE_BOOL", "hardDrop", "hardDropFlag"];

const horizMirror = ["TYPE_BOOL", "mirror horiz", "mirrorHorizFlag"];
const vertMirror = ["TYPE_BOOL", "mirror vert", "mirrorVertFlag"];
const teppozFlag = ["TYPE_BOOL", "teppoz", "teppozFlag"];
const sxtoklFlag = ["TYPE_BOOL", "sxtokl", "sxtoklFlag"];
const palpepFlag = ["TYPE_BOOL", "palpep", "palpepFlag"];
const startScore = ["TYPE_NUMBER", "score x100k", 16, "startScore"];
const startLines = ["TYPE_NUMBER", "lines x10", 31, "startLines"];

const presetModifier = [
    "TYPE_CHOICES",
    "setup",
    ["z", "t/s", "t", "i", "buco", "various", "ljspin", "ljdouble"],
    "presetModifier",
];
const typeBModifier = ["TYPE_NUMBER", "height", 9, "typeBModifier"];
const typeBSeed = ["TYPE_HEX", "seed", 4, "b_seed_input"];
const typeBSeedFlag = ["TYPE_BOOL", "seed enabled", "typeBSeedFlag"];
const bTypeLines = ["TYPE_BCD", "lines", 2, "bTypeLines"];
const checkerModifier = ["TYPE_NUMBER", "height", 9, "checkerModifier"];
const quickTapLeftModifier = ["TYPE_NUMBER", "left", 20, "tapLeftModifier"];
const quickTapRightModifier = ["TYPE_NUMBER", "right", 20, "tapRightModifier"];
const quickTapLeftColumn = [
    "TYPE_CHOICES",
    "left column",
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
    "tapLeftColumn",
];
const quickTapRightColumn = [
    "TYPE_CHOICES",
    "right column",
    ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"],
    "tapRightColumn",
];
const practisePiece = [
    "TYPE_CHOICES",
    "piece",
    ["T", "J", "Z", "O", "S", "L", "I"],
    "practisePiece",
];
const marathonScoreFlag = [
    "TYPE_CHOICES",
    "fixed score",
    ["on", "off"],
    "marathonScoreFlag",
];
const marathonLevelModifier = [
    "TYPE_CHOICES",
    "level up",
    ["fixed", "normal", "zero"],
    "marathonLevelModifier",
];

const tapqtyModifier = ["TYPE_NUMBER", "height", 16, "tapqtyModifier"];
const noLineClearDelayFlag = [
    "TYPE_BOOL",
    "no line clear",
    "noLineClearDelayFlag",
];
const garbageModifier = [
    "TYPE_CHOICES",
    "mode",
    ["tetris", "normal", "smart", "hard", "infinite"],
    "garbageModifier",
];
const droughtModifier = ["TYPE_NUMBER", "modifier", 20, "droughtModifier"];
const lowStackRowModifier = [
    "TYPE_NUMBER",
    "height",
    20,
    "lowStackRowModifier",
];

const noWallChargeFlag = [
    "TYPE_CHOICES",
    "wall charge",
    ["on", "off"],
    "noWallChargeFlag",
];
const disableDasFlag = ["TYPE_CHOICES", "das", ["on", "off"], "disableDasFlag"];
const anydasDas = ["TYPE_NUMBER", "delay", 31, "dasModifier"];
const anydasArr = ["TYPE_NUMBER", "arrrr", 31, "arrModifier"];
const anydasEntryDelay = [
    "TYPE_CHOICES",
    "entry charge",
    ["off", "hydrant", "kitaru"],
    "entryChargeModifier",
];
const trtFlag = ["TYPE_BOOL", "tetris rate", "trtFlag"];
const dasMeterFlag = ["TYPE_BOOL", "das meter", "dasMeterFlag"];
const gameTimerFlag = ["TYPE_BOOL", "game timer", "gameTimerFlag"];

const tapQtyMenu = {
    "tap quantity[mode=tapqty]": [tapqtyModifier, noLineClearDelayFlag],
};
const marathonMenu = {
    "marathon[mode=marathon]": [marathonScoreFlag, marathonLevelModifier],
};
const droughtMenu = {
    "drought[mode=drought]": [droughtModifier],
};
const checkerMenu = {
    "checkerboard[mode=checkerboard]": [checkerModifier],
};
const garbageMenu = {
    "garbage[mode=garbage]": [garbageModifier],
};
const lowstackMenu = {
    "lowstack[mode=lowstack]": [lowStackRowModifier],
};

const bMenu = {
    "b-type[mode=typeb]": [typeBModifier, typeBSeed, typeBSeedFlag, bTypeLines],
};
const setupsMenu = {
    "setups[mode=presets]": [presetModifier],
};
const quickTapMenu = {
    "(quick)tap[mode=tap]": [
        quickTapLeftModifier,
        quickTapRightModifier,
        quickTapLeftColumn,
        quickTapRightColumn,
        practisePiece,
        debugFlag,
    ],
};
const mainMenu = {
    "play tetris[mode=tetris]": [
        ["TYPE_GAMEMODE", "t-spins", "MODE_TSPINS"],
        ["TYPE_GAMEMODE", "stacking", "MODE_STACKING"],
        ["TYPE_SUBMENU", "setups", setupsMenu],
        ["TYPE_SUBMENU", "b-type", bMenu],
        ["TYPE_SUBMENU", "(quick)tap", quickTapMenu],
        ["TYPE_SUBMENU", "marathon", marathonMenu],
        ["TYPE_SUBMENU", "tap quantity", tapQtyMenu],
        ["TYPE_SUBMENU", "checkerboard", checkerMenu],
        ["TYPE_SUBMENU", "garbage", garbageMenu],
        ["TYPE_SUBMENU", "drought", droughtMenu],
        ["TYPE_SUBMENU", "lowstack", lowstackMenu],
        ["TYPE_GAMEMODE", "kill*2", "MODE_KILLX2"],
        ["TYPE_GAMEMODE", "tap/roll speed", "MODE_SPEED_TEST"],
    ],
    "tournament[mode=default]": [
        seedInput,
        seedFlag,
        linecapWhen,
        linecapHow,
        linecapLevel,
        linecapLines,
        dasOnly,
        vitsScoreFlag,
    ],
    "general[mode=default]": [
        disablePause,
        debugFlag,
        palFlag,
        qualFlag,
        keyboardFlag,
        crashModifier,
        strictCrashFlag,
        goofyFlag,
        clearScores,
        resetDefaults,
    ],

    "modify game[mode=default]": [
        floorModifier,
        crunchLeftModifier,
        crunchRightModifier,
        invisibleFlag,
        ghostPiece,
        hardDrop,
        horizMirror,
        vertMirror,
        teppozFlag,
        sxtoklFlag,
        palpepFlag,
        startScore,
        startLines,
    ],

    "display[mode=default]": [
        scoringModifier,
        hzFlag,
        inputDisplayFlag,
        darkMode,
        disableFlash,
        paceModifier,
        trtFlag,
        dasMeterFlag,
        gameTimerFlag,
        paletteSelection,
        goToCustomPalette,
    ],

    "das[mode=default]": [
        anydasDas,
        anydasArr,
        anydasEntryDelay,
        noWallChargeFlag,
        disableDasFlag,
    ],
};

const extraSpriteStrings = [
    "pause",
    "block",
    "clear?",
    "sure?!",
    "confetti",
    "wait",
];

module.exports = { mainMenu, extraSpriteStrings };
