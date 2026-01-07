#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

USER_NAME="$(whoami)"

echo "==> Building home-manager configuration for $USER_NAME..."
if ! nix build ".#homeConfigurations.$USER_NAME.activationPackage" --no-link -o result; then
  echo "ERROR: Failed to build home-manager configuration"
  exit 1
fi

echo "==> Checking SSH key..."
if [ "${CI:-false}" = "true" ]; then
  echo "CI environment detected, skipping SSH decryption"
elif [ -f ~/.ssh/id_ed25519 ]; then
  echo "SSH key found, attempting decryption..."
  if RULES=./secrets/secrets.nix nix shell github:ryantm/agenix --command agenix -d secrets/ssh/config.age -i ~/.ssh/id_ed25519 > temp_ssh_config 2>/dev/null; then
    mv temp_ssh_config ~/.ssh/config
    chmod 600 ~/.ssh/config
    echo "SSH config decrypted successfully"
  else
    echo "ERROR: SSH config decryption failed"
    rm -f temp_ssh_config
    exit 1
  fi
else
  echo "SSH key not found at ~/.ssh/id_ed25519, skipping decryption"
fi

echo "==> Activating configuration..."
if ! HOME_MANAGER_BACKUP_EXT=bak ./result/activate; then
  echo "ERROR: Activation failed"
  exit 1
fi

echo "==> Done!"
