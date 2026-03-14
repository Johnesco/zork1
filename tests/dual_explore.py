#!/usr/bin/env python3
"""
Dual-Version Zork I Explorer
=============================
Simulates two players exploring Zork I v0 (ZIL) and v1 (Inform 7) in sync,
cataloging text differences between versions.

Usage:
    python tests/dual_explore.py [--seed-zil N] [--seed-i7 N] [--route ROUTE]
"""

import subprocess
import re
import sys
import os
import argparse
import textwrap
from difflib import unified_diff, SequenceMatcher
from pathlib import Path

# Force UTF-8 output on Windows
if sys.platform == "win32":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

# Paths (Windows-native format for pathlib compatibility)
IFHUB = Path("C:/code/ifhub")
PROJECT = IFHUB / "projects" / "zork1"
DFROTZ = IFHUB / "tools" / "interpreters" / "dfrotz.exe"
GLULXE = IFHUB / "tools" / "interpreters" / "glulxe.exe"
ZIL_GAME = Path("C:/code/zork1-zil/zork1.z3")
I7_GAME = PROJECT / "v1" / "zork1.ulx"

# ANSI colors
class C:
    RESET   = "\033[0m"
    BOLD    = "\033[1m"
    DIM     = "\033[2m"
    RED     = "\033[31m"
    GREEN   = "\033[32m"
    YELLOW  = "\033[33m"
    BLUE    = "\033[34m"
    MAGENTA = "\033[35m"
    CYAN    = "\033[36m"
    WHITE   = "\033[37m"
    BG_RED  = "\033[41m"
    BG_GREEN= "\033[42m"

# Command translation: what differs between ZIL and I7 parsers
COMMAND_TRANSLATIONS = {
    # ZIL command -> I7 command (applied when generating I7 input)
    "take lantern": "take lamp",
    "turn on lantern": "turn on lamp",
    "turn off lantern": "turn off lamp",
    "drop lantern": "drop lamp",
    "examine lantern": "examine lamp",
    "take all": "take all",
    "press yellow button": "push yellow button",
    "turn bolt with wrench": "turn bolt",
    "turn switch with screwdriver": "turn on switch",
    "dig sand with shovel": "dig sand",
}

def translate_zil_to_i7(cmd):
    """Translate a ZIL command to its I7 equivalent."""
    lower = cmd.strip().lower()
    if lower in COMMAND_TRANSLATIONS:
        return COMMAND_TRANSLATIONS[lower]
    # Generic lantern -> lamp substitution
    if "lantern" in lower:
        return cmd.replace("lantern", "lamp").replace("Lantern", "Lamp")
    return cmd


# ── Exploration Routes ──────────────────────────────────────────────────────

def route_house_and_early_dungeon():
    """Phase 1: House exterior, interior, and early underground. ~60 commands."""
    return [
        # --- Opening: Explore the house exterior ---
        ("EXPLORE", "Arriving at West of House"),
        "look",
        "examine house",
        "open door",           # should fail - boarded
        "n",
        "look",
        "examine window",      # North of House - boarded windows
        "n",                   # Behind House
        "look",
        "examine window",      # kitchen window
        "open window",
        "examine house",

        # --- Enter the house ---
        ("EXPLORE", "Entering the house through kitchen window"),
        "w",                   # into Kitchen
        "look",
        "examine table",
        "take sack",
        "open sack",
        "take garlic",
        "examine bottle",
        "take bottle",

        # --- Living Room ---
        ("EXPLORE", "Living Room - key hub"),
        "w",                   # Living Room
        "look",
        "examine rug",
        "examine case",
        "take sword",
        "take lantern",
        "examine sword",
        "examine lantern",
        "turn on lantern",

        # --- Attic ---
        ("EXPLORE", "Going upstairs to the Attic"),
        "e",                   # back to Kitchen
        "u",                   # Attic
        "look",
        "take rope",
        "take knife",
        "examine knife",
        "d",                   # back to Kitchen

        # --- Get the egg ---
        ("EXPLORE", "Forest and the jewel-encrusted egg"),
        "e",                   # Behind House
        "s",                   # South of House
        "s",                   # Forest
        "w",                   # Forest (another)
        "n",                   # Forest Path
        "u",                   # Up a Tree
        "look",
        "take egg",
        "examine egg",
        "d",                   # back to path

        # --- Stash treasure, enter dungeon ---
        ("EXPLORE", "Stashing egg, entering the underground"),
        "s",                   # back to forest
        "e",                   # South of House
        "n",                   # Behind House
        "w",                   # Kitchen
        "w",                   # Living Room
        "open case",
        "put egg in case",
        "move rug",
        "open trap door",
        "d",                   # Cellar
        "look",

        # --- Troll Room ---
        ("EXPLORE", "The Troll Room"),
        "n",                   # Troll Room
        "look",
        "examine troll",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",

        # --- Gallery ---
        ("EXPLORE", "East of Chasm and Gallery"),
        "e",                   # E-W Passage
        "e",                   # Round Room
        "look",
        "se",                  # narrow -> E of Chasm
        "look",
        "e",                   # Gallery
        "look",
        "take painting",
        "examine painting",
        "n",                   # Studio
        "look",
    ]


