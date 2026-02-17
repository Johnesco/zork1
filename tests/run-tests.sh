#!/bin/bash
# Run RegTest against Zork I using CheapGlk glulxe
# Usage: wsl -e bash tests/run-tests.sh [regtest-options...] [test-pattern]
#
# Examples:
#   wsl -e bash tests/run-tests.sh                    # run all tests
#   wsl -e bash tests/run-tests.sh -v                 # verbose (show transcripts)
#   wsl -e bash tests/run-tests.sh -l                 # list available tests
#   wsl -e bash tests/run-tests.sh cellar             # run only "cellar" test
#   wsl -e bash tests/run-tests.sh -v --vital cellar  # verbose, stop on first error

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

GLULXE="/home/johnesco/glulxe/glulxe"
GAME="$PROJECT_DIR/build/zork1.ulx"
TESTS="$PROJECT_DIR/tests/zork1.regtest"

python3 "$PROJECT_DIR/tests/regtest.py" \
    -i "$GLULXE -q" \
    -g "$GAME" \
    "$TESTS" \
    "$@"
