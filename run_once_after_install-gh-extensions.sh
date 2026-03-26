#!/bin/bash
# Install GitHub CLI extensions
set -euo pipefail

if command -v gh &>/dev/null; then
    echo "Installing gh extensions..."
    gh extension install meiji163/gh-notify 2>/dev/null || true
fi
