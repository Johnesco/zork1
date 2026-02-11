# Zork I: Inform 7 Edition — Project Guide

## Project Overview

ZIL-to-Inform 7 translation of Zork I: The Great Underground Empire.
The Inform 7 source is the living document; the ZIL files are read-only reference.

## GitHub Repository

- **Working repository**: `Johnesco/zork1` — ALL issues, PRs, and code changes go here
- **Upstream (read-only reference)**: `historicalsource/zork1` — DO NOT create issues or PRs here
- When using `gh` CLI, always use `--repo Johnesco/zork1` or ensure the default repo is correct

## Repository Layout

```
src/zil/           Original ZIL source files (read-only reference)
src/inform7/       Inform 7 source (story.ni) — the canonical game source
build/             Inform 7 project used for compilation (build/zork1.inform/)
tools/             Inform 7 compiler and interpreters
web/               GitHub Pages site deployed to johnesco.github.io/zork1/
  index.html       Landing page — project description, version links
  v1/              Version 1 archive (self-contained snapshot)
    index.html     Quixe player page
    story.ni       Inform 7 source at time of release
    zork1.ulx.js   Compiled story (base64-encoded Glulx)
    lib/            jQuery, GlkOte, Quixe
    media/          waiting.gif
```

## Web Version Architecture

### Landing Page (`web/index.html`)
- Dark/parchment aesthetic matching the game player
- Links to Play and View Source for the current version
- Reverse-chronological version history with descriptions

### Versioned Archives (`web/vN/`)
Each version directory is a **self-contained snapshot** containing:
- `index.html` — Quixe player (plays the game in-browser)
- `story.ni` — Inform 7 source code at that version
- `zork1.ulx.js` — Compiled story file
- `lib/` — Client-side libraries (jQuery, GlkOte, Quixe)
- `media/` — Assets

### Versioning Workflow
When creating a new version:
1. The current `web/vN/` becomes a frozen archive
2. Create `web/vN+1/` with the new build files and updated `story.ni`
3. Update `web/index.html`: add new version entry, update "Play Current Version" link
4. The landing page always links the latest version at the top

### Deployment
GitHub Actions (`.github/workflows/deploy-pages.yml`) deploys the entire `web/` directory to GitHub Pages on push to `main`. No build step — the `web/` directory is uploaded as-is.

- Landing page: `johnesco.github.io/zork1/`
- Version N: `johnesco.github.io/zork1/vN/`

## Building the Game

1. The Inform 7 source is `src/inform7/story.ni`
2. Compile using the Inform 7 IDE or CLI tools in `tools/`
3. The build project lives at `build/zork1.inform/`
4. Output: `zork1.ulx` (Glulx story file)
5. For web deployment: encode to base64 JS with `zork1.ulx.js`

## Key Game Systems (for reference when editing story.ni)

- **Scoring**: 350 max, trophy case accumulation, won-flag at 240+
- **Thief**: Roams every 5 turns, steals valuables, repelled by garlic
- **Lamp**: 400-turn timer with warnings
- **Candles**: 40-turn timer (stages at 20/30/35/40), wind-sensitive
- **Matches**: 6 total, 2-turn burn, drafty rooms extinguish instantly
- **River**: Auto-downstream with per-room turn limits, falls = death
- **Exorcism**: bell (hot) → candles (drop) → book (banish), multi-phase timer
- **Dam**: Yellow button powers, bolt+wrench opens gates, 8-turn reservoir
- **Cyclops**: Feed lunch → give water → sleep, OR say "odysseus"
- **Coal→Diamond**: Machine transformation puzzle
- **Boat**: Inflate with pump, sharp objects puncture on boarding
