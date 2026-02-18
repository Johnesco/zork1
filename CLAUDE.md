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
src/zil/           Original ZIL source files (read-only, NEVER modify)
src/inform7/       Inform 7 source (story.ni) — the canonical game source
build/             Inform 7 project used for compilation (build/zork1.inform/)
tools/             Inform 7 compiler, interpreters, ZILF compiler
tests/             Test infrastructure
  inform7/         Inform 7 walkthrough and output
  zil/             ZIL walkthrough and output
  *.regtest        RegTest scripts
  regtest.py       RegTest runner
  run-tests.sh     RegTest runner script
web/               GitHub Pages site deployed to johnesco.github.io/zork1/
  index.html       Landing page — project description, version links
  source.html      Live source browser (fetches from main branch)
  v0/              Original ZIL — source browser + playable ZIL-compiled game
  v1/, v2/, ...    Inform 7 milestone archives (self-contained snapshots)
```

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
  index.html        ZIL source browser with syntax highlighting and annotations
  parchment.html    Parchment player page (plays ZIL-compiled .z3)
  zork1.z3.js       Compiled ZIL game (base64 Z-machine, built from original ZIL)
```

**v1+** (Inform 7):
```
web/vN/
  index.html        Quixe player page
  parchment.html    Parchment player page
  glulxe.html       Glulxe (WASM) player page
  source.html       Inform 7 source browser (renders this version's story.ni)
  story.ni          Frozen Inform 7 source snapshot
  zork1.ulx.js      Compiled game (base64 Glulx, built from THIS story.ni)
  lib/              Client-side libraries
  media/            Assets
```

### Source Browsers

- **Root-level** (`web/source.html`) — Shows live development source from `main` branch (fetches from `raw.githubusercontent.com`)
- **Per-version** (`web/vN/source.html`) — Shows the frozen source for that version (fetches local `story.ni`)
- **v0** (`web/v0/index.html`) — ZIL source browser with annotations (already exists)

### Landing Page (`web/index.html`)

- Dark/parchment aesthetic matching the game player
- Engine selector (Quixe/Parchment/Glulxe) with `localStorage` persistence
- Reverse-chronological order: newest version at top, v0 at bottom
- Each version entry shows: Play Online, Download Source, Browse Source buttons (where applicable)

### Versioning Workflow

When creating a new version (vN+1):

1. Finish all code changes in `src/inform7/story.ni`
2. Compile to `build/zork1.ulx` using Inform 7 compiler
3. Run RegTest suite: `wsl -e bash -c 'cd /mnt/c/code/zork1 && bash tests/run-tests.sh'`
4. Run walkthrough (`tests/inform7/walkthrough.txt`) against the new `.ulx` via glulxe and verify expected score
5. Only after tests pass:
   - Copy `src/inform7/story.ni` → `web/vN+1/story.ni`
   - Base64-encode `build/zork1.ulx` → `web/vN+1/zork1.ulx.js`
   - Copy `web/source.html` into `web/vN+1/source.html`, change `RAW_URL` to `'story.ni'` (relative fetch) and update the sidebar header to show the version name
   - Copy player pages and `lib/` from previous version (or rebuild)
6. Update `web/index.html`: add new version entry
7. The previous version is now frozen — **NEVER modify after release**

**Critical rule**: Every `web/vN/` (v1+) must contain a `story.ni` and `zork1.ulx.js` compiled from that exact source. Never copy stale binaries or source from a previous version. The source browser in each version must render its own local `story.ni`.

### Deployment

GitHub Actions (`.github/workflows/deploy-pages.yml`) deploys the entire `web/` directory to GitHub Pages on push to `main`. No build step — the `web/` directory is uploaded as-is.

- Landing page: `johnesco.github.io/zork1/`
- Version N: `johnesco.github.io/zork1/vN/`

## Testing Policy

When running tests (RegTest, walkthrough, or manual play-testing), **report any failures or issues found but do not make code changes unless explicitly instructed**. Testing is observational — log what broke, where, and why, then wait for direction before fixing.

Each version has its own walkthrough and output:
- `tests/inform7/walkthrough.txt` + `walkthrough_output.txt` — for the Inform 7 version
- `tests/zil/walkthrough.txt` + `walkthrough_output.txt` — for the ZIL-compiled version

## Building the Game

### Inform 7 (v1+)

1. Sync source: `cp src/inform7/story.ni build/zork1.inform/Source/story.ni`
2. Compile I7→I6: `tools/inform7/extracted/Compilers/inform7.exe -internal tools/inform7/extracted/Internal -project build/zork1.inform`
3. Compile I6→Glulx: `tools/inform7/extracted/Compilers/inform6.exe -w -G "build/zork1.inform/Build/auto.inf" "build/zork1.inform/Build/output.ulx"`
4. Copy output: `cp build/zork1.inform/Build/output.ulx build/zork1.ulx`
5. Test with glulxe (WSL): `wsl -e bash -c '/home/johnesco/glulxe/glulxe -q build/zork1.ulx < tests/inform7/walkthrough.txt'`

### ZIL (v0)

1. Source: `the-infocom-files/zork1` repo (cloned at `C:\code\zork1-zil/`) + `the-infocom-files/zork-substrate` (at `C:\code\zork-substrate/`)
2. Compile: `cd C:\code\zork1-zil && C:\tools\zilf\bin\zilf.exe zork1.zil` → produces `zork1.z3`
3. Test with dfrotz (WSL): `wsl -e bash -c '~/frotz-install/usr/games/dfrotz -q /mnt/c/code/zork1-zil/zork1.z3 < tests/zil/walkthrough.txt'`

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
