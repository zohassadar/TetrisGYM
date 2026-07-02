# Pending
* lowstack should be option instead of mode
* rework tests to fit multi mode
* add animation to cursor arrows
* multiple scoreboards
* clear scoreboard individually
* height 6-8 logic can be rearranged to be closer to vanilla
* hz_display, constants, crunch, harddrop & floor tests need adjustment
* trans flag to enable score/lines runway, default 12 for lines, 5 for score
* 4 digit score toggle, remove from scoring

# Bugs
* harddrop mode skips events
* lowstack & crunch do not work together
* garbage + crunch or floor does not work well
* lowstack line doesn't respond to vert mirror flag
* lowstack nope gets mirrored with horiz mirror flag
* rendering glitches with the following:
    - m scoring, game timer, tetris rate, floor 9 and dark mode lite, input display
    - top out normally, start
* harddrop can eat top row of floor
* harddrop does not clear lines on top row
* vert mirroring line clears are not inverted
* abss while on a seed will shuffle seed
* hex/bcd input cursor overlaps with value above
* custom level can get reset to 0
