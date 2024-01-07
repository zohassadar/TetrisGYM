const {
    readStripe,
    writeRLE,
    printNT,
    drawTiles,
    drawRect,
    drawAttrs,
    flatLookup,
} = require('./nametables');

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
################################
#qwwwwwwwwwwwwwwwwwwwwwwwwwwwwe#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a                            d#
#a    SMALL                   d#
#a    MEDIUM                  d#
#a    BIG                     d#
#a    SHRINK                  d#
#a    SEED                    d#
#a    DAS                     d#
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
#zxxxxxxxxxxxxxxxxxxxxxxxxxxxxc#
################################
`);drawTiles(extra, lookup, `
#a    SCORING                 d#
#a    HZ DISPLAY              d#
#a    INPUT DISPLAY           d#
#a    DISABLE FLASH           d#
#a    DISABLE PAUSE           d#
#a    GOOFY FOOT              d#
#a    BLOCK TOOL              d#
#a    LINECAP                 d#
#a    DAS ONLY                d#
#a    QUAL MODE               d#
#a    PAL MODE                d#
#a                            d#
#a                            d#
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


drawRect(buffer, 8, 2, 10, 5, 0xB0); // draw logo
// drawRect(extra, 20, 0, 5, 5, 0x9A); // draw QR code

const urlX = 3;
const urlY = 13;
drawRect(extra, urlX, urlY, 12, 1, 0x74);
drawRect(extra, urlX+12, urlY, 12, 1, 0x84);

drawAttrs(buffer, [`
    2222222222222222
    2222211111122222
    2222211111122222
    2222211111122222
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
    2222222222222222
    2222222222222222
    2222222222222222
    2222222222222222
    2222222222222222
    2333333333333332
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
