#!/bin/bash
input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command // ""')
if echo "$cmd" | grep -qE 'git\s+push\s+.*(-f|--force).*(main|master)'; then
    echo "❌ Blocked: Force push to main/master is prohibited" >&2
    echo "💡 Create a feature branch instead" >&2
    exit 2
fi
