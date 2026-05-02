# Zork I — Current

ZIL-to-Inform 7 translation of *Zork I: The Great Underground Empire*. The Inform 7 source is the living document; the ZIL files in `src/zil/` are read-only reference.

This repo is **Current** — the active working copy. Frozen versions live in their own repos:

| Version | Repo | Engine | Notes |
|---|---|---|---|
| Current | `Johnesco/zork1` (this repo) | Inform 7 | Default work target |
| v3 | `Johnesco/zork1-v3` | Inform 7 (.gblorb) | Multimedia: native sound + CSS atmospherics |
| v2 | `Johnesco/zork1-v2` | Inform 7 | Bug fixes & testing methodology |
| v1 | `Johnesco/zork1-v1` | Inform 7 | Faithful 1:1 port of v0 |
| v0 | `Johnesco/zork1-v0` | ZIL (Z-machine) | Untouchable original |

For the multi-version model, change-propagation rules, and per-version repo conventions, see `C:\code\ifhub\reference\multi-version-guide.md`.

For build, test, and publish workflows, see `C:\code\ifhub\reference\project-guide.md`.

For Inform 7 syntax, text formatting, and the verb help system, see the references in `C:\code\ifhub\reference\`.

## GitHub Repository

- **Working repository**: `Johnesco/zork1` — ALL issues, PRs, and code changes for Current go here
- **Per-version repos**: see table above (one per frozen version)
- **Upstream (read-only reference)**: `historicalsource/zork1` — DO NOT create issues or PRs here
- When using `gh` CLI, always use `--repo Johnesco/zork1` (or the appropriate version repo)

## Repo Layout

```
story.ni            Current Inform 7 source — EDIT HERE
zork1.ulx           Compiled output (gitignored — rebuild from story.ni)
zork1.gblorb        Sound-bundled binary (gitignored — rebuild via pipeline)
ifhub.conf          Engine + metadata for IF Hub
index.html          Group landing page (auto-generated from landing.json)
landing.json        Prose for the group landing page (Current + version cards)
play.html           Parchment player for Current
source.html         Source browser for Current
walkthrough.html    Walkthrough viewer for Current
lib/parchment/      Parchment engine + base64-encoded zork1.gblorb.js
tests/              Walkthroughs, regtests, scenarios, golden seeds
src/zil/            Original ZIL source (read-only reference)
src/sharpee/        Sharpee source files (separate port)
Sounds/             .ogg audio assets for Blorb packaging
zork1.blurb         Blorb manifest (sound IDs → .ogg files)
scenarios/          Scenario guides and transcripts
tools/              Project-specific test tooling (e.g. multi_play.py)
```

## Version Philosophy (project-specific)

For the general model see the multi-version guide. The promotion rules **for this project** are:

- **v0** — Original ZIL, exactly as released. Never modified.
- **v1** — Faithful 1:1 translation. Every room, puzzle, text response from v0 must make it here. No fixes, no enhancements. Some original ZIL bugs vanish naturally in translation; that's fine, don't force them back.
- **v2** — First version that *changes the game*. Fixes ZIL bugs (things Infocom shipped broken) and translation bugs from v1. Behavior aims to match what ZIL *meant* to do. The testing methodology was also established here.
- **v3** — Multimedia. Adds native Glk sound (zone-based ambient + 16 SFX) and CSS atmospheric effects (mood palettes, CRT intro, Up-a-Tree leaves, egg-flash). Diverges from ZIL-faithful behavior; leans into what Inform 7 does best, but keeps any added text sparse to match the original style.
- **Current (v4 work-in-progress)** — Modern IF improvements. Richer descriptions, parser forgiveness, quality-of-life polish. Will eventually freeze as v4.

## v3 Multimedia Details (for reference when working on Current or v3)

**Native Glk Sound** (Parchment 2025.1+ via Emglken WASM):
- 9 ambient zone loops (forest, house, cave, water, rapids, loud, hades, mine, machinery, silence) crossfaded on room change
- 16 one-shot SFX triggered inline via `play the sound of X as sfx`
- Auto-detect via `glk_gestalt(gestalt_Sound, 0)` — no startup prompt
- `SOUND ON` / `SOUND OFF` commands available in-game
- Audio bundled into `.gblorb` via `cBlorb` (manifest: `zork1.blurb`)

**CSS Atmospheric Effects** (in `play.html`):
- Mood palette zones — room changes trigger smooth CSS variable transitions (Houdini `@property` interpolation, 1.2s ease-in-out)
- Reversed status bar (buffer text color as background, bold black text)
- CRT intro — green terminal aesthetic with scanlines, fades after first input
- Up-a-Tree — forest canopy glow + 24 animated falling leaves
- Egg-flash — golden explosion (flash overlay, shockwave rings, sparks, screen shake) when the jewel-encrusted egg is taken (detection via MutationObserver tracking `lastNodeText`)
- Typography: 19px buffer / 17px grid, fade-in on new content, mood-colored text shadows
- Synchronized 1.2s timing across all transitions

These are applied in two places: this game's own `play.html` (always active for Current/v3), and the shared IF Hub player at `ifhub/play.html` (gated on `body.zork1-enhanced` which is added only for v3+ via binary path regex).

## Testing

All testing happens in `tests/`. Wrappers delegate to the shared framework at `C:\code\ifhub\tools\testing\`.

```bash
# Walkthrough (350/350 with golden seed)
python /c/code/ifhub/tools/testing/run_walkthrough.py --config tests/project.conf --seed 26

