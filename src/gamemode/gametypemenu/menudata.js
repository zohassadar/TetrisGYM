menuVarsPage = [
    [
        "TYPE_NUMBER",
        "active menu",
        0,
        "activeMenu",
    ],
    [
        "TYPE_NUMBER",
        "active page",
        0,
        "activePage",
    ],
    [
        "TYPE_NUMBER",
        "active row",
        0,
        "activeRow",
    ],
    [
        "TYPE_NUMBER",
        "active column",
        0,
        "activeColumn",
    ],
    [
        "TYPE_NUMBER",
        "menu stack ptr",
        0,
        "menuStackPtr",
    ],
]

digitsExample = {
    "BCD Inputs": [
        [
            "TYPE_BCD",
            "BCD 2 Digit",
            2,
            "menuVarBcd8Digit",
        ],
        [
            "TYPE_BCD",
            "BCD 4 Digit",
            4,
            "menuVarBcd8Digit",
        ],
        [
            "TYPE_BCD",
            "BCD 6 Digit",
            6,
            "menuVarBcd8Digit",
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
            "menuVarHex8Digit",
        ],
        [
            "TYPE_HEX",
            "HEX 4 Digit",
            4,
            "menuVarHex8Digit",
        ],
        [
            "TYPE_HEX",
            "HEX 6 Digit",
            6,
            "menuVarHex8Digit",
        ],
        [
            "TYPE_HEX",
            "HEX 8 Digit",
            8,
        ],
    ],
    "Break Things": menuVarsPage,
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
                                                            0,
                                                        ],
                                                    ],
                                                    "last two": [
                                                        [
                                                            "TYPE_CHOICES",
                                                            "Dont do",
                                                            ["this"],
                                                        ],
                                                    ],
                                                    "break things": menuVarsPage,
                                                },
                                            ],
                                        ],
                                        "break things": menuVarsPage,
                                    },
                                ],
                            ],
                            "break things": menuVarsPage,
                        },
                    ],
                ],
                "break things": menuVarsPage,
            },
        ],
    ],
    "break things": menuVarsPage,
}

