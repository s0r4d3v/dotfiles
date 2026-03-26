# Secrets

Uses `chezmoi` + `age` for encrypted secrets. Keep private age keys out of git.

## Operations

```bash
# Add an encrypted file
chezmoi add --encrypt ~/.ssh/id_ed25519

# Edit an encrypted file
chezmoi edit --apply ~/.ssh/id_ed25519

# View diff
chezmoi diff
```

## New machine setup

1. Restore age key to `~/.config/sops/age/keys.txt`
2. Run `chezmoi init --apply s0r4d3v`

Backup your age key securely (e.g. 1Password/Bitwarden).
