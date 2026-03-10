#!/usr/bin/env python3
"""Zork I scenario transcript generator.

Extracts commands from regtest scenarios and generates full transcripts.

Usage:
    python tests/run-scenario.py <name>       # generate one scenario transcript
    python tests/run-scenario.py --all        # generate all scenario transcripts
    python tests/run-scenario.py --list       # list available scenarios
"""

import json
import re
import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
I7_ROOT = Path(r"C:\code\ifhub")

sys.path.insert(0, str(I7_ROOT / "tools"))
from lib import config


def read_conf_value(key: str) -> str:
    """Read a single value from project.conf."""
    conf = SCRIPT_DIR / "project.conf"
    for line in conf.read_text(encoding="utf-8").splitlines():
        m = re.match(rf'^{key}=["\']?(.*?)["\']?\s*$', line.strip())
        if m:
            val = m.group(1)
            val = val.replace("$PROJECT_DIR", str(SCRIPT_DIR.parent))
            return val
    return ""


# Load config
cfg = config.load_config(SCRIPT_DIR / "project.conf")
ENGINE_PATH = cfg.primary.path
SEED_FLAG = cfg.primary.seed_flag
GAME_PATH = cfg.primary.game_path
SEED = config.get_golden_seed(cfg.project_dir, cfg.primary.seeds_key) or ""

SCENARIOS_DIR = SCRIPT_DIR / "scenarios"
INDEX_FILE = SCENARIOS_DIR / "index.json"


def generate_transcript(name: str) -> bool:
    output = SCENARIOS_DIR / f"{name}.transcript.txt"
    print(f"Generating transcript for scenario: {name}")

    # Extract commands
    result = subprocess.run(
        [sys.executable, str(SCRIPT_DIR / "extract-scenario-commands.py"),
         "--regtest", str(SCRIPT_DIR / "zork1.regtest"), name],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        print(f"ERROR: Failed to extract commands for scenario '{name}'", file=sys.stderr)
        return False

    commands = result.stdout

    # Build engine command
    engine_cmd = [ENGINE_PATH]
    if SEED:
        engine_cmd.extend([SEED_FLAG, SEED])
    engine_cmd.extend(["-q", GAME_PATH])

    # Pipe commands to engine
    input_text = commands + "\nquit\nyes\n"
    result = subprocess.run(
        engine_cmd, input=input_text, capture_output=True, text=True,
    )

    output.write_text(result.stdout, encoding="utf-8")
    print(f"  -> {output}")
    return True


def list_scenarios():
    if not INDEX_FILE.exists():
        print(f"ERROR: index.json not found at {INDEX_FILE}", file=sys.stderr)
        sys.exit(1)
    data = json.loads(INDEX_FILE.read_text(encoding="utf-8"))
    print("Available scenarios:")
    for s in data["scenarios"]:
        print(f'  {s["name"]:20s} {s["title"]}')


def run_all():
    if not INDEX_FILE.exists():
        print(f"ERROR: index.json not found at {INDEX_FILE}", file=sys.stderr)
        sys.exit(1)
    data = json.loads(INDEX_FILE.read_text(encoding="utf-8"))
    total = passed = failed = 0
    for s in data["scenarios"]:
        total += 1
        if generate_transcript(s["name"]):
            passed += 1
        else:
            failed += 1
    print(f"\nDone: {passed}/{total} succeeded, {failed} failed")
    sys.exit(1 if failed > 0 else 0)


if __name__ == "__main__":
    SCENARIOS_DIR.mkdir(exist_ok=True)
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <name> | --all | --list", file=sys.stderr)
        sys.exit(1)
    arg = sys.argv[1]
    if arg == "--list":
        list_scenarios()
    elif arg == "--all":
        run_all()
    elif arg in ("--help", "-h"):
        print(f"Usage: {sys.argv[0]} <name> | --all | --list")
    elif arg.startswith("-"):
        print(f"ERROR: Unknown option: {arg}", file=sys.stderr)
        sys.exit(1)
    else:
        if not generate_transcript(arg):
            sys.exit(1)
