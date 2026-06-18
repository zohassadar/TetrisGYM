const { mainMenu, extraSpriteStrings } = require("./menudata");
const { writeFileSync } = require("fs");

const MAX_LENGTH_NAME = 14;
const MAX_LENGTH_VALUE = 8;
const DEBUG = false;

const labelMap = {
    TYPE_BCD: typeDigit,
    TYPE_HEX: typeDigit,
    TYPE_NUMBER: typeNumber,
    TYPE_FF_OFF: typeNumber,
    TYPE_CHOICES: typeChoices,
    TYPE_MODE_ONLY: getOutputLines,
    TYPE_SUBMENU: typeSubMenu,
    TYPE_BOOL: typeBool,
    TYPE_CUSTOM: typeCustom,
};

const newWords = new Set();
const choiceSetEnums = [];
const choiceSetIndexes = [];
const choiceSets = [];
let index = 0;
const items = [];
const lookupConstants = [];
const memoryMap = [];
const menuEnums = [];
const pageCountByMenu = [];
let pageIndex = 0;
const pageLabelText = {};
const pagesOutput = [];
const startItemByPage = [];
const startPageByMenu = [];
const unlabeledStringSets = {};

function checkStringSanity(string) {
    if (string.length > MAX_LENGTH_VALUE) {
        throw new Error(`${string} is more than MAX_LENGTH_VALUE chars`);
    }
    let match;
    if ((match = string.match(/[^-/ a-z0-9_?!*]/i))) {
        throw new Error(`${string} has invalid char '${match[0]}'`);
    }
}

function cleanWord(word) {
    word = word.toLowerCase().replace(/\b\w/g, (c) => c.toUpperCase());
    return word.replace(/[- *?!(),/]/g, "");
}

function getStringName(word) {
    return `string${cleanWord(word)}`;
}

function getStringConstant(word) {
    return `str_${cleanWord(word)}`.toUpperCase();
}

function getChoiceSetName(word) {
    return `choiceSet${cleanWord(word)}`;
}

