# Pending
* lowstack should be option instead of mode
* rework tests to fit multi mode
* multiple scoreboards
* clear scoreboard individually
* height 6-8 logic can be rearranged to be closer to vanilla
* hz_display, constants, crunch, harddrop & floor tests need adjustment
* try das meter 1 tile narrower and left/right aligned with playfield vs centered
* move secret grade over when 7 digit scoring is enabled
* move nextpiece option to display
* trans/marathon/sxotkl on one page?
* save/load custom palette to/from sram
* add "x100k" to pace modifier label
* cleanup keyboard seed entry code

# Bugs
* harddrop mode skips events
* garbage + crunch or floor does not work well
* lowstack line doesn't respond to vert mirror flag
* lowstack nope gets mirrored with horiz mirror flag
* game timer continues after b-game end
* linecap lines highbyte is bcd, needs to be converted to binary
* tap quantity mode should ignore floor/crunch
* next piece isn't affected by mirror flags
* initial trt doesn't display when block tool enabled
