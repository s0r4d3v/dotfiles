#!/bin/bash
# Ensure age key directory exists
AGE_KEY_DIR="$HOME/.config/sops/age"
AGE_KEY_FILE="$AGE_KEY_DIR/keys.txt"

if [ ! -f "$AGE_KEY_FILE" ]; then
    echo "⚠️  Age key not found at $AGE_KEY_FILE"
    echo "Please restore your age key from your password manager (1Password/Bitwarden)."
    echo "Create the file at: $AGE_KEY_FILE"
    echo ""
    echo "If this is a new machine, generate a new key with:"
    echo "  mkdir -p $AGE_KEY_DIR && age-keygen -o $AGE_KEY_FILE"
    echo ""
    echo "Then update .chezmoi.toml.tmpl with the new public key."
    exit 1
fi

chmod 600 "$AGE_KEY_FILE"
echo "✓ Age key found at $AGE_KEY_FILE"
