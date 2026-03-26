#!/bin/bash
# Claude Code status line script
# Displays: Used% | $Cost | Model | 📁 Directory

input=$(cat)

# Validate input
if [ -z "$input" ] || ! echo "$input" | jq -e . >/dev/null 2>&1; then
    echo "[No session data]"
    exit 0
fi

MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
MODEL=${MODEL:-Unknown}
USED_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | awk '{printf "%.0f", $1}')
USED_PCT=${USED_PCT:-0}
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
COST=${COST:-0}
DIR=$(basename "$(echo "$input" | jq -r '.workspace.current_dir // "."')")
DIR=${DIR:-.}

# Color codes based on context usage
if [ "$USED_PCT" -lt 50 ]; then
    COLOR="\033[32m"  # Green
elif [ "$USED_PCT" -lt 80 ]; then
    COLOR="\033[33m"  # Yellow
else
    COLOR="\033[31m"  # Red
fi

RESET="\033[0m"

COST_FORMATTED=$(printf '%.4f' "$COST")

echo -e "${COLOR}${USED_PCT}%${RESET} | \$${COST_FORMATTED} | ${MODEL} | 📁 ${DIR}"
