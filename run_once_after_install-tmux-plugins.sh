#!/bin/bash
# Install tmux plugins via TPM headless installer
set -euo pipefail

TPM_INSTALL="$HOME/.tmux/plugins/tpm/bin/install_plugins"

if [[ -x "$TPM_INSTALL" ]]; then
    echo "Installing tmux plugins..."
    "$TPM_INSTALL"
else
    echo "TPM not found at $HOME/.tmux/plugins/tpm — skipping plugin install"
fi
