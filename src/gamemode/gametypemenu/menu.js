const { mainMenu, extraSpriteStrings } = require("./menudata");
const { writeFileSync } = require("fs");

MAX_LENGTH_NAME = 14;
MAX_LENGTH_VALUE = 8;
DEBUG = false;

function checkStringSanity(string) {
    if (string.length > MAX_LENGTH_VALUE) {
        throw new Error(`${string} is more than MAX_LENGTH_VALUE chars`);
    }
    if ((match = string.match(/[^- a-z0-9_?!*]/i))) {
        throw new Error(`${string} has invalid char '${match[0]}'`);
    }
}

function cleanWord(word) {
    word = word.toLowerCase().replace(/\b\w/g, (c) => c.toUpperCase());
    return word.replace(/[- *?!/]/g, "");
}

function getStringName(word) {
    return `string${cleanWord(word)}`;
}

function getStringListName(word) {
    return `stringList${cleanWord(word)}`;
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
        string: string,
        label: getByteLine(`${itemType} ; ${string}`),
        memory: memory, // has to be processed separately to get output line
    };
}

function getLineString(string, multiline = false) {
    if (string.length > MAX_LENGTH_NAME) {
        throw new Error(`${string} is more than MAX_LENGTH_NAME chars`);
    }

    return multiline
        ? string
              .split("")
              .map((c) => getByteLine(getStringByte(c)))
              .join("\n")
        : getByteLine(getStringBytes(string));
}

