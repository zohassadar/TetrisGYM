#!/usr/bin/env python3

import itertools

import numpy as np
from PIL import Image

ORIGINAL = "game_tileset_original.png"
GAME_TILESET = "game_tileset.png"

"""
T 32 0
S 32 24
Z 32 48
J 32 72
L 32 96
"""

original = Image.open(ORIGINAL)
array = np.asarray(original)
new_array = array.copy()

# T
new_array[85:90, 0:24] = array[43:48, 0:24]
new_array[91:96, 0:24] = array[37:42, 0:24]

# S
new_array[85:90, 24:48] = array[43:48, 24:48]
new_array[91:96, 24:48] = array[37:42, 24:48]

# Z
new_array[85:90, 48:72] = array[43:48, 48:72]
new_array[91:96, 48:72] = array[37:42, 48:72]

# J
new_array[84:89, 72:96] = array[42:47, 72:96]
new_array[90:95, 72:96] = array[36:41, 72:96]

# L
new_array[84:89, 96:120] = array[42:47, 96:120]
new_array[90:95, 96:120] = array[36:41, 96:120]


new_image = Image.fromarray(new_array)
new_image = new_image.convert("P")
new_image.putpalette(itertools.chain(*original.palette.colors))
new_image.save(GAME_TILESET)
