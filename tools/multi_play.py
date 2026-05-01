#!/usr/bin/env python
"""Run a command sequence against multiple Zork versions in parallel and diff outputs.

Usage:
  python tools/multi_play.py <commands_file> [--versions v0,v1,v2,v4]

Reads commands from <commands_file> (one per line). Runs each version with the same
commands as stdin. Captures transcripts to tests/scratch/<version>.txt.
Prints a side-by-side per-command summary.
"""
from __future__ import annotations
import argparse
import os
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
INTERP_DIR = Path("C:/code/ifhub/tools/interpreters")
GLULXE = INTERP_DIR / "glulxe.exe"
DFROTZ = INTERP_DIR / "dfrotz.exe"

VERSIONS = {
    "v0": {"interp": DFROTZ, "binary": ROOT / "zork1-v0.z3", "args": ["-w", "200"], "prefix": ""},
    "v1": {"interp": GLULXE, "binary": ROOT / "v1" / "zork1.ulx", "args": [], "prefix": ""},
    "v2": {"interp": GLULXE, "binary": ROOT / "v2" / "zork1.ulx", "args": [], "prefix": ""},
    "v3": {"interp": GLULXE, "binary": ROOT / "v3" / "zork1.ulx", "args": [], "prefix": ""},
    "v4": {"interp": GLULXE, "binary": ROOT / "zork1.ulx", "args": [], "prefix": ""},
}


def run_version(name: str, commands: str) -> tuple[str, str]:
    cfg = VERSIONS[name]
    cmd = [str(cfg["interp"]), *cfg["args"], str(cfg["binary"])]
    result = subprocess.run(
        cmd, input=cfg.get("prefix", "") + commands,
        capture_output=True, text=True, timeout=60,
    )
    out = result.stdout
    # Strip dfrotz inline status bar (" Room ... Score: ... Moves: ...") that follows ">"
    if name == "v0":
        out = re.sub(r"^[ ]+\S.*?Score: \d+\s+Moves: \d+\s*\n", "", out, flags=re.MULTILINE)
        out = re.sub(r"(?<=^>)\s+\S.*?Score: \d+\s+Moves: \d+", "", out, flags=re.MULTILINE)
    return name, out


def split_by_command(transcript: str, commands: list[str]) -> list[tuple[str, str]]:
    """Split a transcript into (command, response) pairs by splitting on '>' prompts."""
    parts = re.split(r"\n>", transcript)
    out = []
    for i, cmd in enumerate(commands):
        idx = i + 1
        if idx < len(parts):
            out.append((cmd, parts[idx][len(cmd):].strip() if parts[idx].startswith(cmd) else parts[idx].strip()))
        else:
            out.append((cmd, "<no output>"))
    return out


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("commands_file", help="File with one command per line")
    p.add_argument("--versions", default="v0,v1,v2,v3,v4", help="Comma-separated versions to run")
    p.add_argument("--diff", action="store_true", help="Show side-by-side diff")
    p.add_argument("--full", action="store_true", help="Show full transcripts")
    args = p.parse_args()

    commands = Path(args.commands_file).read_text(encoding="utf-8").splitlines()
    commands = [c.strip() for c in commands if c.strip() and not c.strip().startswith("#")]
    versions = args.versions.split(",")

    # Build stdin for each: commands + quit
    stdin = "\n".join(commands) + "\nquit\ny\n"

    out_dir = ROOT / "tests" / "scratch"
    out_dir.mkdir(parents=True, exist_ok=True)

    with ThreadPoolExecutor(max_workers=len(versions)) as ex:
        results = dict(ex.map(lambda v: run_version(v, stdin), versions))

    for name, transcript in results.items():
        out_path = out_dir / f"{name}.txt"
        out_path.write_text(transcript, encoding="utf-8")

    if args.full:
        for name in versions:
            print(f"\n===== {name} =====")
            print(results[name][-3000:])
        return 0

    # Per-command diff
    splits = {name: split_by_command(results[name], commands) for name in versions}
    for i, cmd in enumerate(commands):
        print(f"\n>>> {cmd}")
        for name in versions:
            text = splits[name][i][1].split("\n")[0:3]
            text = " | ".join(text)[:140]
            print(f"  [{name}] {text}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