def route_dam_and_flood():
    """Phase 2: Dam area - button/bolt puzzle, reservoir. ~40 commands."""
    return [
        ("EXPLORE", "Dam and flood control"),
        # Assumes we're somewhere accessible... start fresh
        "look",
        "inventory",
        # Navigate to dam area from a plausible starting point
        # This route starts from Troll Room heading west
        "w",                   # Maze or passage
        "look",
        "n",
        "look",
        "e",
        "look",
        "examine dam",
        "n",                   # Dam Lobby
        "look",
        "examine guidebook",   # ZIL: "guide"
        "take match",          # matchbook
        "examine match",
        "s",                   # back to Dam
        "examine bolt",
        "examine panel",
        "press yellow button",
        "turn bolt with wrench",
        "look",
        "s",                   # Dam Base
        "look",
        "examine pile",        # pile of plastic
        "take pile",
        "s",                   # Beach
        "look",
        "examine sand",
        "examine shovel",
        "take shovel",
    ]


def route_look_and_examine():
    """Short exploratory route focused on examining objects and scenery."""
    return [
        ("EXPLORE", "Starting: detailed examination of opening area"),
        "look",
        "examine me",
        "examine sky",
        "examine ground",
        "examine forest",
        "listen",
        "smell",
        "jump",
        "sing",
        "pray",
        "yell",
        "diagnose",
        "score",
        "inventory",
        "verbose",
        "n",
        "look",
        "n",
        "look",
        "examine window",
        "open window",
        "w",
        "look",
        "examine table",
        "examine sack",
        "open sack",
        "examine garlic",
        "taste garlic",
        "w",
        "look",
        "examine rug",
        "look under rug",
        "take sword",
        "examine sword",
        "read sword",
        "take lantern",
        "examine lantern",
        "shake lantern",
        "turn on lantern",
        "examine case",
        "look in case",
        "examine door",
        "examine chimney",
    ]


def route_full_exploration():
    """Comprehensive route covering house, forest, early dungeon, dam."""
    cmds = []
    cmds.extend(route_look_and_examine())
    cmds.append(("EXPLORE", "=== Phase 2: Forest and egg ==="))
    cmds.extend([
        "e",       # Kitchen
        "e",       # Behind House
        "s",       # South of House
        "look",
        "s",       # Forest
        "look",
        "w",       # Forest
        "look",
        "n",       # Forest Path
        "look",
        "u",       # Up a Tree
        "look",
        "take egg",
        "examine egg",
        "d",
        "s",
        "e",
        "n",       # Behind House
        "w",       # Kitchen
        "w",       # Living Room
        "put egg in case",
    ])
    cmds.append(("EXPLORE", "=== Phase 3: Underground ==="))
    cmds.extend([
        "move rug",
        "open trap door",
        "d",       # Cellar
        "look",
        "examine door",
        "n",       # Troll Room
        "look",
        "examine troll",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "kill troll with sword",
        "e",       # E-W Passage
        "look",
        "e",       # Round Room
        "look",
        "se",      # Engravings Cave
        "look",
        "e",       # Dome Room
        "look",
    ])
    return cmds


ROUTES = {
    "house": route_house_and_early_dungeon,
    "dam": route_dam_and_flood,
    "examine": route_look_and_examine,
    "full": route_full_exploration,
}


