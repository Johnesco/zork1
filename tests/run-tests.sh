#!/bin/bash
# Zork I RegTest runner (wrapper)
# Delegates to regtest.py with a wrapper interpreter that answers the
# sound prompt ("Do you want sound? y/n") before test commands.
#
# Usage:
#   wsl -e bash tests/run-tests.sh                    # run all tests
#   wsl -e bash tests/run-tests.sh -v                 # verbose (show transcripts)
#   wsl -e bash tests/run-tests.sh -l                 # list available tests
#   wsl -e bash tests/run-tests.sh cellar             # run only "cellar" test
#   wsl -e bash tests/run-tests.sh -v --vital cellar  # verbose, stop on first error

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
I7_ROOT="/mnt/c/code/ifhub"

# Source project config for game path and regtest file
source "$SCRIPT_DIR/project.conf"

# Use wrapper interpreter that answers the sound prompt with "n"
WRAPPER_INTERP="bash $SCRIPT_DIR/glulxe-wrapper.sh /home/johnesco/glulxe/glulxe"

python3 "$I7_ROOT/tools/regtest.py" \
    -i "$WRAPPER_INTERP -q" \
    -g "$REGTEST_GAME" \
    "$REGTEST_FILE" \
    "$@"
