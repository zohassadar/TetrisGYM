const {
    readStripe,
    writeRLE,
    printNT,
    drawTiles,
    drawRect,
    drawAttrs,
    flatLookup,
} = require('./nametables');

const topScreenModes = 21;
const botScreenModes = 1;
const totalModes = topScreenModes + botScreenModes;

const supports_scrolltris = (process.env.INES_MAPPER == 1 || process.env.INES_MAPPER == 5);

var modes = [];
modes.push("TETRIS");
// modes.push("T-SPINS");
modes.push("SEED");
// modes.push("STACKING");
// modes.push("PACE");
// modes.push("SETUPS");
// modes.push("B-TYPE");
modes.push("FLOOR");
modes.push("CRUNCH");
// modes.push("(QUICK)TAP");
// modes.push("TRANSITION");
// modes.push("TAP QUANTITY");
// modes.push("CHECKERBOARD");
modes.push("GARBAGE");
modes.push("DROUGHT");
// modes.push("KILLSCREEN »2");
modes.push("INVISIBLE");
// modes.push("HARD DROP");
modes.push("SPEED");
modes.push("DAS DELAY");
// modes.push("TAP/ROLL SPEED");
modes.push("SCORING");
modes.push("HZ DISPLAY");
modes.push("INPUT DISPLAY");
modes.push("DISABLE FLASH");
modes.push("DISABLE PAUSE");
modes.push("DISABLE MELT");
modes.push("PRIDE COLORS");
if (supports_scrolltris){
    modes.push("SCROLLTRIS");
    };
modes.push("GOOFY FOOT");
modes.push("BLOCK TOOL");
// modes.push("LINECAP");
modes.push("DAS ONLY");
// modes.push("QUAL MODE");
modes.push("PAL MODE");

if (modes.length < totalModes){
    var padding = new Array(totalModes-modes.length).fill("");
    modes = modes.concat(padding);
    }

modes = modes.map(str => str.padEnd(24, " "));


const lookup = flatLookup(`
0123456789ABCDEF
GHIJKLMNOPQRSTUV
WXYZ-,˙>########
########qweadzxc
###############/
##!##~######[]()
#########»#####.
################
################
################
################
################
################
################
################
###############
`);

const buffer = readStripe(__dirname + '/game_type_menu_nametable.bin');
const extra = [...buffer];

printNT(buffer, lookup);

drawTiles(buffer, lookup, `
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a       ZERO TO ZERO         d#q
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a    ${modes.slice(0,topScreenModes).join("d#\n#a    ")}d#
`);drawTiles(extra, lookup, `
#a    ${modes.slice(topScreenModes,totalModes).join("d#\n#a    ")}d#
#a                            d#
#a BASED ON GYM BY KIRJAVA    d#
#a V5                         d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
`);


// drawRect(buffer, 8, 2, 10, 5, 0xB0); // draw logo
// drawRect(extra, 20, 0, 5, 5, 0x9A); // draw QR code

const urlX = 3;
const urlY = 3;
drawRect(extra, urlX, urlY, 12, 1, 0x74);
drawRect(extra, urlX+12, urlY, 12, 1, 0x84);

drawAttrs(buffer, [`
    2222222222222222
    2221111111111222
    2221111111111222
    2222222222222222
    2222222222222222
    2222222222222222
    2222222222222222
    2222222222222222
`,`
    2222222222222222
    2222222222222222
    2222222222222222
    2222222222222222
    2222222222222222
    2222222222222222
    2222222222222222
    2222222222222222
`]);

const line = '2'.repeat(16);
const screen = Array.from({ length: 8 }, () => line).join('\n');
drawAttrs(extra, [`
    2222222222222222
    2333333333333332
    2222222222222222
    2222222222222222
    2222222222222222
    2222222222222222
    2222222222222222
    2222222222222222
`, screen]);

writeRLE(
    __dirname + '/game_type_menu_nametable_practise.bin',
    buffer,
);

writeRLE(
    __dirname + '/game_type_menu_nametable_extra.bin',
    extra,
);
