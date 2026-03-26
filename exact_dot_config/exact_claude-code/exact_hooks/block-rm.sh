#!/bin/bash
input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command // ""')
if echo "$cmd" | grep -qE '^rm\s+-(rf?|r?f)\b'; then
    echo "❌ Blocked: Use 'trash' instead of 'rm -rf' for safety" >&2
    echo "💡 trash-cli is available in your Brewfile" >&2
    exit 2
fi
