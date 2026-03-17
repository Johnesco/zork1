# Zork I: Inform 7 Edition — Project Guide

## Project Overview

ZIL-to-Inform 7 translation of Zork I: The Great Underground Empire.
The Inform 7 source is the living document; the ZIL files are read-only reference.

## GitHub Repository

- **Working repository**: `Johnesco/zork1` — ALL issues, PRs, and code changes go here
- **Upstream (read-only reference)**: `historicalsource/zork1` — DO NOT create issues or PRs here
- When using `gh` CLI, always use `--repo Johnesco/zork1` or ensure the default repo is correct

## Repository Layout

This repo contains the Inform 7 source, tests, and the GitHub Pages web site — everything for the project in one place.

```
story.ni           Current Inform 7 source (EDIT HERE)
zork1.ulx          Compiled output (gitignored — rebuild from story.ni)
index.html         Landing page — project description, version links
play.html          Standard Parchment player for latest version (local dev entry point)
source.html        Source browser for current version
walkthrough.html   Walkthrough viewer
lib/parchment/     7 engine files + zork1.gblorb.js (game + audio bundle)
v0/                Original ZIL — source browser + playable ZIL-compiled game
v1/, v2/, ...      Inform 7 version archives (self-contained snapshots)
tests/             Test scripts, walkthroughs, regtest data
src/zil/           Original ZIL source files (read-only, NEVER modify)
src/sharpee/       Sharpee source files
Sounds/            Audio asset files (.ogg) for Blorb packaging
zork1.blurb        Blorb packaging manifest (maps sound IDs to .ogg files)
scenarios/         Scenario guides and transcripts
```

## Inform 7 Shared Tools (External)

Compiler conventions, shared test framework, and reference docs live in the shared hub. For standard build/test/publish workflows, see `C:\code\ifhub\reference\project-guide.md`.

