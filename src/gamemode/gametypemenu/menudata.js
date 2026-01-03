digitsExample = {
    "BCD Inputs": [
        [
            "TYPE_BCD",
            "BCD 2 Digit",
            2,
        ],
        [
            "TYPE_BCD",
            "BCD 4 Digit",
            4,
        ],
        [
            "TYPE_BCD",
            "BCD 6 Digit",
            6,
        ],
        [
            "TYPE_BCD",
            "BCD 8 Digit",
            8,
        ],
    ],
    "Hex Inputs": [
        [
            "TYPE_HEX",
            "HEX 2 Digit",
            2,
        ],
        [
            "TYPE_HEX",
            "HEX 4 Digit",
            4,
        ],
        [
            "TYPE_HEX",
            "HEX 6 Digit",
            6,
        ],
        [
            "TYPE_HEX",
            "HEX 8 Digit",
            8,
        ],
    ],
}


nestedExample = {
    "Nested": [
        [
            "TYPE_SUBMENU",
            "more nested",
            {
                "more nested": [
                    [
                        "TYPE_SUBMENU",
                        "even more",
                        {
                            "even more": [
                                [
                                    "TYPE_SUBMENU",
                                    "and more",
                                    {
                                        "and more": [
                                            [
                                                "TYPE_SUBMENU",
                                                "last one",
                                                {
                                                    "last one": [
                                                        [
                                                            "TYPE_NUMBER",
                                                            "foo",
                                                            8,
                                                        ],
                                                        [
                                                            "TYPE_CHOICES",
                                                            "Dont do",
                                                            "this",
                                                        ],
                                                    ],
                                                },
                                            ],
                                        ],
                                    },
                                ],
                            ],
                        },
                    ],
                ],
            },
        ],
    ],
}


tournamentSubmenu = {
    "Tournament [mode=default]": [
        [
            "TYPE_CHOICES",
            "SPS",
            "sps",
        ],
        [
            "TYPE_HEX",
            "Piece Seed",
            6,
        ],
        [
            "TYPE_HEX",
            "B Seed",
            4,
        ],
        [
            "TYPE_CHOICES",
            "Killscreen",
            "killwhen",
        ],
        [
            "TYPE_CHOICES",
            "how",
            "killhow",
        ],
        [
            "TYPE_NUMBER",
            "Level",
            0,
        ],
        [
            "TYPE_BCD",
            "Lines",
            4,
        ],
    ]
}


customColorSubmenu = {
    "Custom x0-x4": [
        [
            "TYPE_HEX",
            "Lvl x0",
            6,
        ],
        [
            "TYPE_HEX",
            "Lvl x1",
            6,
        ],
        [
            "TYPE_HEX",
            "Lvl x2",
            6,
        ],
        [
            "TYPE_HEX",
            "Lvl x3",
            6,
        ],
        [
            "TYPE_HEX",
            "Lvl x4",
            6,
        ],
    ],
    "Custom x5-x9": [
        [
            "TYPE_HEX",
            "Lvl x5",
            6,
        ],
        [
            "TYPE_HEX",
            "Lvl x6",
            6,
        ],
        [
            "TYPE_HEX",
            "Lvl x7",
            6,
        ],
        [
            "TYPE_HEX",
            "Lvl x8",
            6,
        ],
        [
            "TYPE_HEX",
            "Lvl x9",
            6,
        ],
    ],
}

displaySubmenu = {
    "Display Menu": [
        [
            "TYPE_CHOICES",
            "Scoring",
            "score",
        ],
        [
            "TYPE_FF_OFF",
            "Pace Display",
            16,
        ],
        [
            "TYPE_CHOICES",
            "Stats Box",
            "stats",
        ],
        [
            "TYPE_BOOL",
            "Input Display",
            "stats",
        ],
        [
            "TYPE_CHOICES",
            "Dark Mode",
            "dark",
        ],
        [
            "TYPE_CHOICES",
            "Colors",
            "colors",
        ],
        [
            "TYPE_SUBMENU",
            "Custom Colors",
            customColorSubmenu,
        ],
        [
            "TYPE_BOOL",
            "Disable Flash",
        ],
    ],
}