# ── Interpreter Runners ─────────────────────────────────────────────────────

def run_interpreter(exe, game, commands, seed=None, is_zil=False):
    """Run an interpreter with piped commands, return raw output."""
    cmd_list = [str(exe)]

    if is_zil:
        # dfrotz flags
        if seed is not None:
            cmd_list.extend(["-s", str(seed)])
        cmd_list.extend(["-p", "-w", "999", str(game)])
    else:
        # glulxe flags
        if seed is not None:
            cmd_list.extend(["--rngseed", str(seed)])
        cmd_list.append(str(game))

    input_text = "\n".join(commands) + "\n"

    try:
        result = subprocess.run(
            cmd_list,
            input=input_text,
            capture_output=True,
            text=True,
            timeout=30,
            cwd=str(PROJECT),
        )
        return result.stdout
    except subprocess.TimeoutExpired:
        return "[TIMEOUT - interpreter did not finish in 30 seconds]"
    except Exception as e:
        return f"[ERROR: {e}]"


# ── Output Parsing ──────────────────────────────────────────────────────────

def parse_turns(raw_output, commands):
    """
    Parse interpreter output into a list of (command, response_text) tuples.
    Each turn = the text that appeared after typing a command.
    """
    lines = raw_output.replace("\r\n", "\n").replace("\r", "\n").split("\n")

    turns = []
    current_response = []
    cmd_idx = 0
    banner_done = False
    banner_lines = []

    # The banner is everything before the first > prompt
    for i, line in enumerate(lines):
        if ">" in line and not banner_done:
            banner_done = True
            banner_lines = lines[:i]
            # Start processing from here
            remaining = lines[i:]
            break
    else:
        # No prompt found; return the whole thing as banner
        return [("BANNER", raw_output)], raw_output

    turns.append(("BANNER", "\n".join(banner_lines).strip()))

    # Now parse turn-by-turn
    # Strategy: split on ">" prompt lines
    current_cmd = None
    current_response = []

    for line in remaining:
        # Detect prompt line (contains >)
        stripped = line.strip()
        if stripped.startswith(">") or ("> " in stripped and len(stripped) < 80):
            # This is a prompt line - save previous turn
            if current_cmd is not None:
                resp_text = "\n".join(current_response).strip()
                turns.append((current_cmd, resp_text))

            # Extract command from this prompt line
            # e.g., ">take lamp" or "> take lamp"
            prompt_text = stripped.lstrip(">").strip()
            if cmd_idx < len(commands):
                current_cmd = commands[cmd_idx]
                cmd_idx += 1
            else:
                current_cmd = prompt_text or "???"
            current_response = []

            # Any text after the command on the same line
            if prompt_text and prompt_text != current_cmd:
                pass  # Usually the echo of the command
        else:
            current_response.append(line)

    # Don't forget the last turn
    if current_cmd is not None:
        resp_text = "\n".join(current_response).strip()
        turns.append((current_cmd, resp_text))

    return turns, raw_output


def clean_response(text):
    """Normalize text for comparison: strip whitespace, collapse blanks."""
    # Remove trailing whitespace per line
    lines = [l.rstrip() for l in text.split("\n")]
    # Collapse multiple blank lines into one
    result = []
    prev_blank = False
    for l in lines:
        if l == "":
            if not prev_blank:
                result.append("")
            prev_blank = True
        else:
            result.append(l)
            prev_blank = False
    return "\n".join(result).strip()


# ── Diff Engine ─────────────────────────────────────────────────────────────

def classify_diff(zil_text, i7_text):
    """Classify the type of text difference."""
    zl = zil_text.lower()
    il = i7_text.lower()

    # Identical
    if clean_response(zil_text) == clean_response(i7_text):
        return "IDENTICAL"

    # Just whitespace / formatting
    if clean_response(zil_text).replace(" ", "") == clean_response(i7_text).replace(" ", ""):
        return "WHITESPACE"

    # Lantern/lamp swap only
    if clean_response(zil_text).lower().replace("lantern", "lamp") == clean_response(i7_text).lower():
        return "SYNONYM"

    # Banner/version info
    if "release" in zl and "serial" in zl:
        return "BANNER"

    # Score differences
    if "score" in zl or "points" in zl:
        return "SCORING"

    # RNG-dependent (combat, thief)
    if any(w in zl for w in ["troll", "thief", "blow", "miss", "parry", "slash"]):
        return "COMBAT_RNG"

    # Different text for same game action
    return "TEXT_DIFF"


