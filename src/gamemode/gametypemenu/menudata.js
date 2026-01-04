menuVarsPage = [
    [
        "TYPE_NUMBER",
        "menu",
        0,
        "activeMenu",
    ],
    [
        "TYPE_NUMBER",
        "page",
        0,
        "activePage",
    ],
    [
        "TYPE_NUMBER",
        "row",
        0,
        "activeRow",
    ],
    [
        "TYPE_NUMBER",
        "col",
        0,
        "activeColumn",
    ],
    [
        "TYPE_NUMBER",
        "ptr",
        0,
        "menuStackPtr",
    ],
]

digitsExample = {
    "BCD Inputs": [
        [
            "TYPE_BCD",
            "2",
            2,
            "menuVar8",
        ],
        [
            "TYPE_BCD",
            "4",
            4,
            "menuVar8",
        ],
        [
            "TYPE_BCD",
            "6",
            6,
            "menuVar8",
        ],
        [
            "TYPE_BCD",
            "8",
            8,
        ],
    ],
    "Hex Inputs": [
        [
            "TYPE_HEX",
            "2",
            2,
            "menuVar8",
        ],
        [
            "TYPE_HEX",
            "4",
            4,
            "menuVar8",
        ],
        [
            "TYPE_HEX",
            "6",
            6,
            "menuVar8",
        ],
        [
            "TYPE_HEX",
            "8",
            8,
        ],
    ],
    "dbg": menuVarsPage,
}

tournamentSubmenu = {
    "Tournament [mode=default]": [
        [
            "TYPE_HEX",
            "SEED",
            6,
        ],
        [
            "TYPE_CHOICES",
            "linecap",
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
        [
            "TYPE_BOOL",
            "Das",
            "dasOnlyFlag",
        ],
        [
            "TYPE_BOOL",
            "Qual",
            "qualFlag",
        ],
    ],
    "dbg": menuVarsPage,
}

displaySubmenu = {
    "Display Menu": [
        [
            "TYPE_CHOICES",
            "Scoring",
            [
                "Classic",
                "Letters",
                "7digit",
                "M",
                "Hidden",
            ],
            "scoringModifier",
        ],
        [
            "TYPE_FF_OFF",
            "Pace",
            16,
            "paceModifier",
        ],
        [
            "TYPE_BOOL",
            "HZ DISPLAY",
            "hzFlag",
        ],
        [
            "TYPE_BOOL",
            "Input Display",
            "inputDisplayFlag",
        ],
        [
            "TYPE_BOOL",
            "Disable Flash",
            "disableFlashFlag",
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
            "darkModifier",
        ],
    ],
    "dbg": menuVarsPage,
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
            "crashModifier",
        ],
        [
            "TYPE_BOOL",
            "Strict Crash",
            "strictFlag",
        ],
        [
            "TYPE_BOOL",
            "Disable Pause",
            "disablePauseFlag",
        ],
        [
            "TYPE_BOOL",
            "Goofy Foot",
            "goofyFlag",
        ],
        [
            "TYPE_BOOL",
            "Block Tool",
            "debugFlag",
        ],
        [
            "TYPE_BOOL",
            "Pal Mode",
            "palFlag",
        ],
    ],
    "dbg": menuVarsPage,
}


numberExample = {
    "Numbers": [
        [
            "TYPE_NUMBER",
            "MAX 2",
            2,
        ],
        [
            "TYPE_NUMBER",
            "MaX 30",
            31,
            "menuVarMax2",
        ],
        [
            "TYPE_NUMBER",
            "no max",
            0,
            "menuVarMax2",
        ],
        [
            "TYPE_FF_OFF",
            "-1 is off",
            5,
            "menuVarMax2",
        ],
        [
            "TYPE_CHOICES",
            "words",
            ["a", "b"],
            "menuVarMax2",
        ],
        [
            "TYPE_HEX",
            "by digit",
            2,
            "menuVarMax2",
        ],
        [
            "TYPE_BCD",
            "by bcd digit",
            2,
            "menuVarMax2",
        ],
    ],
    "dbg": menuVarsPage,
}

booleanExample = {
    "boolean": [
        [
            "TYPE_BOOL",
            "A",
            "menuVarMax2",
        ],
        [
            "TYPE_CHOICES",
            "B",
            ["On", "Off"],
            "menuVarMax2",
        ],
        [
            "TYPE_NUMBER",
            "C",
            2,
            "menuVarMax2",
        ],
        [
            "TYPE_CHOICES",
            "D",
            [
                "a",
                "b",
            ],
            "menuVarMax2",
        ],
    ],
    "dbg": menuVarsPage,
}
debugVars = {
    "dbg": menuVarsPage,
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


mainMenu = {
    "(new menu,*)?!": [
        [
            "TYPE_SUBMENU",
            "numbers",
            numberExample,
        ],
        [
            "TYPE_SUBMENU",
            "booleans",
            booleanExample,
        ],
        [
            "TYPE_SUBMENU",
            "Digits",
            digitsExample,
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
    ],
    "kinda working": [
        [
            "TYPE_CHOICES",
            "practise",
            [
                "TETRIS",
                "TSPINS",
                "STACKN",
                "SETUPS",
                "BTYPE",
                "QCKTAP",
                "TAPQTY",
                "CKRBRD",
                "GARBGE",
                "LOWSTK",
            ],
            "practiseType",
        ],
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
    "dbg": menuVarsPage,
}

extraSpriteStrings = [
    "Pause",
    "Block",
    "Clear?",
    "Sure?!",
    "Confetti",
]

module.exports = {mainMenu, extraSpriteStrings}
