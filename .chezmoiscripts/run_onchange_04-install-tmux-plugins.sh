#!/bin/sh
# Install TPM and tmux plugins
# run_onchange: re-runs when tmux.conf changes
# {{ include "dot_config/tmux/tmux.conf" | sha256sum }}

TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

echo "Installing tmux plugins..."
"$TPM_DIR/bin/install_plugins"
