#!/usr/bin/env python3
"""Extract a flat list of commands from a regtest file for a given test.

Parses a regtest file (format: https://eblong.com/zarf/plotex/regtest.html)
into named tests, recursively resolves >{include} directives, and outputs
a plain command list (one per line) to stdout.

Usage:
    python3 extract-scenario-commands.py [--regtest FILE] TESTNAME
    python3 extract-scenario-commands.py [--regtest FILE] --list
"""

import argparse
import os
import re
import sys


def parse_regtest(path):
    """Parse a regtest file into a dict of test_name -> list of items.

    Each item is either:
      ("command", text)   — a command to send
      ("include", name)   — an include directive referencing another test
    """
    tests = {}
    current_test = None

    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.rstrip("\n").rstrip("\r")

            # Skip blank lines
            if not line or line.isspace():
                continue

            # Skip comments
            if line.startswith("#"):
                continue

            # Skip global config lines (** game:, ** interpreter:)
            if line.startswith("** "):
                continue

            # Test header: * testname
            m = re.match(r"^\*\s+(\S+)", line)
            if m:
                current_test = m.group(1)
                tests[current_test] = []
                continue

            # Nothing below matters until we're inside a test
            if current_test is None:
                continue

            # Include directive: >{include} othername
            m = re.match(r"^>\{include\}\s*(\S+)", line)
            if m:
                tests[current_test].append(("include", m.group(1)))
                continue

            # Command: > text
            m = re.match(r"^>\s*(.*)", line)
            if m:
                tests[current_test].append(("command", m.group(1)))
                continue

            # Everything else is an assertion or annotation — skip it.
            # This covers:
            #   /regex        — regex assertion
            #   !text         — negated assertion
            #   {vital}       — vital marker
            #   literal text  — literal assertion
            #   (any other line that isn't a command or directive)

    return tests


def resolve_commands(tests, test_name, _visiting=None):
    """Recursively resolve a test into a flat list of command strings.

    Detects circular includes and raises an error if found.
    """
    if test_name not in tests:
        print(f"Error: unknown test '{test_name}'", file=sys.stderr)
        print(f"Use --list to see available tests.", file=sys.stderr)
        sys.exit(1)

    if _visiting is None:
        _visiting = set()

    if test_name in _visiting:
        cycle = " -> ".join(sorted(_visiting)) + f" -> {test_name}"
        print(f"Error: circular include detected: {cycle}", file=sys.stderr)
        sys.exit(1)

    _visiting = _visiting | {test_name}  # copy so siblings don't interfere

    commands = []
    for kind, value in tests[test_name]:
        if kind == "include":
            commands.extend(resolve_commands(tests, value, _visiting))
        elif kind == "command":
            commands.append(value)

    return commands


def main():
    parser = argparse.ArgumentParser(
        description="Extract commands from a regtest scenario."
    )
    parser.add_argument(
        "--regtest",
        default=None,
        help="Path to regtest file (default: zork1.regtest in script directory)",
    )
    parser.add_argument(
        "--list",
        action="store_true",
        dest="list_tests",
        help="List all available test names and exit",
    )
    parser.add_argument(
        "testname",
        nargs="?",
        help="Name of the test to extract commands for",
    )

    args = parser.parse_args()

    # Resolve default regtest path
    if args.regtest is None:
        script_dir = os.path.dirname(os.path.abspath(__file__))
        args.regtest = os.path.join(script_dir, "zork1.regtest")

    if not os.path.isfile(args.regtest):
        print(f"Error: regtest file not found: {args.regtest}", file=sys.stderr)
        sys.exit(1)

    tests = parse_regtest(args.regtest)

    if args.list_tests:
        for name in tests:
            print(name)
        return

    if args.testname is None:
        parser.error("TESTNAME is required (or use --list)")

    commands = resolve_commands(tests, args.testname)
    for cmd in commands:
        print(cmd)


if __name__ == "__main__":
    main()
