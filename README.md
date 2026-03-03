# Zork I: The Great Underground Empire — Inform 7 Edition

An [Inform 7](http://inform7.com/) translation of Infocom's *Zork I*, based on the [original ZIL source code](https://github.com/historicalsource/zork1) released under the MIT License by Microsoft, Activision, and Team Xbox.

This project begins as a faithful 1:1 translation of the original game and evolves through versioned milestones — from bug fixes and testing infrastructure to new features that lean into what Inform 7 does best.

## Play Online

**[Play on IF Hub](https://johnesco.github.io/ifhub/)** — all versions available through the unified IF Hub player.

Each version includes playable games, browsable source code, and annotated walkthroughs.

## Version History

### v4 — Modern IF (Current)

Applying modern interactive fiction writing best practices — richer parser responses, smoother player interactions, better default messages, and more helpful feedback. Includes CSS atmospheric effects: zone-reactive mood color palettes, CRT terminal intro, animated tree canopy and falling leaves, golden egg explosion, reversed status bar, and synchronized color transitions.

### v3 — Making It My Own

The first version that intentionally diverges from the original. Adds ambient audio — zone-based background music and sound effects via native Glk/blorb sound (`.gblorb` binary with embedded `.ogg` audio played through Parchment's Emglken WASM engine).

### v2 — Bug Fixes & Testing

Fixes bugs from the original ZIL source (things Infocom shipped broken) and translation bugs from the v1 port. Established the deterministic testing methodology — seed-based RNG walkthroughs, transcript comparison, and automated regression — that now underpins all development.

### v1 — The Port

Complete, playable, winnable ZIL-to-Inform 7 translation. Every room, puzzle, text response, and behavior from the original. Text parity with v0 achieved after a 6-phase audit of every ZIL TELL response.

- 110+ rooms across five regions (forest/house, cellar/troll area, maze, dam/river, coal mine)
- All 19 treasures with trophy case scoring system (350 points max)
- NPCs: Thief (roaming daemon, combat, treasure redistribution), Troll, Cyclops
- Full puzzle systems: dam/reservoir, exorcism ceremony, coal-to-diamond machine, boat/river, mirror rooms
- Lamp timer, candle timer, match system, death/resurrection, grue darkness, sword glow

### v0 — The Original ZIL

The unmodified Infocom source code with a ZIL source browser, syntax highlighting, annotations, and a playable game compiled from the original ZIL using ZILF.

## Project Structure

```
story.ni           Inform 7 source (current working version)
tests/             Test suites, walkthroughs, seed configs
src/zil/           Original ZIL source files (read-only reference)
web/               Site-level pages (landing, map, scenarios)
versions/          Frozen version snapshots
  v0/              Original ZIL — source browser + playable game
  v1/              Inform 7 port — 1:1 translation
  v2/              Bug fixes and testing
  v3/              New features (ambient audio)
  v4/              Modern IF (CSS effects, better parser)
_site/             Assembled deploy directory (gitignored)
```

## Building

The Inform 7 source is `story.ni` at the repo root. To compile, open it in the [Inform 7 IDE](http://inform7.com/downloads/) or use the command-line compilers from the Inform 7 distribution.

## Testing

Testing uses deterministic walkthroughs with seed-based RNG (`glulxe --rngseed N`) for reproducible runs, plus RegTest for targeted scenario testing of specific puzzles and mechanics. Test scripts are in `tests/`.

## Credits

*Zork I: The Great Underground Empire* was written by Marc Blank, Dave Lebling, Bruce Daniels, and Tim Anderson, and published by [Infocom](https://en.wikipedia.org/wiki/Infocom).

The original ZIL source code is available at [historicalsource/zork1](https://github.com/historicalsource/zork1) under the MIT License, courtesy of Microsoft, Activision, and Team Xbox.

This Inform 7 translation is an unofficial fan project. Zork is a trademark of Activision Publishing, Inc.

## License

The original Zork I source code is licensed under the [MIT License](https://github.com/historicalsource/zork1/blob/master/LICENSE). This derivative work is also released under the MIT License — see [LICENSE](LICENSE) for details.