stringSets = {};
function getPageLines(title, page, pages) {
    DEBUG && console.log(`getPageLines`, title, page, pages);
    label = Object.values(pages).length > 1 ? "PAGE_MULTI" : "PAGE_SINGLE";
    [_, string, mode] = title.match(/([^[]*)(?:\s*\[mode=(\w+)\])?/i);
    const modifier = mode ? `MODE_${mode.toUpperCase()}` : "MODE_DEFAULT";
    const stringset = `stringset${cleanWord(string)}`;

    const endString = getByteLine("EOL");
    const endStringset = getByteLine("EOF");

    stringSetLines = [];
    stringSetLines.push(`${stringset}:`);
    padding = [...Array(Math.round((MAX_LENGTH_NAME - string.length) / 2))]
        .map(() => " ")
        .join("");
    stringSetLines.push(getLineString(`${padding}${string}`));
    stringSetLines.push(endString);
    page.forEach((p, i) => {
        stringSetLines.push(getLineString(p[1]));
        if (i + 1 != page.length) stringSetLines.push(endString);
    });
    stringSetLines.push(endStringset);
    joined = stringSetLines.join("\n");
    existing = stringSets[joined];
    if (!existing) stringSets[joined] = stringset;

    return {
        label: getByteLine(`${label} | ${modifier} ; ${string}`),
        count: getByteLine(getHexByte(page.length)),
        hibytes: getByteLine(`>${existing ? existing : stringset} ; ${string}`),
        lobytes: getByteLine(`<${existing ? existing : stringset} ; ${string}`),
        stringsets: existing ? "" : joined,
    };
}

function typeTitle(label, string) {
    return getOutputLines(label, string);
}

function typeDigit(label, string, digits, memoryLabel) {
    if (digits < 2 || digits > 8 || digits & 1) {
        throw new Error(`${string}: digits can only be 2, 4, 6 or 8`);
    }
    memory = memoryLabel ? memoryLabel : (digits + 1) >> 1;
    return getOutputLines(`${label} | ${getHexByte(digits)}`, string, memory);
}

unlabeledStringSets = {};

// getStringSet = (choices) => {
//     key = "" + choices;
//     existing = unlabeledStringSets[key];
//     if (existing) return existing;
//     unlabeledStringSets[key] = stringsetIndex++;
// };

function typeWords(label, string, stringList, memoryLabel) {
    DEBUG && console.log(`Choice set ${string} with options ${stringList}`);
    stringSet = [...stringList].map((c) => cleanWord(c.slice(0, 6))).join("");
    unlabeledStringSets[stringSet] = stringList;
    return getOutputLines(
        `${label} | ${getStringListConstant(stringSet)}`,
        string,
        memoryLabel ? memoryLabel : 1,
    );
}

function typeNumber(label, string, limit, memoryLabel) {
    return getOutputLines(
        `${label} | ${getHexByte(limit)}`,
        string,
        memoryLabel ? memoryLabel : 1,
    );
}

function typeBool(label, string, memoryLabel) {
    return typeWords(
        "TYPE_CHOICES",
        string,
        ["off", "on"],
        memoryLabel ? memoryLabel : 1,
    );
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

function getStringByte(c) {
    replaceMap = {
        "/": "$4F",
        "*": "$69",
        " ": "$EF",
    };
    return replaceMap[c] ? replaceMap[c] : `"${c.toUpperCase()}"`;
}

function getStringBytes(string) {
    return [...string.split("").map((c) => getStringByte(c))].join(",");
}

menuEnums = [];
firstPages = [];
lastPages = [];

// tracks
menuCount = 0;
index = 0;
pageIndex = 0;
firstItems = [];
memoryMap = [];
items = [];

// like items but different
pagesOutput = [];

processPageSet = (pages, name) => {
    DEBUG && name && console.log(`submenu ${name}`);
    DEBUG && !name && console.log(`main menu`);
    if (name) menuEnums.push(`SUBMENU_${cleanWord(name).toUpperCase()}`);
    firstPages.push(getByteLine(getHexByte(pageIndex)));
    // collect submenus to process after all pages
    let subPageSets = {};
    Object.entries(pages).forEach(([title, page]) => {
        DEBUG && console.log(`${title} with ${page.length} entries`);
        pageIndex++;
        firstItems.push(
            getByteLine(`${getHexByte(index)} ; ${cleanWord(title)}`),
        );
        pagesOutput.push(getPageLines(title, page, pages, index));
        page.forEach((item) => {
            items.push(labelMap[item[0]](...item));
            index++;
            if (item[0] === "TYPE_SUBMENU") subPageSets[item[1]] = item[2];
        });
    });
    lastPages.push(getByteLine(getHexByte(pageIndex)));

    // process any submenus the same was as the main menu
    Object.entries(subPageSets).forEach(([name, pages]) => {
        processPageSet(pages, name);
    });
};
processPageSet(mainMenu);

// memory into separate file
memoryReservations = {};
function getMemoryLabel(string, bytes) {
    if (isNaN(bytes)) return bytes; // if label is specified use that instead
    label = `menuVar${cleanWord(string)}`;
    memoryReservations[label] = bytes;
    return label;
}

items.forEach((i) => {
    line = getByteLine(
        i.memory ? `<${getMemoryLabel(i.string, i.memory)}` : "0",
    );
    memoryMap.push(line);
});

memoryBuffer = [];
memoryBuffer.push("; generated by menu.js");
memoryBuffer.push("autoMenuVars:");
Object.entries(memoryReservations).forEach(([label, bytes]) =>
    memoryBuffer.push(`${label}: .res ${getHexByte(bytes)}`),
);
memoryBuffer.push("");
writeFileSync(__dirname + "/menuram.asm", [...memoryBuffer, ""].join("\n"));

[
    ["extraSpriteStrings", extraSpriteStrings],
    ...Object.entries(unlabeledStringSets),
].forEach(([name, stringList]) => {
    DEBUG && console.log(`stringlist`, name, stringList);
    if (name != "extraSpriteStrings") {
        stringEnums.push(getStringListConstant(name));
        stringCounts.push(getByteLine(getHexByte(stringList.length)));
        stringIndexes.push(
            getByteLine(`${getStringListName(name)}-stringLists`),
        );
        stringLists.push(`${getStringListName(name)}:`);
    }
    DEBUG && console.log(`stringList: `, stringList);
    stringList.forEach((string) => {
        string = string.toLowerCase();
        checkStringSanity(string);
        if (!addedStrings.includes(string)) {
            addedStrings.push(string);
            newStringLines.push(`${getStringName(string)}:`);
            newStringLines.push(
                getByteLine(
                    `${getHexByte(string.length)},${getStringBytes(string)}`,
                ),
            );
        }
        if (name == "extraSpriteStrings") {
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

buffer.push("; generated by menu.js");
buffer.push("; will be overwritten unless built with -M");
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

buffer.push("; index activeMenu");
buffer.push("firstPages:");
buffer.push(...firstPages);
buffer.push("");

buffer.push("lastPages:");
buffer.push(...lastPages);
buffer.push("");

buffer.push("; index activePage");
buffer.push("pageTypes:");
buffer.push(...pagesOutput.map((p) => p.label));
buffer.push("");

buffer.push("pageCounts:");
buffer.push(...pagesOutput.map((p) => p.count));
buffer.push("");

buffer.push("pageStringsetsHi:");
buffer.push(...pagesOutput.map((p) => p.hibytes));
buffer.push("");

buffer.push("pageStringsetsLo:");
buffer.push(...pagesOutput.map((p) => p.lobytes));
buffer.push("");

buffer.push("firstItems:");
buffer.push(...firstItems);
buffer.push("");

buffer.push("; index activeItem");
buffer.push("memoryMap:");
buffer.push(...memoryMap);
buffer.push("");

buffer.push("itemTypes:");
buffer.push(...items.map((i) => i.label));
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
buffer.push('.out .sprintf("%d/256 sprite string bytes", * - stringTable)');
buffer.push("");

buffer.push(...pagesOutput.map((p) => p.stringsets));
buffer.push("");
buffer.push("");

writeFileSync(__dirname + "/menudata.asm", [...buffer, ""].join("\n"));