settingsSubmenu = {
    "Settings": [
        [
            "TYPE_CHOICES",
            "Crash",
            "crash",
        ],
        [
            "TYPE_BOOL",
            "Strict Crash",
        ],
        [
            "TYPE_BOOL",
            "Disable Pause",
        ],
        [
            "TYPE_BOOL",
            "Goofy Foot",
        ],
        [
            "TYPE_BOOL",
            "Das Only",
        ],
        [
            "TYPE_BOOL",
            "Qual Mode",
        ],
        [
            "TYPE_BOOL",
            "Block Tool",
        ],
        [
            "TYPE_BOOL",
            "Pal Mode",
        ],
    ],
}

v7IdeaMenu = {
    "Main Menu": [
        [
            "TYPE_SUBMENU",
            "Tournament",
            tournamentSubmenu,
        ],
        [
            "TYPE_SUBMENU",
            "Display",
            displaySubmenu,
        ],
        [
            "TYPE_SUBMENU",
            "Settings",
            settingsSubmenu,
        ],
    ],
}
numberExample = {
    "Numbers": [
        [
            "TYPE_NUMBER",
            "Min Limit 2",
            2,
        ],
        [
            "TYPE_NUMBER",
            "Max Limit 30",
            31,
        ],
        [
            "TYPE_NUMBER",
            "Or Unlimited",
            0,
        ],
        [
            "TYPE_FF_OFF",
            "when -1 is off",
            5,
        ],
        [
            "TYPE_CHOICES",
            "from word list",
            "examples2",
        ],
        [
            "TYPE_HEX",
            "by digit",
            2,
        ],
        [
            "TYPE_BCD",
            "by bcd digit",
            2,
        ],
    ],
}
booleanExample = {
    "boolean": [
        [
            "TYPE_BOOL",
            "Off On",
            2,
        ],
        [
            "TYPE_CHOICES",
            "ff means off",
            "onoff",
        ],
        [
            "TYPE_NUMBER",
            "As Number",
            2,
        ],
        [
            "TYPE_CHOICES",
            "as words",
            "examples",
        ],
    ],
}

pages = {
    "0123456789ABCD": [
        [
            "TYPE_CHOICES",
            "0123456789ABCD",
            "examples",
        ],
        [
            "TYPE_CHOICES",
            "words",
            "this",
        ],
        [
            "TYPE_BCD",
            "0123456789ABCD",
            8,
        ],
    ],
    "other page": [
        [
            "TYPE_CHOICES",
            "DCBA9876543210",
            "examples2",
        ],
        [
            "TYPE_HEX",
            "C",
            8,
        ],
        [
            "TYPE_BCD",
            "D",
            8,
        ],
        [
            "TYPE_SUBMENU",
            "number inputs",
            numberExample,
        ],
        [
            "TYPE_SUBMENU",
            "boolean inputs",
            booleanExample,
        ],
        [
            "TYPE_SUBMENU",
            "Digit Inputs",
            digitsExample,
        ],
        [
            "TYPE_SUBMENU",
            "nested menus",
            nestedExample,
        ],
    ],
    "Second Page": [
        [
            "TYPE_SUBMENU",
            "v7 menu ideas",
            v7IdeaMenu,
        ],
    ],
}

strings = {
    bool: [
        "Off",
        "On",
    ],
    onoff: [
        "On",
        "Off",
    ],
    score: [
        "Classic",
        "Letters",
        "7Digit",
        "M",
        "Hidden",
    ],
    colors: [
        "Vanilla",
        "Pride",
        "White",
        "Custom",
    ],
    stats: [
        "Stats",
        "HZ Dsply",
        "DASMeter",
        "Nothing",
    ],
    crash: [
        "Off",
        "Shown",
        "Topout",
        "Crash",
    ],
    sps: [
        "Off",
        "On",
        "Similar",
    ],
    killwhen: [
        "Off",
        "lines",
        "level",
    ],
    killhow: [
        "KS*2",
        "Floor",
        "Inviz",
        "Halt",
    ],
    dark: [
        "Off",
        "On",
        "Lite",
        "Teal",
        "OG",
    ],
    examples: [
        "12345678",
        "foo",
        "bar",
        "baz",
    ],
    this: [
        "this",
    ],
    examples2: [
        "foo",
        "bar",
    ],
    lookup: [
        "Pause",
        "Block",
        "Clear?",
        "Sure?!",
        "Confetti",
    ],
}

module.exports = {pages, strings}
