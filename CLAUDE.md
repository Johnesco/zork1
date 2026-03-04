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
tests/             Test scripts, walkthroughs, regtest data
src/zil/           Original ZIL source files (read-only, NEVER modify)
src/sharpee/       Sharpee source files
Sounds/            Audio asset files (.ogg) for Blorb packaging
zork1.blurb        Blorb packaging manifest (maps sound IDs to .ogg files)
web/               Web player and site-level pages
  play.html        Standard Parchment player for latest version (local dev entry point)
  lib/parchment/   7 engine files + zork1.gblorb.js (game + audio bundle)
  index.html       Landing page — project description, version links
versions/          Frozen version snapshots
  v0/              Original ZIL — source browser + playable ZIL-compiled game
  v1/, v2/, ...    Inform 7 version archives (self-contained snapshots)
_site/             Assembled deploy directory (gitignored, built by CI)
```

## Inform 7 Shared Tools (External)

Compiler conventions, shared test framework, and reference docs live in the shared hub:

```
C:\code\ifhub\
├── CLAUDE.md              ← Inform 7 conventions and compiler paths
├── tools/
│   ├── regtest.py         ← Shared test runner
│   ├── interpreters/      ← Native Windows glulxe.exe + dfrotz.exe (built locally)
│   └── testing/           ← Generic testing framework (walkthroughs, seed sweeps, pcre_grep.py)
└── reference/             ← Syntax + formatting docs
```

**Compiler**: System-wide install at `C:\Program Files\Inform 7\` (see `C:\code\ifhub\CLAUDE.md` for CLI usage).

Any `story.ni` files found inside `versions/` (e.g., `versions/vN/story.ni`) are **frozen snapshots**. The current version is `story.ni` at the repo root — it is never published to the web directly but snapshotted into a numbered version when ready.

## Version Philosophy

Each version is a **playable milestone** that tells a chapter of the project story. Together they form a portfolio trail showing design choices, testing methodology, and the evolution from faithful port to something new. Versions are displayed on the landing page with the **newest at top, v0 at bottom**.

The original ZIL source in `src/zil/` is **sacred and must never be modified** — all changes carry forward into Inform 7 versions only.

**The most recent version is the default work target.** If no version is specified, work on the latest version.

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

### Past Versions Are Frozen Snapshots

Once a version is published, it is **frozen**. All new work goes into the latest version only. Do not edit past versions unless explicitly asked.

In rare cases a past version may be patched (e.g., a translation bug discovered in v1). If that happens:
1. Edit that version's own `versions/vN/story.ni` directly
2. Compile from that source to produce a new binary (`.ulx` for v1/v2, `.gblorb` for v3+)
3. Base64-encode into `versions/vN/lib/parchment/zork1.ulx.js` (v1/v2) or `zork1.gblorb.js` (v3+)
4. Propagate the same fix upward to all later versions and recompile each

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

### v3 — Making It My Own

Where it intentionally diverges from ZIL-faithful behavior and starts leaning into what Inform 7 does best. v1 and v2 are bound to the original; v3 and beyond are not. The first enhancement is ambient audio — zone-based background music and sound effects that respond to room changes.

Audio is now **native Glk sound** — driven from story.ni via Glk sound channels, with audio files bundled into `.gblorb` packages played through Parchment's Emglken WASM engine. The story.ni includes:
- **Sound declarations**: 9 ambient zone loops + 16 one-shot sound effects (`.ogg` files)
- **Audio zones**: Every room assigned to a zone (forest, house, cave, water, rapids, loud, hades, mine, machinery, silence)
- **Ambient audio rule**: Crossfades zone-based background loops on room change using dual Glk background channels
- **Sound effects**: Triggered inline (`play the sound of X as sfx`) at key game events (grue attacks, match strikes, doors opening, etc.)
- **Sound toggle**: Player prompted at startup; `SOUND ON` / `SOUND OFF` commands available in-game

### Sound System History

**JS Overlay (legacy, v3 original)**
The original v3 sound system was a MutationObserver-based JavaScript overlay (`ambient-audio.js`, `sound-engine.js`, `sound-config.js`) that detected room changes and text patterns in the Parchment DOM. It was engine-agnostic and required no changes to story.ni. This approach has been superseded by native Glk sound.

**Native Glk Sound (current, production)**
Parchment 2025.1.14+ shipped native Glk sound channels via Emglken WASM + AsyncGlk + Web Audio API. The Parchment engine files in v3/v4 are from the `Johnesco/parchment` fork. Sound is now driven directly from story.ni (`play the sound of X`), with audio bundled in `.gblorb` files. The `Sounds/` directory at the project root holds the `.ogg` source files, and `zork1.blurb` is the packaging manifest.

### v4 — Modern IF (Current)

Applying modern interactive fiction writing best practices for fluid, fun gameplay. Focuses on richer parser responses, smoother player interactions, better default messages, and more helpful feedback. Inherits all v3 audio (native Glk sound via .gblorb) and expanded room descriptions for aboveground areas.

**CSS Atmospheric Effects** — v4 and current versions include a mood theming system in `play.html` that transforms the player into an immersive atmospheric experience:

- **Mood palette zones**: Each room is mapped to a color zone (forest, house, cave, water, rapids, loud, hades, mine, machinery, silence). Room changes trigger smooth CSS variable transitions via Houdini `@property` color interpolation (1.2s ease-in-out).
- **Reversed status bar**: The GridWindow (status line) uses buffer text color as background with bold black text — inverted from the normal scheme. Uses `!important` to override GlkOte inline styles.
- **CRT intro**: Green terminal aesthetic on startup (`#00ff41` text, scanline overlay, flickering scanbar) that fades out after the first user input.
- **Up a Tree effects**: When in "Up a Tree", a forest canopy glow overlay and 24 animated falling leaves appear (randomized sizes, speeds, sway). Cleaned up on room exit.
- **Egg taken flash**: Taking the jewel-encrusted egg triggers a golden explosion — double flash overlay, 5 staggered shockwave rings, 32 radiating sparks, screen shake, and brief color inversion. Detection uses MutationObserver tracking of the previous buffer node text (`lastNodeText`), not `.Input` spans (Parchment doesn't use them in WASM mode).
- **Typography**: 20% larger fonts (19px buffer, 17px grid) via `--glkote-buffer-size` / `--glkote-grid-size`.
- **Text effects**: Fade-in animation on new buffer content, subtle text shadows matching the mood accent color.
- **Synchronized transitions**: All color changes (CSS vars, backgrounds, text) use coordinated 1.2s timing.

These effects are applied in three places:
- `web/play.html` — local development player (always active)
- `ifhub/games/zork1-v4/play.html` — per-game IF Hub page (always active)
- `ifhub/play.html` — shared IF Hub player (version-gated: `body.zork1-enhanced` class added only for v4+ via binary path regex)

## Web Version Architecture

### Per-Version Contents

**v0** (ZIL):
```
versions/v0/
  index.html            ZIL source browser with syntax highlighting and annotations
  parchment.html        Parchment player page (plays ZIL-compiled .z3)
  zork1.z3.js           Compiled ZIL game (base64 Z-machine, built from original ZIL)
  walkthrough.html      Walkthrough viewer (fetches local walkthrough files)
  walkthrough.txt       Raw walkthrough commands (ZIL version)
  walkthrough-guide.txt Annotated walkthrough guide (ZIL version)
```

**v1/v2** (Inform 7, .ulx):
```
versions/vN/
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

**v3+** (Inform 7, .gblorb with native sound):
```
versions/vN/
  index.html            Unified Parchment player (all engines, same as parchment.html)
  parchment.html        Unified Parchment player (Emglken WASM with Glk sound)
  source.html           Inform 7 source browser (renders this version's story.ni)
  story.ni              Frozen Inform 7 source snapshot (includes sound declarations)
  walkthrough.html      Walkthrough viewer (fetches local walkthrough files)
  walkthrough.txt       Raw walkthrough commands
  walkthrough-guide.txt Annotated walkthrough guide
  lib/parchment/        7 engine files + zork1.gblorb.js (game + audio bundle)
  media/                Assets
```

### Source Browsers

- **Per-version** (`versions/vN/source.html`) — Shows the frozen source for that version (fetches local `story.ni`)
- **v0** (`versions/v0/index.html`) — ZIL source browser with annotations (already exists)

### Standard Player (`web/play.html`)

`web/play.html` is the standard Parchment player for the latest compiled version — the same pattern used by all other projects (sample, dracula, feverdream). Created by `compile.sh` / `setup-web.sh`. This is the **local development entry point**: `python -m http.server 8000 --directory projects/zork1/web` → open `play.html`.

### Landing Page (`web/index.html`)

- Dark/parchment aesthetic matching the game player
- "Play Latest Version" link at top pointing to `play.html`
- Engine selector (Quixe/Parchment/Glulxe) with `localStorage` persistence — applies to v1/v2 only; v3+ use unified Parchment (auto-selects best engine)
- Reverse-chronological order: newest version at top, v0 at bottom
- Each version entry shows: Play Online, Download Source, Browse Source buttons (where applicable)
- Version links (`v0/`, `v1/`, etc.) resolve only in `_site/` after `build-site.sh` assembles versions — they won't work from `web/` alone

### Versioning Workflow

The **current version** (`story.ni` at the repo root) is the working copy where all new development happens. It is snapshotted into numbered versions when ready. The **latest numbered version** (currently v4) may be updated many times — it is republished from the current version as development progresses.

**Updating the latest version** (routine — happens frequently):
1. Make changes in `story.ni` (repo root)
2. Build and test (see "Building the Game" and "Testing Policy" below)
3. Run: `bash /c/code/ifhub/tools/snapshot.sh zork1 vN --update`
   (Or manually: copy `story.ni` → `versions/vN/story.ni`, compile and base64-encode → `versions/vN/lib/parchment/zork1.ulx.js` (v1/v2) or `zork1.gblorb.js` (v3+))

**Creating a new version** (vN+1):
1. Finish all code changes in the current version
2. Build and run tests (RegTest + walkthrough)
3. Only after tests pass:
   - Run: `bash /c/code/ifhub/tools/snapshot.sh zork1 vN+1`
   - Update `source.html` RAW_URL and sidebar header
   - Update `walkthrough.html` title/header/back link
4. Update `web/index.html`: add new version entry

**Critical rule**: Every `versions/vN/` (v1+) must contain a `story.ni` and a compiled binary (`zork1.ulx.js` for v1/v2, `zork1.gblorb.js` for v3+) built from **that exact source**. Never copy binaries from another version. Always compile from the version's own `story.ni`.

**Cascade rule**: When any `story.ni` is modified (repo root or `versions/vN/`), three artifacts eventually need updating for each affected version:
1. `versions/vN/story.ni` — frozen snapshot synced from source
2. `versions/vN/lib/parchment/zork1.ulx.js` (v1/v2) or `zork1.gblorb.js` (v3+) — recompiled and base64-encoded from that `story.ni`
3. `versions/vN/walkthrough_output.txt` — regenerated transcript from that binary

These do NOT need to happen after every edit. During active development, treat the cascade as a **known outstanding task** — note that artifacts are stale and batch the rebuild once changes stabilize. Do not silently forget it.

### Deployment

GitHub Actions (`.github/workflows/deploy-pages.yml`) assembles `_site/` from `web/` (site-level pages) + `versions/` (frozen snapshots), then deploys to GitHub Pages on push to `main`. Locally, run `bash /c/code/ifhub/tools/build-site.sh zork1` to assemble for preview.

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
bash tests/run-walkthrough.sh --seed 2         # walkthrough
bash tests/run-tests.sh                         # all regtests
bash tests/run-tests.sh --vital startup         # single regtest
```

### Methodology
- **Deterministic walkthroughs**: Seed-based RNG (`glulxe --rngseed N`) ensures reproducible runs. Golden seeds stored in `seeds.conf`.
- **Transcript comparison**: Side-by-side diffing of ZIL (v0, dfrotz) vs. I7 (glulxe) walkthrough output to catch behavioral differences.
- **Automated regression**: `run-walkthrough.sh` verifies 350/350 completion. `find-seeds.sh` discovers working seeds after code changes.
- **RegTest**: `regtest.py` for targeted scenario testing of specific puzzles and mechanics.

### Policy
Report failures, don't fix unless explicitly instructed. Test all versions when propagating fixes.

## Building the Game

Building happens in this repo. See `C:\code\ifhub\CLAUDE.md` for compiler paths, build steps, and interpreter usage. Do NOT create `.inform/` IDE bundles in this repo.

ZIL (v0) is compiled separately from `C:\code\zork1-zil\` using ZILF.

<!-- ============================================================
     SDLC WORKFLOW
     Adapted from https://github.com/Johnesco/sdlc-baseline
     ============================================================ -->

## Development Workflow

### Roles and Responsibilities

| Role | Owner | Board Columns | Key Rule |
|------|-------|---------------|----------|
| **PO** (Product Owner) | Human | Backlog, Done | Decides priority, accepts work |
| **BA** (Business Analyst) | Human or Claude | Backlog, Ready | Scopes tickets, writes acceptance criteria |
| **Dev** (Developer) | Claude (primary) | In Progress | Writes code, follows conventions |
| **Documenter** | Claude (bundled with Dev) | In Progress | Updates CLAUDE.md, README |
| **QA** (Quality Assurance) | Human or Claude | **Verify** | Verifies completed work |

> **Project-specific override:** The baseline rule is "Claude cannot QA its own work." In this project, automated testing (RegTest, walkthrough 350/350, seed sweep) is part of **development** — Claude runs these during In Progress and reports results before moving the issue to Verify. Issues then sit in Verify for human review. Occasionally the human may ask Claude to verify and close a specific issue — only do so when explicitly asked.

**Hat-switch protocol:** Explicitly state which role you're in:
- `"PO hat — let's prioritize the backlog."`
- `"BA mode — help me scope this feature."`
- `"Dev time — implement ticket #12."`
- `"QA check — I'm testing what you built."`

### Ticket-First Workflow (MANDATORY)

Every change — feature, bug fix, refactor, or data update — follows this sequence. No step may be skipped.

1. **Capture as a ticket** — Create a GitHub Issue before any other work begins. Include title, labels, and acceptance criteria.

   > **IMPORTANT — Add to Project Board:** `gh issue create` does NOT auto-add issues to the project board. Run this immediately after:
   > ```
   > gh project item-add 2 --owner Johnesco --url [ISSUE_URL]
   > ```

2. **Review documentation** — Read CLAUDE.md sections and source files related to the change. Identify what exists and what will be impacted.

3. **Flag discrepancies** — If code differs from documentation, stop and flag the mismatch before proceeding.

4. **Refine the ticket** — Update the issue with context from the doc review, affected areas, and documentation update plan.

5. **Implement the change** — Write the code. Reference the ticket number in commits.

6. **Update documentation** — Update CLAUDE.md, README.md, and any other affected docs. A change without a doc update is incomplete.

7. **Verify consistency** — Confirm documentation and code agree. Call out any remaining gaps.

**Compressing steps:** Data-only fixes or obvious bug fixes can compress steps 2–4 into a quick scan. New features, multi-file changes, and behavior changes always get the full workflow.

### GitHub Issues & Projects

All work is tracked in **GitHub Issues** with a **GitHub Projects** kanban board (Project #2).

- **Labels** = Type (`feature`, `bug`, `task`, `spike`, `docs`) + Area (`area:combat`, `area:objects`, etc.) + Priority (`priority:high`, `priority:low`) + Version (`v1`, `v2`, `v4`) + Resolution (`resolution:wontfix`, `resolution:duplicate`, `resolution:cannot-reproduce`, `resolution:by-design`, `resolution:stale`, `resolution:superseded`)
- **Board columns**: Backlog → Ready → In Progress → Verify → Done
- **Board automations**: Item added → Backlog; Item closed → Done; Item reopened → In Progress; PR merged → Done

### Commit Convention

```
#XX: description
```

Where `XX` is the GitHub Issue number. Use `Fixes #XX` in PR body for auto-close.

### Branch Naming

```
[type]/[short-description]
```

| Prefix | Use for |
|--------|---------|
| `feature/` | New features |
| `fix/` | Bug fixes |
| `docs/` | Documentation changes |
| `task/` | Refactors, tooling, infrastructure |
| `spike/` | Research, investigation |

Solo work can commit to `main` directly. Branch when changes need review or span multiple sessions.

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

**Documentation:**
- [ ] Content accurate and matches current code
- [ ] Consistent across CLAUDE.md, README, web/index.html
- [ ] No broken links or references
- [ ] Commits reference ticket (`#XX`)

**Task:**
- [ ] Change implemented, no regressions
- [ ] No unintended behavior changes
- [ ] Documentation updated (if applicable)
- [ ] Commits reference ticket (`#XX`)

**Spike:**
- [ ] Question answered (or marked unanswerable)
- [ ] Findings documented in issue comments
- [ ] Recommendation provided with tradeoffs
- [ ] Follow-up tickets created (if any)

### Bug Severity & Priority

| Severity | Description | Default Priority |
|----------|-------------|------------------|
| **Critical** | Game unwinnable or crashes | `priority:high` — fix immediately |
| **High** | Puzzle or mechanic broken, no workaround | `priority:high` — fix before new features |
| **Medium** | Works but with issues (wrong text, minor logic) | *(no label)* — normal backlog order |
| **Low** | Cosmetic or minor text difference | `priority:low` — fix when convenient |

PO can override: a typo on the landing page may be `priority:high` despite low severity.

### Resolution Labels

When closing an issue without completing the work, apply a resolution label:

| Label | When to use |
|-------|-------------|
| `resolution:wontfix` | Deliberately declined |
| `resolution:duplicate` | Already covered elsewhere |
| `resolution:cannot-reproduce` | Bug can't be replicated |
| `resolution:by-design` | Reported behavior is intentional |
| `resolution:stale` | Issue went inactive |
| `resolution:superseded` | Replaced by a different ticket |

No resolution label = completed normally.

<!-- ============================================================
     END SDLC WORKFLOW
     ============================================================ -->

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
