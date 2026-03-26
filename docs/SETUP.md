# Setup

Prerequisites: Git, internet.

## macOS

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install chezmoi and apply
brew install chezmoi
chezmoi init --apply s0r4d3v
```

## Linux / WSL

```bash
# Install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# Apply
chezmoi init --apply s0r4d3v
```

## Set up age key

Place your age key before applying:

```bash
mkdir -p ~/.config/sops/age
# Copy the age key content from Bitwarden/1Password and paste it into keys.txt
nano ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

## Migrate secrets (from sops)

If migrating from the previous Nix setup:

```bash
git show legacy/nix:secrets/secrets.yaml > /tmp/secrets.yaml
./scripts/migrate-secrets.sh /tmp/secrets.yaml
# Then add each secret to chezmoi
chezmoi add --encrypt ~/.ssh/id_ed25519
chezmoi add --encrypt ~/.ssh/id_ed25519.pub
chezmoi add --encrypt ~/.ssh/id_rsa
chezmoi add --encrypt ~/.ssh/id_rsa.pub
chezmoi add --encrypt ~/.ssh/tanaka-site
chezmoi add --encrypt ~/.ssh/config.d/hosts
```

## Change default shell to zsh

```bash
which zsh | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

Log out and back in.

## Update

```bash
chezmoi update
# or
pullenv && updateenv
```

## WSL (Windows)

Works on WSL2. Follow the Linux steps above — macOS-specific tools (Karabiner, Ghostty, Homebrew casks) are automatically skipped on Linux via `.chezmoiignore`.
