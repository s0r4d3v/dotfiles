# Secrets

This repo uses `sops-nix` + `age` for encrypted secrets. Keep private age keys out of git.

Basic operations:
- Edit secrets: `sops secrets/secrets.yaml`
- Backup age key securely (1Password recommended)
- Restore on new machine: place `~/.config/sops/age/keys.txt` and run `updateenv`