tournamentSubmenu = {
    "Tournament [mode=default]": [
        [
            "TYPE_CHOICES",
            "SPS",
            [
                "Off",
                "On",
            ],
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
            [
                "Off",
                "lines",
                "level",
            ],
        ],
        [
            "TYPE_CHOICES",
            "how",
            [
                "KS*2",
                "Floor",
                "Inviz",
                "Halt",
            ],
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
    ],
    "break things": menuVarsPage,
}


customColorSubmenu = {
    "0-4": [
        [
            "TYPE_HEX",
            "0",
            6,
        ],
        [
            "TYPE_HEX",
            "1",
            6,
        ],
        [
            "TYPE_HEX",
            "2",
            6,
        ],
        [
            "TYPE_HEX",
            "3",
            6,
        ],
        [
            "TYPE_HEX",
            "4",
            6,
        ],
    ],
    "5-9": [
        [
            "TYPE_HEX",
            "5",
            6,
        ],
        [
            "TYPE_HEX",
            "6",
            6,
        ],
        [
            "TYPE_HEX",
            "7",
            6,
        ],
        [
            "TYPE_HEX",
            "8",
            6,
        ],
        [
            "TYPE_HEX",
            "9",
            6,
        ],
    ],
    "break things": menuVarsPage,
}

displaySubmenu = {
    "Display Menu": [
        [
            "TYPE_CHOICES",
            "Scoring",
            [
                "Classic",
                "Letters",
                "7Digit",
                "M",
                "Hidden",
            ],
        ],
        [
            "TYPE_FF_OFF",
            "Pace Display",
            16,
        ],
        [
            "TYPE_CHOICES",
            "Stats Box",
            [
                "Stats",
                "HZ Dsply",
                "DASMeter",
                "Nothing",
            ],
        ],
        [
            "TYPE_BOOL",
            "Input Display",
        ],
        [
            "TYPE_CHOICES",
            "Dark Mode",
            [
                "Off",
                "On",
                "Lite",
                "Teal",
                "OG",
            ],
        ],
        [
            "TYPE_CHOICES",
            "Colors",
            [
                "Orig",
                "Pride",
                "Cust",
            ],
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
    "break things": menuVarsPage,
}

settingsSubmenu = {
    "Settings": [
        [
            "TYPE_CHOICES",
            "Crash",
            [
                "off",
                "show",
                "topout",
                "crash",
            ],
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
    "break things": menuVarsPage,
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
    "break things": menuVarsPage,
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
            "menuVarMinLimit2",
        ],
        [
            "TYPE_NUMBER",
            "Or Unlimited",
            0,
            "menuVarMinLimit2",
        ],
        [
            "TYPE_FF_OFF",
            "when -1 is off",
            5,
            "menuVarMinLimit2",
        ],
        [
            "TYPE_CHOICES",
            "from word list",
            ["foo", "bar"],
            "menuVarMinLimit2",
        ],
        [
            "TYPE_HEX",
            "by digit",
            2,
            "menuVarMinLimit2",
        ],
        [
            "TYPE_BCD",
            "by bcd digit",
            2,
            "menuVarMinLimit2",
        ],
    ],
    "break things": menuVarsPage,
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
            "On Off",
            ["On", "Off"],
            "menuVarOffOn",
        ],
        [
            "TYPE_NUMBER",
            "As Number",
            2,
            "menuVarOffOn",
        ],
        [
            "TYPE_CHOICES",
            "as words",
            [
                "foo",
                "bar",
            ],
            "menuVarOffOn",
        ],
    ],
    "break things": menuVarsPage,
}
debugVars = {
    "break things": menuVarsPage,
}

fullExample = {
    "highscores/700": [
        [
            "TYPE_HEX",
            "00-03",
            8,
            "highscores",
        ],
        [
            "TYPE_HEX",
            "04-07",
            8,
            "highscores+4",
        ],
        [
            "TYPE_HEX",
            "08-0B",
            8,
            "highscores+8",
        ],
        [
            "TYPE_HEX",
            "0C-0F",
            8,
            "highscores+12",
        ],
        [
            "TYPE_HEX",
            "10-13",
            8,
            "highscores+16",
        ],
        [
            "TYPE_HEX",
            "14-17",
            8,
            "highscores+20",
        ],
        [
            "TYPE_HEX",
            "18-1B",
            8,
            "highscores+24",
        ],
        [
            "TYPE_HEX",
            "1C-1F",
            8,
            "highscores+28",
        ],
    ]
}

aChoices = [
    "A",
    "AA",
    "AAA",
    "AAAA",
    "AAAAA",
    "AAAAAA",
    "AAAAAAA",
    "AAAAAAAA",
]

a = {
    "aaaaaaaaaaaaaa": [
        [
            "TYPE_CHOICES",
            "AAAAAAAAAAAA",
            aChoices,
        ],
        [
            "TYPE_CHOICES",
            "AAAAAAAAAAAA",
            aChoices,
        ],
        [
            "TYPE_CHOICES",
            "AAAAAAAAAAAA",
            aChoices,
        ],
        [
            "TYPE_CHOICES",
            "AAAAAAAAAAAA",
            aChoices,
        ],
        [
            "TYPE_CHOICES",
            "AAAAAAAAAAAA",
            aChoices,
        ],
        [
            "TYPE_CHOICES",
            "AAAAAAAAAAAA",
            aChoices,
        ],
        [
            "TYPE_CHOICES",
            "AAAAAAAAAAAA",
            aChoices,
        ],
        [
            "TYPE_CHOICES",
            "AAAAAAAAAAAA",
            aChoices,
        ],
    ],
}

mainMenu = {
    "other page": [
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
        [
            "TYPE_SUBMENU",
            "full",
            fullExample,
        ],
        [
            "TYPE_SUBMENU",
            "debug",
            debugVars,
        ],
        [
            "TYPE_SUBMENU",
            "a",
            a,
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

extraSpriteStrings = [
    "Pause",
    "Block",
    "Clear?",
    "Sure?!",
    "Confetti",
]

module.exports = {mainMenu, extraSpriteStrings}
