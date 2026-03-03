#!/bin/bash
# Zork I scenario transcript generator
# Extracts commands from regtest scenarios and generates full transcripts.
#
# Usage:
#   wsl -e bash tests/run-scenario.sh <name>       # generate one scenario transcript
#   wsl -e bash tests/run-scenario.sh --all         # generate all scenario transcripts
#   wsl -e bash tests/run-scenario.sh --list        # list available scenarios

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Source project configuration
CONFIG="$SCRIPT_DIR/project.conf"
if [[ ! -f "$CONFIG" ]]; then
    echo "ERROR: project.conf not found at $CONFIG" >&2
    exit 1
fi
source "$CONFIG"

# Load golden seed from seeds.conf
SEEDS_CONF="$SCRIPT_DIR/seeds.conf"
SEED=""
if [[ -f "$SEEDS_CONF" ]]; then
    SEED_LINE=$(grep "^${PRIMARY_SEEDS_KEY}:" "$SEEDS_CONF" 2>/dev/null | head -1 || true)
    if [[ -n "$SEED_LINE" ]]; then
        SEED=$(echo "$SEED_LINE" | cut -d: -f2)
    fi
fi

if [[ -z "$SEED" ]]; then
    echo "WARNING: No golden seed found for $PRIMARY_SEEDS_KEY in $SEEDS_CONF" >&2
fi

SCENARIOS_DIR="$SCRIPT_DIR/scenarios"
INDEX_FILE="$SCENARIOS_DIR/index.json"

# Ensure scenarios directory exists
mkdir -p "$SCENARIOS_DIR"

# --- Functions ---

generate_transcript() {
    local NAME="$1"
    local OUTPUT="$SCENARIOS_DIR/$NAME.transcript.txt"

    echo "Generating transcript for scenario: $NAME"

    # Extract commands from regtest file
    local COMMANDS
    COMMANDS=$(python3 "$SCRIPT_DIR/extract-scenario-commands.py" --regtest "$SCRIPT_DIR/zork1.regtest" "$NAME")
    if [[ $? -ne 0 ]]; then
        echo "ERROR: Failed to extract commands for scenario '$NAME'" >&2
        return 1
    fi

    # Build engine command
    local ENGINE_CMD="$PRIMARY_ENGINE_PATH -q"
    if [[ -n "$SEED" ]]; then
        ENGINE_CMD="$PRIMARY_ENGINE_PATH $PRIMARY_ENGINE_SEED_FLAG $SEED -q"
    fi

    # Pipe commands + quit sequence to the engine and capture output
    # Prepend "n" to decline the sound prompt at game start
    {
        echo "n"
        echo "$COMMANDS"
        echo "quit"
        echo "yes"
    } | $ENGINE_CMD "$PRIMARY_GAME_PATH" > "$OUTPUT" 2>/dev/null

    if [[ $? -ne 0 ]]; then
        echo "ERROR: Engine failed for scenario '$NAME'" >&2
        return 1
    fi

    echo "  -> $OUTPUT"
    return 0
}

list_scenarios() {
    if [[ ! -f "$INDEX_FILE" ]]; then
        echo "ERROR: index.json not found at $INDEX_FILE" >&2
        exit 1
    fi

    echo "Available scenarios:"
    python3 -c "
import json, sys
with open('$INDEX_FILE') as f:
    data = json.load(f)
for s in data['scenarios']:
    print(f'  {s[\"name\"]:20s} {s[\"title\"]}')
"
}

run_all() {
    if [[ ! -f "$INDEX_FILE" ]]; then
        echo "ERROR: index.json not found at $INDEX_FILE" >&2
        exit 1
    fi

    local NAMES
    NAMES=$(python3 -c "
import json, sys
with open('$INDEX_FILE') as f:
    data = json.load(f)
for s in data['scenarios']:
    print(s['name'])
")

    local TOTAL=0
    local PASSED=0
    local FAILED=0

    while IFS= read -r NAME; do
        [[ -z "$NAME" ]] && continue
        TOTAL=$((TOTAL + 1))
        if generate_transcript "$NAME"; then
            PASSED=$((PASSED + 1))
        else
            FAILED=$((FAILED + 1))
        fi
    done <<< "$NAMES"

    echo ""
    echo "Done: $PASSED/$TOTAL succeeded, $FAILED failed"
    [[ "$FAILED" -gt 0 ]] && exit 1
    exit 0
}

# --- Main ---

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <name> | --all | --list" >&2
    exit 1
fi

case "$1" in
    --list)
        list_scenarios
        ;;
    --all)
        run_all
        ;;
    --help|-h)
        echo "Usage: $0 <name> | --all | --list"
        echo ""
        echo "  <name>    Generate transcript for a single scenario"
        echo "  --all     Generate transcripts for all scenarios in index.json"
        echo "  --list    List available scenarios"
        ;;
    -*)
        echo "ERROR: Unknown option: $1" >&2
        echo "Usage: $0 <name> | --all | --list" >&2
        exit 1
        ;;
    *)
        generate_transcript "$1"
        ;;
esac
