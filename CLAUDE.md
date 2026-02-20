# Zork I: Inform 7 Edition — Project Guide

## Project Overview

ZIL-to-Inform 7 translation of Zork I: The Great Underground Empire.
The Inform 7 source is the living document; the ZIL files are read-only reference.

## GitHub Repository

- **Working repository**: `Johnesco/zork1` — ALL issues, PRs, and code changes go here
- **Upstream (read-only reference)**: `historicalsource/zork1` — DO NOT create issues or PRs here
- When using `gh` CLI, always use `--repo Johnesco/zork1` or ensure the default repo is correct

## Repository Layout

This repo is the **web display layer only** — it holds the GitHub Pages site and read-only ZIL reference. All Inform 7 authoring, building, and testing lives in `C:\code\inform7\`.

```
src/zil/           Original ZIL source files (read-only, NEVER modify)
web/               GitHub Pages site deployed to johnesco.github.io/zork1/
  index.html       Landing page — project description, version links
  v0/              Original ZIL — source browser + playable ZIL-compiled game
  v1/, v2/, ...    Inform 7 version archives (self-contained snapshots)
```

## Inform 7 Hub (External)

All Inform 7 source, compilation, and testing lives in the shared hub:

```
C:\code\inform7\
├── CLAUDE.md                      ← Inform 7 conventions and compiler paths
├── tools/
│   └── regtest.py                 ← Shared test runner
├── reference/                     ← Syntax + formatting docs
└── projects/zork1/
    ├── story.ni                   ← Current version (EDIT HERE)
    ├── zork1.inform/              ← IDE bundle + compilation workspace
    ├── zork1.materials/
    ├── zork1.ulx                  ← Compiled output
    └── tests/                     ← All test scripts + data
```

**Compiler**: System-wide install at `C:\Program Files\Inform 7\` (see `C:\code\inform7\CLAUDE.md` for CLI usage).

Any `story.ni` files found inside this repo (e.g., `web/vN/story.ni`) are **frozen snapshots**. The current version lives only in the Inform 7 hub (`C:\code\inform7\projects\zork1\story.ni`) and is never published to the web directly — it is snapshotted into a numbered version when ready. Always edit the hub copy and build from there.

## Version Philosophy

Versions are displayed on the landing page with the **newest at top, v0 at bottom**. The original ZIL source in `src/zil/` is **sacred and must never be modified** — all changes carry forward into Inform 7 versions only.

**The most recent version is the default work target.** If no version is specified, work on the latest version.

When possible, every version should provide three buttons:
- **Play Online** — launch the game in the browser
- **Download Source** — download the source code file
- **Browse Source** — syntax-highlighted source browser

### v0 — The Original ZIL

The unmodified Infocom ZIL source code, exactly as released. Includes a ZIL source browser with syntax highlighting and annotations. Also includes a playable game compiled from the original ZIL using ZILF (Z-machine format, played via Parchment). The ZIL source is **never modified** — it is the historical reference that all other versions are measured against.

### v1 — Faithful Inform 7 Port

A complete, playable, and winnable translation of Zork I from ZIL to Inform 7. This version is a **faithful port only** — it reproduces the original game as accurately as possible, including all original bugs. No bug fixes, no enhancements, no quality-of-life improvements. The goal is a 1:1 behavioral match with the ZIL version.

### v2 — Bug Fixes

Begins fixing bugs from the original ZIL source, plus translation bugs introduced during the v1 port. Quality-of-life improvements, parser enhancements, and text corrections. Each fix is tracked with a GitHub issue noting what was changed and why.

### v3 — Ambient Audio & Testing (Current)

Experimental features and developer tooling. Includes ambient audio system (zone-based background music using CC0 audio loops), built-in Test commands for smoke-testing key puzzles, and RegTest infrastructure for automated regression testing. Linked from the landing page with its own compiled binary and source snapshot.

## Web Version Architecture

### Per-Version Contents

**v0** (ZIL):
```
web/v0/
  index.html            ZIL source browser with syntax highlighting and annotations
  parchment.html        Parchment player page (plays ZIL-compiled .z3)
  zork1.z3.js           Compiled ZIL game (base64 Z-machine, built from original ZIL)
  walkthrough.html      Walkthrough viewer (fetches local walkthrough files)
  walkthrough.txt       Raw walkthrough commands (ZIL version)
  walkthrough-guide.txt Annotated walkthrough guide (ZIL version)
