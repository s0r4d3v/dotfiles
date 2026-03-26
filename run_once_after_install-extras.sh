#!/bin/bash
# Install gh extensions
set -euo pipefail

# GitHub CLI extensions
if command -v gh &>/dev/null; then
    echo "Installing gh extensions..."
    gh extension install meiji163/gh-notify 2>/dev/null || true
fi