def word_diff(a, b):
    """Produce an inline word-level diff."""
    a_words = a.split()
    b_words = b.split()
    sm = SequenceMatcher(None, a_words, b_words)
    result_a = []
    result_b = []

    for op, a1, a2, b1, b2 in sm.get_opcodes():
        if op == "equal":
            result_a.extend(a_words[a1:a2])
            result_b.extend(b_words[b1:b2])
        elif op == "replace":
            result_a.append(f"{C.RED}{C.BOLD}" + " ".join(a_words[a1:a2]) + f"{C.RESET}")
            result_b.append(f"{C.GREEN}{C.BOLD}" + " ".join(b_words[b1:b2]) + f"{C.RESET}")
        elif op == "delete":
            result_a.append(f"{C.RED}" + " ".join(a_words[a1:a2]) + f"{C.RESET}")
        elif op == "insert":
            result_b.append(f"{C.GREEN}" + " ".join(b_words[b1:b2]) + f"{C.RESET}")

    return " ".join(result_a), " ".join(result_b)


# ── Report Generator ────────────────────────────────────────────────────────

def print_header(text, char="═"):
    width = 90
    print(f"\n{C.CYAN}{C.BOLD}{char * width}{C.RESET}")
    print(f"{C.CYAN}{C.BOLD}  {text}{C.RESET}")
    print(f"{C.CYAN}{C.BOLD}{char * width}{C.RESET}\n")


def print_section(text, char="─"):
    width = 70
    print(f"\n{C.YELLOW}{char * width}{C.RESET}")
    print(f"{C.YELLOW}  {text}{C.RESET}")
    print(f"{C.YELLOW}{char * width}{C.RESET}")


def print_turn_comparison(turn_num, cmd_zil, cmd_i7, zil_resp, i7_resp, diff_type):
    """Print a single turn comparison."""
    # Command line
    if cmd_zil == cmd_i7:
        print(f"  {C.BOLD}Turn {turn_num}: >{C.CYAN} {cmd_zil}{C.RESET}")
    else:
        print(f"  {C.BOLD}Turn {turn_num}:{C.RESET}")
        print(f"    {C.RED}ZIL: > {cmd_zil}{C.RESET}")
        print(f"    {C.GREEN}I7:  > {cmd_i7}{C.RESET}")

    # Classification badge
    badges = {
        "IDENTICAL":   f"{C.DIM}[identical]{C.RESET}",
        "WHITESPACE":  f"{C.DIM}[whitespace only]{C.RESET}",
        "SYNONYM":     f"{C.BLUE}[synonym: lantern→lamp]{C.RESET}",
        "BANNER":      f"{C.MAGENTA}[version banner]{C.RESET}",
        "SCORING":     f"{C.YELLOW}[scoring text]{C.RESET}",
        "COMBAT_RNG":  f"{C.RED}[combat/RNG]{C.RESET}",
        "TEXT_DIFF":   f"{C.RED}{C.BOLD}[TEXT DIFFERENCE]{C.RESET}",
    }
    print(f"  {badges.get(diff_type, diff_type)}")

    if diff_type in ("IDENTICAL", "WHITESPACE"):
        # Show abbreviated response
        preview = clean_response(zil_resp)[:120]
        if len(clean_response(zil_resp)) > 120:
            preview += "..."
        print(f"  {C.DIM}{preview}{C.RESET}")
        return

    # Show the actual differences
    zil_clean = clean_response(zil_resp)
    i7_clean = clean_response(i7_resp)

    # Line-by-line comparison
    zil_lines = zil_clean.split("\n")
    i7_lines = i7_clean.split("\n")

    sm = SequenceMatcher(None, zil_lines, i7_lines)
    for op, a1, a2, b1, b2 in sm.get_opcodes():
        if op == "equal":
            for line in zil_lines[a1:a2]:
                print(f"    {C.DIM}{line}{C.RESET}")
        elif op == "replace":
            for line in zil_lines[a1:a2]:
                print(f"  {C.RED}← {line}{C.RESET}")
            for line in i7_lines[b1:b2]:
                print(f"  {C.GREEN}→ {line}{C.RESET}")
        elif op == "delete":
            for line in zil_lines[a1:a2]:
                print(f"  {C.RED}← {line}{C.RESET}")
        elif op == "insert":
            for line in i7_lines[b1:b2]:
                print(f"  {C.GREEN}→ {line}{C.RESET}")
    print()


