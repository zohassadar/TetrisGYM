
# TetrisGYM

<div align="center">
    <img src="./screens/menu.png" alt="Menuscreen">
    <br>
</div>
<br>

* [Getting Started](#guide)
* [Modes](#modes)
    * [Play](#play)
    * [T-Spins](#tspins)
    * [Stacking](#stacking)
    * [Setups](#setups)
    * [Floor](#floor)
    * [(Quick)Tap](#tap)
    * [Drought](#drought)
    * [Debug Mode](#debug)
    * [PAL Mode](#pal)
* [Resources](#resources)

## Getting Started

TetrisGYM is distributed in the form of an BPS patch and can be applied with [Rom PatcherJS](https://www.romhacking.net/patch/) or similar.

It can only be applied to the USA version of the ROM. However, after patching it will detect your console region, and gameplay will either match the corresponding NTSC or PAL versions of the game.

A link to the BPS can be found in the releases page. [TODO ADD LINK]

## Modes

### Play

![Play](/screens/play.png)

Same gameplay as Type-A, with some improvements. No score cap, no rocket, no curtain, always next box, better pause, extended level select.

There are various other small changes

### T-Spins

![T-Spins](/screens/tspins.png)

Spawn T-Spins in random X and Y positions. Additional entry delay on successful T-Spin to prepare for the next state.

### Stacking

![Stackin](/screens/stacking.png)

An experiment to highlight bad areas of the playfield in an attempt to improve stacking.

## Resources

upstream repo: [https://github.com/CelestialAmber/TetrisNESDisasm](https://github.com/CelestialAmber/TetrisNESDisasm)  
disassembly information: [https://github.com/ejona86/taus](https://github.com/ejona86/taus)

