# Secrets

Uses `sops-nix` + `age` for encrypted secrets. Keep private age keys out of git.

## Operations

```bash
# Edit secrets
sops secrets/secrets.yaml

# Encrypt a file with age
age -r <recipient-pubkey> -o secrets/file.age secrets/file
```

## New machine setup

1. Restore age key to `~/.config/sops/age/keys.txt`
2. Run `updateenv`

Backup your age key securely (e.g. 1Password).
