deep_three = [
    [
        [
            "TYPE_TITLE",
            "you went deep",
        ],
        [
            "TYPE_MODE_ONLY",
            "T-Spins",
        ],
        [
            "TYPE_HEX",
            "Seed",
            6,
        ],
        [
            "TYPE_MODE_ONLY",
            "Pace",
        ],
    ],
    [
        [
            "TYPE_TITLE",
            "nothing here",
        ],
        [
            "TYPE_MODE_ONLY",
            "T-Spins",
        ],
        [
            "TYPE_HEX",
            "Seed",
            6,
        ],
        [
            "TYPE_MODE_ONLY",
            "Pace",
        ],
    ],
]
deep_two = [
    [
        [
            "TYPE_TITLE",
            "Deep Two",
        ],
        [
            "TYPE_SUBMENU",
            "go deeperer",
            deep_three,
        ],
        [
            "TYPE_MODE_ONLY",
            "T-Spins",
        ],
        [
            "TYPE_HEX",
            "Seed",
            6,
        ],
        [
            "TYPE_MODE_ONLY",
            "Pace",
        ],
    ],
]


deep_one = [
    [
        [
            "TYPE_TITLE",
            "Deep One",
        ],
        [
            "TYPE_SUBMENU",
            "Go deeper",
            deep_two,
        ],
        [
            "TYPE_MODE_ONLY",
            "T-Spins",
        ],
        [
            "TYPE_HEX",
            "Seed",
            6,
        ],
        [
            "TYPE_MODE_ONLY",
            "Pace",
        ],
    ],
]


pages = [
    [
        [
            "TYPE_TITLE",
            "Fun Stuff",
        ],
        [
            "TYPE_SUBMENU",
            "Go Deep",
            deep_one,
        ],
        [
            "TYPE_NUMBER",
            "",
            0,
        ],
    ],
    [
        [
            "TYPE_TITLE",
            "Main Menu",
        ],
        [
            "TYPE_MODE_ONLY",
            "Tetris",
        ],
        [
            "TYPE_MODE_ONLY",
            "T-Spins",
        ],
        [
            "TYPE_HEX",
            "Seed",
            6,
        ],
        [
            "TYPE_MODE_ONLY",
            "Pace",
        ],
        [
            "TYPE_NUMBER",
            "Setups",
            8,
        ],
        [
            "TYPE_NUMBER",
            "B Type",
            9,
        ],
        [
            "TYPE_NUMBER",
            "Crunch",
            16,
        ],
        [
            "TYPE_NUMBER",
            "Quick Tap",
            17,
        ],
    ],
    [
        [
            "TYPE_TITLE",
            "Page 2",
        ],
        [
            "TYPE_NUMBER",
            "Transition",
            17,
        ],
        [
            "TYPE_NUMBER",
            "Marathon",
            5,
        ],
        [
            "TYPE_NUMBER",
            "Tap Quantity",
            17,
        ],
        [
            "TYPE_NUMBER",
            "Checkerboard",
            9,
        ],
        [
            "TYPE_NUMBER",
            "Garbage",
            5,
        ],
        [
            "TYPE_NUMBER",
            "Drought",
            19,
        ],
        [
            "TYPE_NUMBER",
            "Das Delay",
            17,
        ],
        [
            "TYPE_NUMBER",
            "Low Stack",
            19,
        ],
    ],
    [
        [
            "TYPE_TITLE",
            "Page 3",
        ],
        [
            "TYPE_MODE_ONLY",
            "KILLSCREEN X2",
        ],
        [
            "TYPE_MODE_ONLY",
            "Invisible",
        ],
        [
            "TYPE_MODE_ONLY",
            "Hard Drop",
        ],
        [
            "TYPE_CHOICES",
            "Scoring",
            "score",
        ],
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
            "HZ Display",
        ],
        [
            "TYPE_BOOL",
            "Input Display",
        ],
    ],
    [
        [
            "TYPE_TITLE",
            "Page 4",
        ],
        [
            "TYPE_BOOL",
            "Disable Flash",
        ],
        [
            "TYPE_BOOL",
            "Disable Pause",
        ],
        [
            "TYPE_CHOICES",
            "Dark Mode",
            "dark",
        ],
        [
            "TYPE_BOOL",
            "Goofy Foot",
        ],
        [
            "TYPE_BOOL",
            "Block Tool",
        ],
        [
            "TYPE_BOOL",
            "Linecap",
        ],
        [
            "TYPE_BOOL",
            "DAS Only",
        ],
        [
            "TYPE_BOOL",
            "Qual Mode",
        ],
    ],
    [
        [
            "TYPE_TITLE",
            "Page 5",
        ],
        [
            "TYPE_BOOL",
            "Pal Mode",
        ],
    ],
]

strings = {
    bool: [
        "Off",
        "On",
    ],
    score: [
        "Classic",
        "Letters",
        "7Digit",
        "M",
        "Hidden",
    ],
    crash: [
        "Off",
        "Shown",
        "Topout",
        "Crash",
    ],
    dark: [
        "Off",
        "On",
        "Lite",
        "Teal",
        "OG",
    ],
    modes: [
        "TETRIS",
        "TSPINS",
        " SEED ",
        "STACKN",
        " PACE ",
        "SETUPS",
        "B-TYPE",
        "FLOOR ",
        "CRUNCH",
        "QCKTAP",
        "TRNSTN",
        "MARTHN",
        "TAPQTY",
        "CKRBRD",
        "GARBGE",
        "LOBARS",
        "DASDLY",
        "LOWSTK",
        "KILLX2",
        "INVZBL",
        "HRDDRP",
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
