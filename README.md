# Zork I: The Great Underground Empire — Inform 7 Edition

An [Inform 7](http://inform7.com/) translation of Infocom's *Zork I*, based on the [original ZIL source code](https://github.com/historicalsource/zork1) released under the MIT License by Microsoft, Activision, and Team Xbox.

This project begins as a faithful translation of the original game and will evolve to include bug fixes, quality of life improvements, and parser enhancements — while preserving the spirit and challenge of the classic.

## Play Online

**[Play the latest version](https://johnesco.github.io/zork1/)** — hosted on GitHub Pages with full in-browser gameplay via [Quixe](https://eblong.com/zarf/glulx/quixe/).

The Inform 7 source code for each version is also available directly from the site.

## Goals

- **Faithful translation** — Start from a complete, accurate port of the original ZIL logic to Inform 7
- **Bug fixes** — Address known issues present in the original release
- **Quality of life improvements** — Modernize rough edges without undermining the original design
- **Parser enhancements** — Expand recognized vocabulary and phrasings so the game better understands what you mean

## Project Structure

```
src/zil/           Original ZIL source files (reference)
src/inform7/       Inform 7 translation (story.ni)
build/             Inform 7 compilation project
web/               GitHub Pages site
  index.html       Landing page with version history
  v1/              Version 1 — playable game + source snapshot
```

## Building

The Inform 7 source is in `src/inform7/story.ni`. To compile, open it in the [Inform 7 IDE](http://inform7.com/downloads/) or use the command-line tools from the [Inform distribution](https://github.com/ganelson/inform).

## Version History

### v1 — First Light

Complete ZIL-to-Inform 7 translation of Zork I:

- 110+ rooms across five regions (forest/house, cellar/troll area, maze, dam/river, coal mine)
- All 19 treasures with trophy case scoring system (350 points max)
- NPCs: Thief (roaming daemon, combat, treasure redistribution), Troll, Cyclops
- Full puzzle systems: dam/reservoir, exorcism ceremony, coal-to-diamond machine, boat/river, mirror rooms
- Lamp timer, candle timer, match system, death/resurrection, grue darkness, sword glow
- Verbosity modes, score ranks, and diagnostic commands

## Credits

*Zork I: The Great Underground Empire* was written by Marc Blank, Dave Lebling, Bruce Daniels, and Tim Anderson, and published by [Infocom](https://en.wikipedia.org/wiki/Infocom).

The original ZIL source code is available at [historicalsource/zork1](https://github.com/historicalsource/zork1) under the MIT License, courtesy of Microsoft, Activision, and Team Xbox.

This Inform 7 translation is an unofficial fan project. Zork is a trademark of Activision Publishing, Inc.

## License

The original Zork I source code is licensed under the [MIT License](https://github.com/historicalsource/zork1/blob/master/LICENSE). This derivative work is also released under the MIT License — see [LICENSE](LICENSE) for details.