function getChoiceSetConstant(name) {
    return `CHOICESET_${cleanWord(name).toUpperCase()}`;
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

function getStringByte(c) {
    const replaceMap = {
        ",": "$25",
        "/": "$4F",
        "(": "$5E",
        ")": "$5F",
        "*": "$69", // KSx2 x
        " ": "$EF",
    };
    return replaceMap[c] ? replaceMap[c] : `"${c.toUpperCase()}"`;
}

function getStringBytes(string) {
    return [...string.split("").map((c) => getStringByte(c))].join(",");
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

function getPageLines(title, page, pages) {
    DEBUG && console.log(`getPageLines`, title, page, pages);
    const pageType = "PAGE_DEFAULT";
    let label;
    let mode;
    [, label, mode] = title.match(/([^[]*)(?:\s*\[mode=(\w+)\])?/i);
    const padding = (
        (Math.round((MAX_LENGTH_NAME - label.length) / 2) << 5) &
        0xff
    )
        .toString(16)
        .toUpperCase();
    const modifier = mode ? `MODE_${mode.toUpperCase()}` : "MODE_DEFAULT";
    const pagelabelsName = `pageLabels${cleanWord(label)}`;

    const endLabel = getByteLine("EOL");
    const endLabelSet = getByteLine("EOF");

    const pageLabelTextLines = [];
    pageLabelTextLines.push(`${pagelabelsName}:`);
    pageLabelTextLines.push(getLineString(`${label}`));
    pageLabelTextLines.push(endLabel);
    page.forEach((p, i) => {
        pageLabelTextLines.push(getLineString(p[1]));
        if (i + 1 != page.length) pageLabelTextLines.push(endLabel);
    });
    pageLabelTextLines.push(endLabelSet);
    const joined = pageLabelTextLines.join("\n");
    const existing = pageLabelText[joined];
    if (!existing) pageLabelText[joined] = pagelabelsName;

    return {
        label: getByteLine(`$${padding} | ${modifier} ; ${label}`),
        count: getByteLine(`${getHexByte(page.length)} ; ${label}`),
        hibytes: getByteLine(
            `>${existing ? existing : pagelabelsName} ; ${label}`,
        ),
        lobytes: getByteLine(
            `<${existing ? existing : pagelabelsName} ; ${label}`,
        ),
        choicesets: existing ? "" : joined,
    };
}

function typeDigit(label, string, digits, memoryLabel) {
    if (digits < 2 || digits > 8 || digits & 1) {
        throw new Error(`${string}: digits can only be 2, 4, 6 or 8`);
    }
    const memory = memoryLabel ? memoryLabel : (digits + 1) >> 1;
    return getOutputLines(`${label} | ${getHexByte(digits)}`, string, memory);
}

function typeChoices(label, string, choiceSet, memoryLabel) {
    DEBUG && console.log(`Choice set ${string} with options ${choiceSet}`);
    const stringSet = [...choiceSet]
        .map((c) => cleanWord(c.slice(0, 6)))
        .join("");
    unlabeledStringSets[stringSet] = choiceSet;
    return getOutputLines(
        `${label} | ${getChoiceSetConstant(stringSet)}`,
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

function typeBool(_, string, memoryLabel) {
    return typeChoices(
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
function typeCustom(label, string, subroutine, memoryLabel) {
    return getOutputLines(
        `${label} | ${subroutine}`,
        `${string}`,
        memoryLabel ? memoryLabel : 1,
    );
}

const processPageSet = (pages, name) => {
    DEBUG && name && console.log(`submenu ${name}`);
    DEBUG && !name && console.log(`main menu`);
    if (name) {
        const enunName = `SUBMENU_${cleanWord(name).toUpperCase()}`;
        if (!menuEnums.includes(enunName)) menuEnums.push(enunName);
    }
    startPageByMenu.push(
        `${getByteLine(getHexByte(pageIndex))} ; ${name ? name : "main menu"}`,
    );
    // collect submenus to process after all pages
    let subPageSets = {};
    Object.entries(pages).forEach(([title, page]) => {
        DEBUG && console.log(`${title} with ${page.length} entries`);
        pageIndex++;
        startItemByPage.push(
            getByteLine(`${getHexByte(index)} ; ${cleanWord(title)}`),
        );
        pagesOutput.push(getPageLines(title, page, pages, index));
        page.forEach((item) => {
            items.push(labelMap[item[0]](...item));
            index++;
            if (item[0] === "TYPE_SUBMENU") subPageSets[item[1]] = item[2];
        });
    });
    pageCountByMenu.push(
        getByteLine(
            `${getHexByte(Object.values(pages).length)} ; ${name ? name : "main menu"}`,
        ),
    );

    // process any submenus the same was as the main menu
    Object.entries(subPageSets).forEach(([name, pages]) => {
        processPageSet(pages, name);
    });
};
processPageSet(mainMenu);

items.forEach((i) => {
    const line = getByteLine(
        `${i.memory ? "<" + i.memory : "NORAM"} ; ${i.string}`,
    );
    memoryMap.push(line);
});

[
    ["extraSpriteStrings", extraSpriteStrings],
    ...Object.entries(unlabeledStringSets),
].forEach(([name, choiceSet]) => {
    DEBUG && console.log(`stringlist`, name, choiceSet);
    if (name != "extraSpriteStrings") {
        choiceSetEnums.push(getChoiceSetConstant(name));
        choiceSetIndexes.push(
            `    .word $${((choiceSet.length - 2) << 12).toString(16)} | (${getChoiceSetName(name)} - choiceSets)`,
        );
        choiceSets.push(`${getChoiceSetName(name)}:`);
    }
    DEBUG && console.log(`choiceSet: `, choiceSet);
    choiceSet.forEach((choice) => {
        choice = choice.toLowerCase();
        checkStringSanity(choice);
        newWords.add(choice);
        if (name !== "extraSpriteStrings") {
            choiceSets.push(
                // getByteLine(`${getStringName(choice)}-${getChoiceSetName(name)}`),
                `    .word ${getStringConstant(choice)}`,
            );
        }
    });
});

/*
 * create a blob of words
 */
let wordTable = "";
const sortedWords = [...newWords].sort((a, b) => b.length - a.length);

sortedWords.forEach((w) => {
    let index = wordTable.search(RegExp.escape(w));
    index < 0 && (wordTable = wordTable + w);
});

if (wordTable.length > 1023) {
    throw new Error(`is 1024 bytes of words not enough?`);
}

function wordConstants() {
    return sortedWords.map((w) => {
        let index = wordTable.search(RegExp.escape(w));
        let clean = cleanWord(w);
        let hexbyte = (((w.length - 1) << 12) | index)
            .toString(16)
            .toUpperCase();
        return `${getStringConstant(w)} = $${hexbyte}`;
    });
}

function wordChunks() {
    return wordTable
        .match(/.{1,8}/g)
        .map((w) => getByteLine(getStringBytes(w)));
}

const output = `
; generated by menu.js
; will be overwritten unless built with -M

${lookupConstants.join("\n")}

.enum
MAIN_MENU
${menuEnums.join("\n")}
MENU_COUNT
.endenum
.out .sprintf("%d/32 menus", MENU_COUNT)

.enum
${choiceSetEnums.join("\n")}
CHOICESET_COUNT
.endenum
.out .sprintf("%d/32 choicesets", CHOICESET_COUNT)

; index activeMenu

startPageByMenu:
${startPageByMenu.join("\n")}

pageCountByMenu:
${pageCountByMenu.join("\n")}

; index activePage
pageTypes:
${pagesOutput.map((p) => p.label).join("\n")}

itemCountByPage:
${pagesOutput.map((p) => p.count).join("\n")}

pageLabelsHi:
${pagesOutput.map((p) => p.hibytes).join("\n")}

pageLabelsLo:
${pagesOutput.map((p) => p.lobytes).join("\n")}

startItemByPage:
${startItemByPage.join("\n")}

; index activeItem

memoryOffsets:
${memoryMap.join("\n")}

itemTypes:
${items.map((i) => i.label).join("\n")}

choiceSetIndexes:
${choiceSetIndexes.join("\n")}

choiceSets:
${choiceSets.join("\n")}

${pagesOutput.map((p) => p.choicesets).join("\n")}

strTable:
${wordChunks().join("\n")}

; LLLLOOOO OOOOOOOO
; L = length - 1
; O = offset from strTable;

${wordConstants().join("\n")}
`;

writeFileSync(__dirname + "/menudata.asm", output);