**Compiler**: System-wide install at `C:\Program Files\Inform 7\` (see `C:\code\ifhub\CLAUDE.md` for CLI usage).

Any `story.ni` files found inside version directories (e.g., `vN/story.ni`) are **frozen snapshots**. The current version is `story.ni` at the repo root — it is never published to the web directly but snapshotted into a numbered version when ready.

## Version Philosophy

Each version is a **playable milestone** that tells a chapter of the project story. Together they form a portfolio trail showing design choices, testing methodology, and the evolution from faithful port to something new. Versions are displayed on the landing page with the **newest at top, v0 at bottom**.

The original ZIL source in `src/zil/` is **sacred and must never be modified** — all changes carry forward into Inform 7 versions only.

### Frozen Versions vs Current

There are two kinds of playable versions:

- **vN** (v0, v1, v2, v3...) — frozen published snapshots. Each has a subtitle (e.g., "v3 — Multimedia"). Once published, immutable. Lives in `vN/` with its own `story.ni` and compiled binary.
- **Current** — the root `story.ni`, always in progress. Displayed as "Game Name (Current)" in the hub and landing page. Has no version number. Changes freely. When ready, it gets frozen into the next numbered version.

**The current version is the default work target.** If no version is specified, work on current (root `story.ni`).

### Self-Contained Versions

Starting with v1, every version is a **self-contained snapshot** with its own:
- `story.ni` — Inform 7 source code (the authoritative source for that version)
- Game binary — `zork1.ulx.js` (v1/v2) or `zork1.gblorb.js` (v3+, includes bundled audio)
- Walkthrough, source browser, and player pages

**Binary rule**: Never edit `.ulx`, `.ulx.js`, `.gblorb`, or `.gblorb.js` files directly. Always compile from the version's own `story.ni` source.
- **v1/v2 workflow**: edit `story.ni` → compile → base64-encode `.ulx` → update `zork1.ulx.js`
- **v3+ workflow**: edit `story.ni` → compile to `.ulx` → package with `cBlorb` into `.gblorb` → base64-encode → update `zork1.gblorb.js`

### Change Propagation

**Changes only propagate upward, never downward.** If a fix is made in v1, it must also be applied to v2, v3, and all later versions — as if the fix had always been in v1 and was naturally inherited by everything above it. Never apply a higher version's changes to a lower version.

This means each version is always a strict superset of the one below it: v2 contains everything in v1 plus its own changes, v3 contains everything in v2 plus its own, and so on.

### Patching Frozen Versions

Once a version is published, it is **frozen**. All new work goes into current (root). Do not edit past versions unless explicitly asked.

In rare cases a past version may be patched (e.g., a translation bug discovered in v1). If that happens:
1. Edit that version's own `vN/story.ni` directly
2. Compile from that source to produce a new binary (`.ulx` for v1/v2, `.gblorb` for v3+)
3. Base64-encode into `vN/lib/parchment/zork1.ulx.js` (v1/v2) or `zork1.gblorb.js` (v3+)
4. Propagate the same fix upward to all later versions and to current, recompile each

When possible, every version should provide three buttons:
- **Play Online** — launch the game in the browser
- **Download Source** — download the source code file
- **Browse Source** — syntax-highlighted source browser

### v0 — The Original ZIL

The unmodified Infocom ZIL source code, exactly as released. Includes a ZIL source browser with syntax highlighting and annotations. Also includes a playable game compiled from the original ZIL using ZILF (Z-machine format, played via Parchment). The ZIL source is **never modified** — it is the historical reference that all other versions are measured against.

### v1 — The Port

A complete, playable, and winnable translation of Zork I from ZIL to Inform 7. **Everything in the ZIL version must make it here** — every room, puzzle, text response, and behavior. No fixes, no enhancements, no quality-of-life improvements. The goal is a 1:1 gameplay match with the ZIL version. Some original ZIL bugs naturally vanish in translation to a modern engine — that's fine, don't force them back in. v1 is measured by whether the gameplay matches v0, not by whether it preserves bugs for their own sake.

The translation revealed surprising differences between the two languages. What looked correct on the surface often failed under testing — containment semantics (`the player is in X` vs. `the location of the player`), action routing (`move the player to` bypassing After rules), property conflicts (I7's built-in `visible` clashing with custom properties), and the discovery that hundreds of ZIL text responses had no Inform 7 equivalent. Text parity with v0 is now complete after a 6-phase audit of every ZIL TELL response.

### v2 — Bug Fixes & Testing

The first version that changes the game rather than just translating it — but still within ZIL's intent. Fixes bugs from the original ZIL source (things Infocom shipped broken) and translation bugs introduced during the v1 port. Behavior still aims to match what ZIL *meant* to do, not what Inform 7 might do differently.

This is also where the testing methodology was established — it now underpins all development across every version. Each fix is tracked with a GitHub issue noting what was changed and why. Changes propagate to all higher versions.

### v3 — Multimedia

Where it intentionally diverges from ZIL-faithful behavior and starts leaning into what Inform 7 does best. v1 and v2 are bound to the original; v3 and beyond are not. This version adds two major enhancements: **ambient audio** and **CSS atmospheric effects**.

**Native Glk Sound** — zone-based background music and sound effects that respond to room changes, driven from story.ni via Glk sound channels, with audio files bundled into `.gblorb` packages played through Parchment's Emglken WASM engine. The story.ni includes:
- **Sound declarations**: 9 ambient zone loops + 16 one-shot sound effects (`.ogg` files)
- **Audio zones**: Every room assigned to a zone (forest, house, cave, water, rapids, loud, hades, mine, machinery, silence)
- **Ambient audio rule**: Crossfades zone-based background loops on room change using dual Glk background channels
- **Sound effects**: Triggered inline (`play the sound of X as sfx`) at key game events (grue attacks, match strikes, doors opening, etc.)
- **Sound auto-detect**: Uses `glk_gestalt(gestalt_Sound, 0)` to auto-enable sound when the interpreter supports it (Parchment WASM) — no startup prompt. `SOUND ON` / `SOUND OFF` commands available in-game

**CSS Atmospheric Effects** — v3 includes a mood theming system in `play.html` that transforms the player into an immersive atmospheric experience:

- **Mood palette zones**: Each room is mapped to a color zone (forest, house, cave, water, rapids, loud, hades, mine, machinery, silence). Room changes trigger smooth CSS variable transitions via Houdini `@property` color interpolation (1.2s ease-in-out).
- **Reversed status bar**: The GridWindow (status line) uses buffer text color as background with bold black text — inverted from the normal scheme. Uses `!important` to override GlkOte inline styles.
- **CRT intro**: Green terminal aesthetic on startup (`#00ff41` text, scanline overlay, flickering scanbar) that fades out after the first user input.
- **Up a Tree effects**: When in "Up a Tree", a forest canopy glow overlay and 24 animated falling leaves appear (randomized sizes, speeds, sway). Cleaned up on room exit.
- **Egg taken flash**: Taking the jewel-encrusted egg triggers a golden explosion — double flash overlay, 5 staggered shockwave rings, 32 radiating sparks, screen shake, and brief color inversion. Detection uses MutationObserver tracking of the previous buffer node text (`lastNodeText`), not `.Input` spans (Parchment doesn't use them in WASM mode).
- **Typography**: 20% larger fonts (19px buffer, 17px grid) via `--glkote-buffer-size` / `--glkote-grid-size`.
- **Text effects**: Fade-in animation on new buffer content, subtle text shadows matching the mood accent color.
- **Synchronized transitions**: All color changes (CSS vars, backgrounds, text) use coordinated 1.2s timing.

These effects are applied in two places:
- `play.html` / `v3/play.html` — the game's own player pages (always active)
- `ifhub/play.html` — shared IF Hub player (version-gated: `body.zork1-enhanced` class added only for v3+ via binary path regex)

### Sound System History

**JS Overlay (legacy, v3 original)**
The original v3 sound system was a MutationObserver-based JavaScript overlay (`ambient-audio.js`, `sound-engine.js`, `sound-config.js`) that detected room changes and text patterns in the Parchment DOM. It was engine-agnostic and required no changes to story.ni. This approach has been superseded by native Glk sound.

**Native Glk Sound (current, production)**
Parchment 2025.1.14+ shipped native Glk sound channels via Emglken WASM + AsyncGlk + Web Audio API. The Parchment engine files in v3 are from the `Johnesco/parchment` fork. Sound is now driven directly from story.ni (`play the sound of X`), with audio bundled in `.gblorb` files. The `Sounds/` directory at the project root holds the `.ogg` source files, and `zork1.blurb` is the packaging manifest.

## Web Version Architecture

### Per-Version Contents

**v0** (ZIL):
```
v0/
  index.html            Landing page (links to play, source, walkthrough)
  play.html             Parchment player page (plays ZIL-compiled .z3)
  source.html           ZIL source browser with syntax highlighting and annotations
  walkthrough.html      Walkthrough viewer (fetches local walkthrough files)
  walkthrough.txt       Raw walkthrough commands (ZIL version)
  walkthrough-guide.txt Annotated walkthrough guide (ZIL version)
  zork1.z3.js           Compiled ZIL game (base64 Z-machine, built from original ZIL)
```

**v1/v2** (Inform 7, .ulx):
```
vN/
  index.html            Landing page (links to play, source, walkthrough)
  play.html             Parchment player page
  source.html           Inform 7 source browser (renders this version's story.ni)
  walkthrough.html      Walkthrough viewer (fetches local walkthrough files)
  story.ni              Frozen Inform 7 source snapshot
  walkthrough.txt       Raw walkthrough commands
  walkthrough-guide.txt Annotated walkthrough guide
  zork1.ulx.js          Compiled game (base64 Glulx, built from THIS story.ni)
  lib/                  Client-side libraries
  media/                Assets
```

**v3+** (Inform 7, .gblorb with native sound):
```
vN/
  index.html            Landing page (links to play, source, walkthrough)
  play.html             Parchment player page (Emglken WASM with Glk sound)
  source.html           Inform 7 source browser (renders this version's story.ni)
  walkthrough.html      Walkthrough viewer (fetches local walkthrough files)
  story.ni              Frozen Inform 7 source snapshot (includes sound declarations)
  walkthrough.txt       Raw walkthrough commands
  walkthrough-guide.txt Annotated walkthrough guide
  lib/parchment/        7 engine files + zork1.gblorb.js (game + audio bundle)
  media/                Assets
```

### Source Browsers

- **Per-version** (`vN/source.html`) — Shows the frozen source for that version (fetches local `story.ni`)
- **v0** (`v0/source.html`) — ZIL source browser with annotations

### Standard Player (`play.html`)

`play.html` is the standard Parchment player for the latest compiled version — the same pattern used by all other projects (sample, dracula, feverdream). Created by `compile.py` / `setup_web.py`. This is the **local development entry point**: `python -m http.server 8000 --directory projects/zork1` → open `play.html`.

### Landing Page (`index.html`)

- Dark/parchment aesthetic matching the game player
- "Play Latest Version" link at top pointing to `play.html`
- Engine selector (Quixe/Parchment/Glulxe) with `localStorage` persistence — applies to v1/v2 only; v3+ use unified Parchment (auto-selects best engine)
- Reverse-chronological order: newest version at top, v0 at bottom
- Each version entry shows: Play Online, Download Source, Browse Source buttons (where applicable)
- Version links (`v0/`, `v1/`, etc.) resolve directly from the project root (flat layout)

### Versioning Workflow

**Current** (`story.ni` at the repo root) is the working copy where all new development happens. It is never a numbered version — it is always "current". When a milestone is ready, current gets frozen into the next numbered version.

**Working on current** (routine — all day-to-day development):
1. Edit `story.ni` (repo root)
2. Build and test (see "Building the Game" and "Testing Policy" below)
3. Root `play.html` serves the latest compiled current binary

**Freezing a new version** (milestone — when current is ready to ship):
1. Finish all code changes in current
2. Build and run tests (RegTest + walkthrough)
3. Only after tests pass:
   - Run: `python /c/code/ifhub/tools/snapshot.py zork1 vN`
   - Update `vN/story.ni` banner text to show the version number and subtitle
   - Update `source.html` RAW_URL and sidebar header
   - Update `walkthrough.html` title/header/back link
4. Update `index.html`: add new version entry
5. Add `games.json` + `cards.json` entries for the new version

**Recompiling a frozen version** (rare — fixing old versions):
1. Edit `vN/story.ni` directly
2. Run: `python /c/code/ifhub/tools/snapshot.py zork1 vN --update`
   (`--update` compiles from the version's own `story.ni`, auto-detects `.gblorb` vs `.ulx`)

**Critical rule**: Every `vN/` (v1+) must contain a `story.ni` and a compiled binary (`zork1.ulx.js` for v1/v2, `zork1.gblorb.js` for v3+) built from **that exact source**. Never copy binaries from another version. Always compile from the version's own `story.ni`.

**Cascade rule**: When any `story.ni` is modified (repo root or `vN/`), three artifacts eventually need updating for each affected version:
1. `vN/story.ni` — frozen snapshot synced from source
2. `vN/lib/parchment/zork1.ulx.js` (v1/v2) or `zork1.gblorb.js` (v3+) — recompiled and base64-encoded from that `story.ni`
3. `vN/walkthrough_output.txt` — regenerated transcript from that binary

These do NOT need to happen after every edit. During active development, treat the cascade as a **known outstanding task** — note that artifacts are stale and batch the rebuild once changes stabilize. Do not silently forget it.

### Deployment

GitHub Actions (`.github/workflows/deploy-pages.yml`) assembles `_site/` from site-level files and version directories (`v0/`, `v1/`, etc.), then deploys to GitHub Pages on push to `main`. Locally, run `python /c/code/ifhub/tools/build_site.py zork1` to assemble for preview.

- Landing page: `johnesco.github.io/zork1/`
- Version N: `johnesco.github.io/zork1/vN/`

## Testing

Testing is a **project-wide process**, not a version feature. The same methodology applies to every version.

All testing happens in `tests/` at the repo root. The test wrapper scripts delegate to the shared framework at `C:\code\ifhub\tools\testing\`. See `C:\code\ifhub\CLAUDE.md` for interpreter paths and framework details.

### Interpreters

`tests/project.conf` auto-detects the platform and selects the right interpreter:

- **Git Bash / MSYS**: Uses native `tools/interpreters/glulxe.exe` (no WSL needed). Build with `bash tools/interpreters/build.sh` from MSYS2 UCRT64.
- **WSL / Linux**: Falls back to `~/glulxe/glulxe` and `~/frotz-install/usr/games/dfrotz`.

Tests can be run directly from Git Bash when native interpreters are available:
```bash
python /c/code/ifhub/tools/testing/run_walkthrough.py --config tests/project.conf --seed 26    # walkthrough
python /c/code/ifhub/tools/testing/run_tests.py --config tests/project.conf                   # all regtests
python /c/code/ifhub/tools/testing/run_tests.py --config tests/project.conf --vital startup   # single regtest
```

### Methodology
- **Deterministic walkthroughs**: Seed-based RNG (`glulxe --rngseed N`) ensures reproducible runs. Golden seeds stored in `seeds.conf`.
- **Transcript comparison**: Side-by-side diffing of ZIL (v0, dfrotz) vs. I7 (glulxe) walkthrough output to catch behavioral differences.
- **Automated regression**: `run-walkthrough.py` verifies 350/350 completion. `find-seeds.py` discovers working seeds after code changes.
- **RegTest**: `regtest.py` for targeted scenario testing of specific puzzles and mechanics.

### Walkthrough Files

The walkthrough exists in multiple locations for different purposes:

| File | Purpose |
|------|---------|
| `tests/inform7/walkthrough.txt` | **Runner reads this** — used by `run-walkthrough.py` and `find-seeds.py` |
| `tests/walkthrough.txt` | Root-level copy (kept in sync with above) |
| `tests/zil/walkthrough.txt` | ZIL v0 walkthrough (read-only reference, 439 commands) |
| `v0/walkthrough.txt` | ZIL version for web walkthrough viewer |
| `v1/walkthrough.txt` | Web walkthrough viewer (no sound in v1) |
| `v2/walkthrough.txt` | Web walkthrough viewer (no sound in v2) |
| `v3/walkthrough.txt` | Web walkthrough viewer (v3 has sound) |

**Critical**: `project.conf` line 23 sets `PRIMARY_WALKTHROUGH` to `tests/inform7/walkthrough.txt`. The runner does NOT use `tests/walkthrough.txt`. Always update the `inform7/` copy.

**Sound auto-detect**: v3+ games use `glk_gestalt(gestalt_Sound, 0)` to auto-enable sound when the interpreter supports it — no startup prompt. All walkthrough files are identical across versions (no sound prompt prefix needed).

**ZIL reference as ground truth**: The I7 walkthrough was rebuilt from the proven ZIL v0 route (`tests/zil/walkthrough.txt`) with these I7 syntax adaptations:
- `lamp` instead of `lantern`
- `turn bolt` instead of `turn bolt with wrench` (I7 parser stops at "turn the bolt")
- `turn on switch` instead of `turn switch with screwdriver`
- `push yellow button` instead of `press yellow button`
- `dig sand` instead of `dig sand with shovel`
- Endgame forest route differs (I7 room connections ≠ ZIL)

**Pipeline auto-sync**: The pipeline's test stage (`python /c/code/ifhub/tools/pipeline.py zork1 test`) automatically regenerates `walkthrough-guide.txt` and syncs walkthrough files to the web root. You still need to manually copy to `vN/` directories if updating frozen versions.

**When updating the walkthrough manually** (outside the pipeline): Sync all three file types to all locations, then deploy:
1. Update `tests/inform7/walkthrough.txt` (the runner's source of truth)
2. Copy to `tests/walkthrough.txt` (root-level copy)
3. Copy to all `vN/` directories
4. Run `find-seeds.py` to discover a new golden seed if game code changed
5. Run walkthrough to regenerate `tests/inform7/walkthrough_output.txt`
6. Regenerate the guide: `python3 /c/code/ifhub/tools/testing/generate-guide.py --walkthrough tests/inform7/walkthrough.txt --transcript tests/inform7/walkthrough_output.txt -o tests/inform7/walkthrough-guide.txt`
7. Copy guide to all `vN/` directories
8. Commit and push the zork1 repo (the hub serves walkthrough files in-place from GitHub Pages)

**Three walkthrough file types** (all must stay in sync):
- `walkthrough.txt` — raw commands, one per line
- `walkthrough-guide.txt` — annotated guide with `## Room` headers, `# score` events, `> command` lines (generated by `tools/testing/generate-guide.py`)
- `walkthrough_output.txt` — full game transcript (generated by `run-walkthrough.py`)

**Hub serves in-place**: The hub iframes walkthrough pages directly from `johnesco.github.io/zork1/vN/walkthrough.html`. No deploy script copies files to the hub — push to the zork1 repo and GitHub Pages serves the updated content automatically.

### Policy
Report failures, don't fix unless explicitly instructed. Test all versions when propagating fixes.

## Building the Game

Building happens in this repo. See `C:\code\ifhub\CLAUDE.md` for compiler paths, build steps, and interpreter usage. Do NOT create `.inform/` IDE bundles in this repo.

ZIL (v0) is compiled separately from `C:\code\zork1-zil\` using ZILF.

## Development Workflow

For the base SDLC workflow (commit convention, branch naming, documentation rules), see `C:\code\ifhub\CLAUDE.md`.

### Project-Specific Overrides

**Project Board**: Board #2 (not #3). Add issues with: `gh project item-add 2 --owner Johnesco --url [ISSUE_URL]`

**QA Override**: The baseline rule is "Claude cannot QA its own work." In this project, automated testing (RegTest, walkthrough 350/350, seed sweep) is part of **development** — Claude runs these during In Progress and reports results before moving the issue to Verify. Issues then sit in Verify for human review. Only verify and close when explicitly asked.

**Hat-switch protocol:** Explicitly state which role you're in:
- `"PO hat — let's prioritize the backlog."`
- `"BA mode — help me scope this feature."`
- `"Dev time — implement ticket #12."`
- `"QA check — I'm testing what you built."`

**Labels**: Type (`feature`, `bug`, `task`, `spike`, `docs`) + Area (`area:combat`, `area:objects`, etc.) + Priority (`priority:high`, `priority:low`) + Version (`v1`, `v2`, `v3`) + Resolution (`resolution:wontfix`, `resolution:duplicate`, `resolution:cannot-reproduce`, `resolution:by-design`, `resolution:stale`, `resolution:superseded`)

### Definition of Done

Exit criteria for moving an issue from **In Progress** to **Verify**:

**Feature:**
- [ ] Code complete per acceptance criteria
- [ ] RegTest / walkthrough still passes
- [ ] Follows existing patterns
- [ ] CLAUDE.md updated (if architecture changed)
- [ ] Change propagated to all later versions (if applicable)
- [ ] Commits reference ticket (`#XX`)

**Bug Fix:**
- [ ] Bug fixed — reported behavior no longer occurs
- [ ] Root cause understood
- [ ] RegTest / walkthrough still passes
- [ ] Fix propagated to all later versions
- [ ] Commits reference ticket (`#XX`)

### Bug Severity & Priority

| Severity | Description | Default Priority |
|----------|-------------|------------------|
| **Critical** | Game unwinnable or crashes | `priority:high` — fix immediately |
| **High** | Puzzle or mechanic broken, no workaround | `priority:high` — fix before new features |
| **Medium** | Works but with issues (wrong text, minor logic) | *(no label)* — normal backlog order |
| **Low** | Cosmetic or minor text difference | `priority:low` — fix when convenient |

PO can override: a typo on the landing page may be `priority:high` despite low severity.

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