```

**v1+** (Inform 7):
```
web/vN/
  index.html            Quixe player page
  parchment.html        Parchment player page
  glulxe.html           Glulxe (WASM) player page
  source.html           Inform 7 source browser (renders this version's story.ni)
  story.ni              Frozen Inform 7 source snapshot
  zork1.ulx.js          Compiled game (base64 Glulx, built from THIS story.ni)
  walkthrough.html      Walkthrough viewer (fetches local walkthrough files)
  walkthrough.txt       Raw walkthrough commands
  walkthrough-guide.txt Annotated walkthrough guide
  lib/                  Client-side libraries
  media/                Assets
```

### Source Browsers

- **Per-version** (`web/vN/source.html`) — Shows the frozen source for that version (fetches local `story.ni`)
- **v0** (`web/v0/index.html`) — ZIL source browser with annotations (already exists)

### Landing Page (`web/index.html`)

- Dark/parchment aesthetic matching the game player
- Engine selector (Quixe/Parchment/Glulxe) with `localStorage` persistence
- Reverse-chronological order: newest version at top, v0 at bottom
- Each version entry shows: Play Online, Download Source, Browse Source buttons (where applicable)

### Versioning Workflow

The **current version** (`C:\code\inform7\projects\zork1\story.ni`) is the working copy where all development happens. It is snapshotted into numbered versions when ready. The **latest numbered version** (currently v3) may be updated many times — it is republished from the current version as development progresses. Once a **new version is created** (e.g., v4), the previous one (v3) becomes permanently **frozen** and is never modified again. Only the latest numbered version and the current version ever change.

When creating a new version (vN+1):

1. Finish all code changes in the current version (`C:\code\inform7\projects\zork1\story.ni`)
2. Build in `C:\code\inform7\projects\zork1\` (see "Building the Game" below)
3. Run RegTest suite: `wsl -e bash -c 'cd /mnt/c/code/inform7/projects/zork1 && bash tests/run-tests.sh'`
4. Run walkthrough: `wsl -e bash -c 'cd /mnt/c/code/inform7/projects/zork1 && bash tests/run-walkthrough.sh'`
5. Only after tests pass:
   - Copy `C:\code\inform7\projects\zork1\story.ni` → `web/vN+1/story.ni`
   - Base64-encode `C:\code\inform7\projects\zork1\zork1.ulx` → `web/vN+1/zork1.ulx.js`
   - Copy `source.html` from the previous version into `web/vN+1/source.html`, change `RAW_URL` to `'story.ni'` (relative fetch) and update the sidebar header to show the version name
   - Copy `walkthrough.html` from the previous version into `web/vN+1/walkthrough.html`, update title and sidebar header with version name, change back link to `../`
   - Copy `C:\code\inform7\projects\zork1\tests\inform7\walkthrough.txt` → `web/vN+1/walkthrough.txt`
   - Copy `C:\code\inform7\projects\zork1\tests\inform7\walkthrough-guide.txt` → `web/vN+1/walkthrough-guide.txt`
   - Copy player pages and `lib/` from previous version (or rebuild)
6. Update `web/index.html`: add new version entry
7. The previous version is now frozen — **NEVER modify after release**

**Critical rule**: Every `web/vN/` (v1+) must contain a `story.ni` and `zork1.ulx.js` compiled from that exact source. Never copy stale binaries or source from a previous version. The source browser in each version must render its own local `story.ni`.

### Deployment

GitHub Actions (`.github/workflows/deploy-pages.yml`) deploys the entire `web/` directory to GitHub Pages on push to `main`. No build step — the `web/` directory is uploaded as-is.

- Landing page: `johnesco.github.io/zork1/`
- Version N: `johnesco.github.io/zork1/vN/`

## Testing Policy

All testing happens in `C:\code\inform7\projects\zork1\`. See `C:\code\inform7\CLAUDE.md` and the project's `tests/` folder for scripts and data.

**Policy**: Report failures, don't fix unless explicitly instructed.

## Building the Game

All building happens in `C:\code\inform7\projects\zork1\`. See `C:\code\inform7\CLAUDE.md` for compiler paths, build steps, and interpreter usage.

ZIL (v0) is compiled separately from `C:\code\zork1-zil\` using ZILF.

## Key Game Systems (for reference when editing story.ni)

- **Scoring**: 350 max = room visits (65) + first-take bonuses (147) + trophy case (133) + light-shaft (13) − deaths (10 each). Won-flag at 350.
- **Thief**: Roams every 5 turns, steals valuables, repelled by garlic
- **Lamp**: 200-turn timer with warnings at 100, 130, 185, and 200 turns elapsed
- **Candles**: 40-turn timer (stages at 20/30/35/40), wind-sensitive
- **Matches**: 6 total, 2-turn burn, drafty rooms extinguish instantly
- **River**: Auto-downstream with per-room turn limits, falls = death
- **Exorcism**: bell (hot) → candles (drop) → book (banish), multi-phase timer
- **Dam**: Yellow button powers, bolt+wrench opens gates, 8-turn reservoir
- **Cyclops**: Feed lunch → give water → sleep, OR say "odysseus"
- **Coal→Diamond**: Machine transformation puzzle
- **Boat**: Inflate with pump, sharp objects puncture on boarding
