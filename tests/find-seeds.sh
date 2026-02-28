#!/bin/bash
# Zork I seed sweep (wrapper)
# Delegates to the generic testing framework with Zork-specific config.
# Translates --zil to --alt for backward compatibility.
#
# Usage:
#   wsl -e bash tests/find-seeds.sh                # Inform 7 (default)
#   wsl -e bash tests/find-seeds.sh --zil          # ZIL version
#   wsl -e bash tests/find-seeds.sh --max 500      # Search range (default: 200)
#   wsl -e bash tests/find-seeds.sh --stop         # Stop on first pass (default)
#   wsl -e bash tests/find-seeds.sh --no-stop      # Continue sweep after finding pass

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
I7_ROOT="/mnt/c/code/ifhub"
CONFIG="$SCRIPT_DIR/project.conf"

# Translate --zil to --alt for backward compatibility
ARGS=("$@")
for i in "${!ARGS[@]}"; do
    [[ "${ARGS[$i]}" == "--zil" ]] && ARGS[$i]="--alt"
done

exec bash "$I7_ROOT/tools/testing/find-seeds.sh" --config "$CONFIG" "${ARGS[@]}"
