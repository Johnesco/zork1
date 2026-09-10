#!/usr/bin/env python
"""Build the v0 Z-machine story file from the original ZIL source.

Usage:
  python tools/build_zil.py [--out zork1-v0.z3] [--serial 260217] [--quiet]

src/zil/ is read-only reference and is laid out flat, but zork1.zil includes its
shared files as "../zork-substrate/<name>". So the sources are staged into
build/zil/ in the shape the source expects, and compiled from there.

The Z-machine serial number is the build date, so it is pinned to the serial of
the released v0 binary (260217). With it pinned the output is byte-identical to
what zork1-v0 ships, which is what the hash check at the end asserts: the
expected value comes from the dfrotz entry in tests/seeds.conf, so a drift in
either the source or the toolchain fails the build instead of silently
invalidating the golden seed and every tests/zil transcript.

Requires ZILF (https://zilf.io, mirrored at github.com/taradinoc/zilf). Set
ZILF_HOME to its install directory; the default matches the documented location.
"""
from __future__ import annotations
import argparse
import hashlib
import os
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "src" / "zil"
STAGE = ROOT / "build" / "zil"
SEEDS = ROOT / "tests" / "seeds.conf"

DEFAULT_ZILF_HOME = Path("C:/tools/zilf-1.5.0")

# zork1.zil includes these as ../zork-substrate/<name>; the rest are game files.
SUBSTRATE = ["main", "clock", "parser", "syntax", "macros", "verbs", "globals"]
GAME = ["zork1", "dungeon", "actions"]

# Serial of the released v0 binary. Unpinned, ZAPF stamps today's date and the
# output differs from the reference in exactly those three bytes.
PINNED_SERIAL = "260217"


def zilf_home() -> Path:
    return Path(os.environ.get("ZILF_HOME", DEFAULT_ZILF_HOME))


def expected_hash() -> str | None:
    """First 8 chars of the sha256 recorded for dfrotz in seeds.conf."""
    for line in SEEDS.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if line.startswith("dfrotz:"):
            parts = line.split(":")
            if len(parts) >= 3:
                return parts[2]
    return None


def stage() -> Path:
    """Copy the sources into the layout zork1.zil's INSERT-FILE paths expect."""
    if STAGE.exists():
        shutil.rmtree(STAGE)
    game_dir = STAGE / "zork1"
    substrate_dir = STAGE / "zork-substrate"
    game_dir.mkdir(parents=True)
    substrate_dir.mkdir(parents=True)
    for name in GAME:
        shutil.copy2(SRC / f"{name}.zil", game_dir)
    for name in SUBSTRATE:
        shutil.copy2(SRC / f"{name}.zil", substrate_dir)
    return game_dir


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--out", default=str(ROOT / "zork1-v0.z3"), help="Output story file")
    p.add_argument("--serial", default=PINNED_SERIAL, help="Z-machine serial to stamp")
    p.add_argument("--no-verify", action="store_true", help="Skip the hash check")
    p.add_argument("--quiet", "-q", action="store_true")
    args = p.parse_args()

    home = zilf_home()
    zilf = home / "bin" / "zilf.exe"
    if not zilf.exists():
        print(f"zilf not found at {zilf}", file=sys.stderr)
        print("Install ZILF 1.5.0 and set ZILF_HOME to its directory.", file=sys.stderr)
        return 1

    out = Path(args.out).resolve()
    game_dir = stage()

    # --asm-options passes flags to ZAPF; the leading dash and "=" are both
    # required. Given "serial=N" it prints its help, writes nothing, and does
    # not clearly fail, so the output is checked below rather than the exit code.
    cmd = [
        str(zilf), "build", "-q", "zork1.zil", str(out),
        "--asm-options", f"-s={args.serial}",
    ]
    result = subprocess.run(cmd, cwd=game_dir, capture_output=True, text=True)
    if not args.quiet and result.stdout.strip():
        print(result.stdout.strip())
    if result.stderr.strip():
        print(result.stderr.strip(), file=sys.stderr)

    if not out.exists():
        print(f"build produced no output at {out}", file=sys.stderr)
        return 1

    data = out.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    serial = data[18:24].decode("ascii", "replace")
    release = int.from_bytes(data[2:4], "big")
    if not args.quiet:
        print(f"{out.name}: {len(data)} bytes, Release {release} / Serial {serial}, sha256 {digest[:8]}")

    if args.no_verify:
        return 0
    want = expected_hash()
    if want is None:
        print("no dfrotz entry in tests/seeds.conf to verify against", file=sys.stderr)
        return 0
    if digest[:8] != want:
        print(
            f"hash mismatch: built {digest[:8]}, seeds.conf expects {want}.\n"
            "The ZIL source or the ZILF version changed. Re-validate the dfrotz "
            "golden seed and the tests/zil baselines, then update seeds.conf.",
            file=sys.stderr,
        )
        return 1
    if not args.quiet:
        print(f"matches the golden dfrotz binary ({want})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
