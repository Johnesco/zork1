#!/bin/bash
# Zork I walkthrough test runner (wrapper)
# Delegates to the generic testing framework with Zork-specific config.
# Translates --zil to --alt for backward compatibility.
#
# Usage:
#   wsl -e bash tests/run-walkthrough.sh                  # Inform 7, golden seed
#   wsl -e bash tests/run-walkthrough.sh --zil            # ZIL version, golden seed
#   wsl -e bash tests/run-walkthrough.sh --seed 42        # Override seed
#   wsl -e bash tests/run-walkthrough.sh --no-seed        # True randomness
#   wsl -e bash tests/run-walkthrough.sh --diff           # Compare output vs saved baseline
#   wsl -e bash tests/run-walkthrough.sh --quiet          # Suppress diagnostic output, just exit code
#   wsl -e bash tests/run-walkthrough.sh --no-save        # Don't overwrite saved output file

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
I7_ROOT="/mnt/c/code/ifhub"
CONFIG="$SCRIPT_DIR/project.conf"

# Translate --zil to --alt for backward compatibility
ARGS=("$@")
for i in "${!ARGS[@]}"; do
    [[ "${ARGS[$i]}" == "--zil" ]] && ARGS[$i]="--alt"
done

exec bash "$I7_ROOT/tools/testing/run-walkthrough.sh" --config "$CONFIG" "${ARGS[@]}"
