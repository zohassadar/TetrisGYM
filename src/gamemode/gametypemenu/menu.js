const { pages, strings } = require("./menudata");
const { writeFileSync } = require("fs");

function checkStringSanity(string) {
    // if (!string.length) {
    //     throw new Error(`${string} cannot be blank`);
    // }
    if (string.length > 16) {
        throw new Error(`${string} is more than 16 chars`);
    }
    if ((match = string.match(/[^- a-z0-9_?!]/i))) {
        throw new Error(`${string} has invalid char '${match[0]}'`);
    }
}

function cleanWord(word) {
    return word.replace(/[- ?!]/g, "");
}

function getStringName(word) {
    return `string${cleanWord(word)}`;
}

function getStringListName(word) {
    return `stringlist${cleanWord(word)}`;
}

function getStringConstant(name) {
    return `STRING_${cleanWord(name).toUpperCase()}`;
}

function getStringListConstant(name) {
    return `STRINGLIST_${cleanWord(name).toUpperCase()}`;
}

function getByteLine(byte) {
    return `    .byte ${byte}`;
}

function getHexByte(number) {
    if (isNaN(number)) return number;
    return `$${number.toString(16).padStart(2, "0").toUpperCase()}`;
}

function getOutputLines(itemType, string, memory) {
    return {
        hibytes: getByteLine(`>${getStringName(string)}`),
        lobytes: getByteLine(`<${getStringName(string)}`),
        label: getByteLine(`${itemType} ; ${string}`),
        memory: memory, // has to be processed separately to get output line
    };
}

function typeTitle(label, string, pageLength) {
    return getOutputLines(pageLength > 1 ? label : `${label} | 1`, string);
}

function typeDigit(label, string, digits) {
    if (digits < 2 || digits > 8 || digits & 1) {
        throw new Error(`${string}: digits can only be 2, 4, 6 or 8`);
    }
    memory = (digits + 1) >> 1;
    return getOutputLines(`${label} | ${getHexByte(digits)}`, string, memory);
}

function typeWords(label, string, stringlist) {
    return getOutputLines(
        `${label} | ${getStringListConstant(stringlist)}`,
        string,
        1,
    );
}
function typeNumber(label, string, limit) {
    return getOutputLines(`${label} | ${getHexByte(limit)}`, string, 1);
}

function typeBool(label, string) {
    return getOutputLines(label, string, 1);
}
function typeSubMenu(label, string) {
    return getOutputLines(
        `${label} | SUBMENU_${cleanWord(string).toUpperCase()}`,
        `${string}`,
    );
}
labelMap = {
    TYPE_BCD: typeDigit,
    TYPE_HEX: typeDigit,
    TYPE_TITLE: typeTitle,
    TYPE_NUMBER: typeNumber,
    TYPE_FF_OFF: typeNumber,
    TYPE_CHOICES: typeWords,
    TYPE_MODE_ONLY: getOutputLines,
    TYPE_SUBMENU: typeSubMenu,
    TYPE_BOOL: typeBool,
};

buffer = [];
stringEnums = [];
stringIndexes = [];
stringCounts = [];
stringLists = [];
lookupConstants = [];
addedStrings = [];
newStringLines = [];

function parseNewString(string) {
    checkStringSanity(string);
    if (!addedStrings.includes(string)) {
        addedStrings.push(string);
        newStringLines.push(`${getStringName(string)}:`);
        newStringLines.push(
            getByteLine(
                `${getHexByte(string.length)},"${string.toUpperCase().replace(/\s+/g, '",$FF,"')}"`,
            ),
        );
    }
}