def generate_report(zil_turns, i7_turns, annotations, commands_zil, commands_i7):
    """Generate the full comparison report."""

    print_header("ZORK I: DUAL-VERSION EXPLORATION REPORT")
    print(f"  {C.BOLD}Player A:{C.RESET} Zork I (ZIL, Infocom original)")
    print(f"  {C.BOLD}Player B:{C.RESET} Zork I v1 (Inform 7 translation)")
    print()

    stats = {
        "IDENTICAL": 0, "WHITESPACE": 0, "SYNONYM": 0,
        "BANNER": 0, "SCORING": 0, "COMBAT_RNG": 0, "TEXT_DIFF": 0,
    }

    differences = []  # Collect significant diffs for summary

    # Compare banners first
    if zil_turns and i7_turns:
        zil_banner = zil_turns[0] if zil_turns[0][0] == "BANNER" else ("BANNER", "")
        i7_banner = i7_turns[0] if i7_turns[0][0] == "BANNER" else ("BANNER", "")

        print_section("Game Banners")
        print(f"  {C.RED}ZIL:{C.RESET}")
        for line in clean_response(zil_banner[1]).split("\n")[:6]:
            print(f"    {C.DIM}{line}{C.RESET}")
        print(f"  {C.GREEN}I7:{C.RESET}")
        for line in clean_response(i7_banner[1]).split("\n")[:6]:
            print(f"    {C.DIM}{line}{C.RESET}")
        print()

    # Compare turn-by-turn
    zil_game_turns = [t for t in zil_turns if t[0] != "BANNER"]
    i7_game_turns = [t for t in i7_turns if t[0] != "BANNER"]

    annotation_idx = 0
    turn_num = 0

    max_turns = min(len(zil_game_turns), len(i7_game_turns))

    for i in range(max_turns):
        zil_cmd, zil_resp = zil_game_turns[i]
        i7_cmd, i7_resp = i7_game_turns[i]
        turn_num += 1

        # Check for annotation markers
        while annotation_idx < len(annotations) and annotations[annotation_idx][0] <= turn_num:
            _, note = annotations[annotation_idx]
            print_section(note)
            annotation_idx += 1

        diff_type = classify_diff(zil_resp, i7_resp)
        stats[diff_type] = stats.get(diff_type, 0) + 1

        if diff_type == "TEXT_DIFF":
            differences.append((turn_num, zil_cmd, i7_cmd, zil_resp, i7_resp))

        # Only print non-identical turns (or all if verbose)
        if diff_type != "IDENTICAL":
            print_turn_comparison(turn_num, zil_cmd, i7_cmd, zil_resp, i7_resp, diff_type)

    # ── Summary ──────────────────────────────────────────────────────────
    print_header("SUMMARY", "━")

    total = sum(stats.values())
    print(f"  {C.BOLD}Total turns compared:{C.RESET} {total}")
    print()
    for category, count in sorted(stats.items(), key=lambda x: -x[1]):
        if count == 0:
            continue
        pct = (count / total * 100) if total > 0 else 0
        bar = "█" * int(pct / 2) + "░" * (50 - int(pct / 2))
        color = {
            "IDENTICAL": C.GREEN, "WHITESPACE": C.DIM, "SYNONYM": C.BLUE,
            "BANNER": C.MAGENTA, "SCORING": C.YELLOW, "COMBAT_RNG": C.RED,
            "TEXT_DIFF": C.RED + C.BOLD,
        }.get(category, "")
        print(f"  {color}{category:15s}{C.RESET} {count:3d} ({pct:5.1f}%) {C.DIM}{bar}{C.RESET}")

    # ── Significant Differences Catalog ──────────────────────────────────
    if differences:
        print_header("CATALOG OF TEXT DIFFERENCES", "╍")
        print(f"  {C.BOLD}These are genuine text differences (not RNG, synonyms, or whitespace):{C.RESET}\n")

        for idx, (turn, zcmd, icmd, zresp, iresp) in enumerate(differences, 1):
            print(f"  {C.BOLD}#{idx} (Turn {turn}):{C.RESET}")
            if zcmd == icmd:
                print(f"    Command: {C.CYAN}> {zcmd}{C.RESET}")
            else:
                print(f"    ZIL cmd: {C.RED}> {zcmd}{C.RESET}")
                print(f"    I7  cmd: {C.GREEN}> {icmd}{C.RESET}")

            # Word-diff
            z_wd, i_wd = word_diff(clean_response(zresp), clean_response(iresp))
            print(f"    {C.RED}ZIL:{C.RESET} {z_wd}")
            print(f"    {C.GREEN}I7: {C.RESET} {i_wd}")
            print()

    return stats, differences


