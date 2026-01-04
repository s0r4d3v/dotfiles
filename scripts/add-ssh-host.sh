#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if EDITOR is set
if [[ -z "${EDITOR:-}" ]]; then
    echo "Error: EDITOR environment variable is not set."
    echo "Please set it to your preferred editor, e.g.:"
    echo "export EDITOR=nvim"
    exit 1
fi

# Check if private key exists
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
    echo "Error: SSH private key ~/.ssh/id_ed25519 not found."
    echo "Please ensure your SSH key is available."
    exit 1
fi

echo "==> Decrypting current SSH config..."
if ! RULES=./secrets/secrets.nix nix shell github:ryantm/agenix --command agenix -d secrets/ssh/config.age -i ~/.ssh/id_ed25519 > temp_ssh_config 2>/dev/null; then
    echo "Error: Failed to decrypt SSH config. Check your setup."
    exit 1
fi

echo "==> Opening editor to edit SSH config..."
echo "Add your new SSH host entries to the file."
echo "Save and exit when done."
$EDITOR temp_ssh_config

echo "==> Re-encrypting SSH config..."
if ! nix shell github:ryantm/agenix --command agenix -e secrets/ssh/config.age -i ~/.ssh/id_ed25519 < temp_ssh_config; then
    echo "Error: Failed to re-encrypt SSH config."
    rm temp_ssh_config
    exit 1
fi

# Clean up
rm temp_ssh_config

echo "==> SSH config updated successfully!"
echo "==> Don't forget to commit the changes:"
echo "git add secrets/ssh/config.age"
echo "git commit -m 'Add new SSH host'"
echo "git push"