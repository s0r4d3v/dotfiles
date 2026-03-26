#!/bin/bash
# Migration helper: sops → chezmoi+age
# Run this ONCE after setting up chezmoi to migrate existing secrets.
#
# Prerequisites:
# 1. sops and age installed
# 2. Age key at ~/.config/sops/age/keys.txt
# 3. The old secrets/secrets.yaml available (check legacy/nix branch)
#
# Usage: ./scripts/migrate-secrets.sh <path-to-secrets.yaml>

set -euo pipefail

SECRETS_FILE="${1:-}"
if [ -z "$SECRETS_FILE" ]; then
    echo "Usage: $0 <path-to-sops-secrets.yaml>"
    echo ""
    echo "Example:"
    echo "  git show legacy/nix:secrets/secrets.yaml > /tmp/secrets.yaml"
    echo "  $0 /tmp/secrets.yaml"
    exit 1
fi

echo "Decrypting secrets from $SECRETS_FILE..."

# Ensure SSH directory exists
mkdir -p ~/.ssh/config.d
chmod 700 ~/.ssh

# Decrypt each secret
sops -d --extract '["ssh-private-key-ed25519"]' "$SECRETS_FILE" > ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519

sops -d --extract '["ssh-public-key-ed25519"]' "$SECRETS_FILE" > ~/.ssh/id_ed25519.pub
chmod 644 ~/.ssh/id_ed25519.pub

sops -d --extract '["ssh-private-key-rsa"]' "$SECRETS_FILE" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

sops -d --extract '["ssh-public-key-rsa"]' "$SECRETS_FILE" > ~/.ssh/id_rsa.pub
chmod 644 ~/.ssh/id_rsa.pub

sops -d --extract '["ssh-private-key-tanaka-site"]' "$SECRETS_FILE" > ~/.ssh/tanaka-site
chmod 600 ~/.ssh/tanaka-site

sops -d --extract '["ssh-config-hosts"]' "$SECRETS_FILE" > ~/.ssh/config.d/hosts
chmod 600 ~/.ssh/config.d/hosts

echo "✓ Secrets decrypted to ~/.ssh/"
echo ""
echo "Now add them to chezmoi with encryption:"
echo "  chezmoi add --encrypt ~/.ssh/id_ed25519"
echo "  chezmoi add --encrypt ~/.ssh/id_ed25519.pub"
echo "  chezmoi add --encrypt ~/.ssh/id_rsa"
echo "  chezmoi add --encrypt ~/.ssh/id_rsa.pub"
echo "  chezmoi add --encrypt ~/.ssh/tanaka-site"
echo "  chezmoi add --encrypt ~/.ssh/config.d/hosts"
echo ""
echo "Then verify: chezmoi diff"
