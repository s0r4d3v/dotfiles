#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

USER_NAME="$(whoami)"

# Update DOTFILES_PATH in base.nix
sed -i "" "s|/placeholder/dotfiles/path|$SCRIPT_DIR|g" modules/home/base.nix

echo "==> Building home-manager configuration for $USER_NAME..."
nix build ".#homeConfigurations.$USER_NAME.activationPackage" --no-link -o result

echo "==> Activating..."
HOME_MANAGER_BACKUP_EXT=bak ./result/activate

echo "==> Done!"
