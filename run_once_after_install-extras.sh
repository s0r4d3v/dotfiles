#!/bin/bash
# Install tmux plugins and gh extensions
set -euo pipefail

# Tmux plugins
TPM_INSTALL="$HOME/.tmux/plugins/tpm/bin/install_plugins"
if [[ -x "$TPM_INSTALL" ]]; then
    echo "Installing tmux plugins..."
    "$TPM_INSTALL"
else
    echo "TPM not found at $HOME/.tmux/plugins/tpm — skipping plugin install"
fi

# GitHub CLI extensions
if command -v gh &>/dev/null; then
    echo "Installing gh extensions..."
    gh extension install meiji163/gh-notify 2>/dev/null || true
fi
