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

echo "==> Activating configuration..."
if ! HOME_MANAGER_BACKUP_EXT=bak ./result/activate; then
  echo "ERROR: Activation failed"
  exit 1
fi

echo "==> Done!"
