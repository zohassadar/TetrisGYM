const {
    readStripe,
    writeRLE,
    printNT,
    drawTiles,
    drawAttrs,
    flatLookup,
} = require('./nametables');

var buffer = readStripe(__dirname + '/game_nametable.bin');

const lookup = flatLookup(`
0123456789ABCDEF
GHIJKLMNOPQRSTUV
WXYZ-+!>˙^()#.##
########qweadzxc
################
################
################
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

printNT(buffer, lookup);

drawTiles(buffer, lookup, `
################################
################################
###########qwwwwwwwwwweqwwwwwwe#
##qwwwwwwe#a LINES-000da      d#
##a      d#zxxxxxxxxxxcaTOP   d#
##zxxxxxxc#############a      d#
############          #a      d#
############          #aSCORE d#
#qwwwwwwwwe#          #a000000d#
#a########d#          #a      d#
#a        d#          #zxxxxxxc#
#a ###    d#          ##########
#a ###000 d#          ##########
#a ###    d#          ##NEXT####
#a ###000 d#          ##    ####
#a ##     d#          ##    ####
#a ###000 d#          ##    ####
#a ##     d#          ##    ####
#a ## 000 d#          ##########
#a ###    d#          #qwwwwwe##
#a ###000 d#          #aLEVELd##
#a ###    d#          #a     d##
#a ###000 d#          #zxxxxxc##
#a        d#          ##########
#a ###000 d#          ##########
#a        d#          ##########
#zxxxxxxxxc#####################
################################
################################
################################
`);

const bgtiles = [
    0x70, 0x71, 0x72, 0x73, 
    0x74, 0x75, 0x80, 0x81, 
    0x82, 0x83, 0x84, 0x85,
    0x67, 0x77, 0x87, 0x78,
    0x79, 0x7A, 0x38, 0x39,
    0x3A, 0x3B, 0x3C, 0x3D,
    0x3E, 0x3F, 
];

const darkbuffer = buffer.map((num) => (bgtiles.includes(num) ? 0xFF : num));

drawAttrs(buffer, [`
    3333333333333333
    3333333333333333
    3333333333333333
    3333332222233333
    3333332222233333
    3220032222233333
    3220032222233333
    3220032222233333
`, `
    3220032222233333
    3220032222233333
    3220032222233333
    3220032222233333
    3220032222233333
    3333333333333333
    3333333333333333
    0000000000000000
`]);

drawAttrs(darkbuffer, [`
    3333333333333333
    3333333333333333
    3333333333333333
    3333332222233333
    3333332222233333
    3220032222233333
    3220032222233333
    3220032222233333
`, `
    3220032222233333
    3220032222233333
    3220032222233333
    3220032222233333
    3220032222233333
    3333333333333333
    3333333333333333
    0000000000000000
`]);

writeRLE(
    __dirname + '/game_nametable_practise.bin',
    darkbuffer,
);

writeRLE(
    __dirname + '/game_nametable_practise_dark.bin',
    buffer,
);
