#!/bin/bash
# Install gh extensions and ensure SSH include files exist
set -euo pipefail

# Ensure SSH include targets exist so ssh config parses cleanly
mkdir -p "$HOME/.ssh/config.d"
touch "$HOME/.ssh/config.d/hosts"
chmod 700 "$HOME/.ssh" 2>/dev/null || true
chmod 600 "$HOME/.ssh/config.d/hosts"

# GitHub CLI extensions
if command -v gh &>/dev/null; then
    echo "Installing gh extensions..."
    gh extension install meiji163/gh-notify 2>/dev/null || true
fi