# All regtests
python /c/code/ifhub/tools/testing/run_tests.py --config tests/project.conf

# Single regtest
python /c/code/ifhub/tools/testing/run_tests.py --config tests/project.conf --vital startup
```

**Golden seed**: 26 (Current). Each frozen version has its own golden seed in its repo's `tests/seeds.conf`.

**Methodology**:
- Deterministic walkthroughs via `glulxe --rngseed N`
- ZIL transcript comparison (v0 vs Current via `dfrotz` and `glulxe`)
- RegTest for targeted scenario testing
- `find-seeds.py` to discover working seeds after code changes

**Walkthrough files** (must stay in sync):
- `tests/inform7/walkthrough.txt` — runner reads this (set in `tests/project.conf`)
- `tests/walkthrough.txt` — root-level copy
- `walkthrough.txt` (web root) — for the walkthrough viewer iframe
- `walkthrough-guide.txt` (web root) — annotated guide (generated by `tools/testing/generate-guide.py`)
- `walkthrough_output.txt` (web root) — full transcript (generated by `run-walkthrough.py`)

The pipeline's test stage auto-regenerates the guide and syncs files to the web root. When patching a frozen version, sync that version's repo too.

**Multi-version side-by-side**: `tools/multi_play.py` runs commands against v0/v1/v2/v3/Current in parallel and prints per-command diffs. Useful for ZIL-fidelity checks.

```bash
python tools/multi_play.py tests/scratch/<commands.txt>
```

## Development Workflow

For the base SDLC workflow (commit conventions, branch naming, documentation rules), see `C:\code\ifhub\CLAUDE.md`.

### Project-Specific Overrides

**Project Board**: Board #2 (not #3). Add issues with `gh project item-add 2 --owner Johnesco --url [ISSUE_URL]`.

**QA Override**: The baseline rule is "Claude cannot QA its own work." In this project, automated testing (RegTest, walkthrough 350/350, seed sweep) is part of *development* — Claude runs these during In Progress and reports results before moving the issue to Verify. Issues then sit in Verify for human review. Only verify and close when explicitly asked.

**Hat-switch protocol** — explicitly state which role you're in:
- `"PO hat — let's prioritize the backlog."`
- `"BA mode — help me scope this feature."`
- `"Dev time — implement ticket #12."`
- `"QA check — I'm testing what you built."`

**Labels**: Type (`feature`, `bug`, `task`, `spike`, `docs`) + Area (`area:combat`, `area:objects`, etc.) + Priority (`priority:high`, `priority:low`) + Version (`v1`, `v2`, `v3`) + Resolution (`resolution:wontfix`, `resolution:duplicate`, `resolution:cannot-reproduce`, `resolution:by-design`, `resolution:stale`, `resolution:superseded`).

### Definition of Done

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
- **Lamp**: 200-turn timer with warnings at 100, 130, 185, 200 turns elapsed
- **Candles**: 75-turn timer (stages at 40/60/70/75), wind-sensitive in Tiny Cave (gust extinguishes if candles in same room as player)
- **Matches**: 6 total, 2-turn burn, drafty rooms extinguish instantly
- **River**: Auto-downstream with per-room turn limits, falls = death
- **Exorcism**: bell (hot) → candles (drop) → book (banish), multi-phase timer
- **Dam**: Yellow button powers, bolt+wrench opens gates, 8-turn reservoir
- **Cyclops**: Feed lunch → give water → sleep, OR say "odysseus"
- **Coal→Diamond**: Machine transformation puzzle
- **Boat**: Inflate with pump, sharp objects puncture on boarding