# ── Main ─────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="Dual-version Zork I explorer")
    parser.add_argument("--seed-zil", type=int, default=3, help="RNG seed for ZIL (dfrotz)")
    parser.add_argument("--seed-i7", type=int, default=26, help="RNG seed for I7 (glulxe)")
    parser.add_argument("--route", choices=list(ROUTES.keys()), default="full",
                        help="Exploration route to use")
    parser.add_argument("--save", action="store_true", help="Save raw transcripts to files")
    args = parser.parse_args()

    # Check prerequisites
    for path, label in [(DFROTZ, "dfrotz"), (GLULXE, "glulxe"), (ZIL_GAME, "ZIL game"), (I7_GAME, "I7 game")]:
        if not path.exists():
            print(f"{C.RED}ERROR: {label} not found at {path}{C.RESET}")
            sys.exit(1)

    # Build command lists
    route_fn = ROUTES[args.route]
    raw_route = route_fn()

    # Separate annotations from commands
    annotations = []
    commands_zil = []
    commands_i7 = []
    cmd_count = 0

    for item in raw_route:
        if isinstance(item, tuple):
            # Annotation marker
            annotations.append((cmd_count + 1, item[1]))
        else:
            cmd_count += 1
            commands_zil.append(item)
            commands_i7.append(translate_zil_to_i7(item))

    print(f"{C.BOLD}Running dual exploration...{C.RESET}")
    print(f"  Route: {args.route} ({len(commands_zil)} commands)")
    print(f"  ZIL seed: {args.seed_zil}, I7 seed: {args.seed_i7}")
    print()

    # Run both interpreters
    print(f"  {C.DIM}Running ZIL (dfrotz)...{C.RESET}", end=" ", flush=True)
    zil_raw = run_interpreter(DFROTZ, ZIL_GAME, commands_zil, seed=args.seed_zil, is_zil=True)
    print(f"{C.GREEN}done{C.RESET}")

    print(f"  {C.DIM}Running I7 (glulxe)...{C.RESET}", end=" ", flush=True)
    i7_raw = run_interpreter(GLULXE, I7_GAME, commands_i7, seed=args.seed_i7, is_zil=False)
    print(f"{C.GREEN}done{C.RESET}")

    # Save raw transcripts if requested
    if args.save:
        out_dir = PROJECT / "tests"
        (out_dir / "dual_zil_transcript.txt").write_text(zil_raw, encoding="utf-8")
        (out_dir / "dual_i7_transcript.txt").write_text(i7_raw, encoding="utf-8")
        print(f"  {C.DIM}Saved transcripts to tests/dual_*_transcript.txt{C.RESET}")

    # Parse turns
    zil_turns, _ = parse_turns(zil_raw, commands_zil)
    i7_turns, _ = parse_turns(i7_raw, commands_i7)

    print(f"  ZIL turns parsed: {len(zil_turns)}")
    print(f"  I7  turns parsed: {len(i7_turns)}")

    # Generate report
    stats, diffs = generate_report(zil_turns, i7_turns, annotations, commands_zil, commands_i7)

    # Exit code: 0 if no text diffs, 1 if there are
    sys.exit(1 if diffs else 0)


if __name__ == "__main__":
    main()