Object.entries(strings).forEach(([name, stringlist]) => {
    if (name != "lookup") {
        stringEnums.push(getStringListConstant(name));
        stringCounts.push(getByteLine(getHexByte(stringlist.length)));
        stringIndexes.push(
            getByteLine(`${getStringListName(name)}-stringLists`),
        );
        stringLists.push(`${getStringListName(name)}:`);
    }
    stringlist.forEach((string) => {
        parseNewString(string);
        if (name == "lookup") {
            lookupConstants.push(
                `${getStringConstant(string)} = ${getStringName(string)}-stringTable`,
            );
        } else {
            stringLists.push(
                getByteLine(`${getStringName(string)}-stringTable`),
            );
        }
    });
});

newStringLines.push("");
newStringLines.push(
    '.out .sprintf("%d/256 sprite string bytes", * - stringTable)',
);
newStringLines.push("");

menuEnums = [];
firstPages = [];
lastPages = [];

// tracks
menuCount = 0;
index = 0;
pageIndex = 0;
firstItems = [];
lastItems = [];
memoryMap = [];
items = [];

processPageSet = (pages, name) => {
    if (name) menuEnums.push(`SUBMENU_${cleanWord(name).toUpperCase()}`);
    firstPages.push(getByteLine(getHexByte(pageIndex)));
    // collect submenus to process after all pages
    let subPageSets = {};
    pages.forEach((page) => {
        pageIndex++;
        firstItems.push(getByteLine(getHexByte(index)));
        page.forEach((item) => {
            parseNewString(item[1]);
            if (item[0] == "TYPE_TITLE") {
                items.push(labelMap[item[0]](...item, pages.length));
            } else {
                items.push(labelMap[item[0]](...item));
            }
            index++;
            if (item[0] === "TYPE_SUBMENU") subPageSets[item[1]] = item[2];
        });
        lastItems.push(getByteLine(getHexByte(index - 1)));
    });
    lastPages.push(getByteLine(getHexByte(pageIndex)));

    // process any submenus the same was as the main menu
    Object.entries(subPageSets).forEach(([name, pages]) => {
        processPageSet(pages, name);
    });
};
processPageSet(pages);

newStringLines.push("");
newStringLines.push('.out .sprintf("%d total string bytes", * - stringTable)');
newStringLines.push("");
let o = 0;
items.forEach((i) => {
    line = getByteLine(i.memory ? `<MEMORY_BASE + ${getHexByte(o)}` : "0");
    o += isNaN(i.memory) ? 0 : i.memory;
    memoryMap.push(line);
});

buffer.push("; generated by menu.js");
buffer.push("; will be overwritten unless built with --no-menu-build");
buffer.push("");

buffer.push(...lookupConstants);
buffer.push("");

buffer.push(".enum");
buffer.push("MAIN_MENU");
buffer.push(...menuEnums);
buffer.push(".endenum");
buffer.push("");

buffer.push(".enum");
buffer.push(...stringEnums);
buffer.push(".endenum");
buffer.push("");

buffer.push("firstPages:");
buffer.push(...firstPages);
buffer.push("");

buffer.push("lastPages:");
buffer.push(...lastPages);
buffer.push("");

buffer.push("firstItems:");
buffer.push(...firstItems);
buffer.push("");

buffer.push("lastItems:");
buffer.push(...lastItems);
buffer.push("");

buffer.push("memoryMap:");
buffer.push(...memoryMap);
buffer.push("");

buffer.push("itemTypes:");
buffer.push(...items.map((i) => i.label));
buffer.push("");

buffer.push("stringListHi:");
buffer.push(...items.map((i) => i.hibytes));
buffer.push("");

buffer.push("stringListLo:");
buffer.push(...items.map((i) => i.lobytes));
buffer.push("");

buffer.push("stringListIndexes:");
buffer.push(...stringIndexes);
buffer.push("");

buffer.push("stringListCounts:");
buffer.push(...stringCounts);
buffer.push("");

buffer.push("stringLists:");
buffer.push(...stringLists);
buffer.push("");

buffer.push("stringTable:");
buffer.push(...newStringLines);
buffer.push("");

writeFileSync(__dirname + "/menudata.asm", [...buffer, ""].join("\n"));
