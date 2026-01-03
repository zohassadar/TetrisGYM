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
    ]
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
            ["foo", "bar"],
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
            "On Off",
            ["On", "Off"],
        ],
        [
            "TYPE_NUMBER",
            "As Number",
            2,
        ],
        [
            "TYPE_CHOICES",
            "as words",
            [
                "foo",
                "bar",
            ],
        ],
    ],
}

fullExample = {
    "32 bytes": [
        [
            "TYPE_HEX",
            "00-03",
            8,
        ],
        [
            "TYPE_HEX",
            "04-07",
            8,
        ],
        [
            "TYPE_HEX",
            "08-0B",
            8,
        ],
        [
            "TYPE_HEX",
            "0C-0F",
            8,
        ],
        [
            "TYPE_HEX",
            "10-13",
            8,
        ],
        [
            "TYPE_HEX",
            "14-17",
            8,
        ],
        [
            "TYPE_HEX",
            "18-1B",
            8,
        ],
        [
            "TYPE_HEX",
            "1C-1F",
            8,
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
