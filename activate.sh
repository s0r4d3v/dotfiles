#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

USER_NAME="$(whoami)"

# Update DOTFILES_PATH in base.nix
sed -i "" "s|/placeholder/dotfiles/path|$SCRIPT_DIR|g" modules/home/base.nix

echo "==> Building home-manager configuration for $USER_NAME..."
nix build ".#homeConfigurations.$USER_NAME.activationPackage" --no-link -o result

echo "==> Decrypting SSH config..."
if RULES=./secrets/secrets.nix nix shell github:ryantm/agenix --command agenix -d secrets/ssh/config.age -i ~/.ssh/id_ed25519 > temp_ssh_config 2>/dev/null; then
  mv temp_ssh_config ~/.ssh/config
  chmod 600 ~/.ssh/config
  echo "SSH config decrypted successfully"
else
  echo "SSH config decryption failed or agenix not available"
fi

echo "==> Activating..."
HOME_MANAGER_BACKUP_EXT=bak ./result/activate

echo "==> Done!"
