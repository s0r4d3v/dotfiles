# Setup

Prerequisites: Git, Nix, internet.

## Install

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
git clone https://github.com/s0r4d3v/dotfiles.git
cd dotfiles
nix build ".#homeConfigurations.$(whoami).activationPackage"
./result/activate
cd ..
rm dotfiles
ghq clone git@github.com:s0r4d3v/dotfiles.git
```

## Set up SOPS age key

Place your age key before activation:

```bash
mkdir -p ~/.config/sops/age
# Copy the age key content from Bitwarden and paste it into keys.txt
nano ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

## Change default shell to zsh

```bash
which zsh | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

Log out and back in.

## Update

```bash
pullenv && updateenv
```

## Validate (before activating)

```bash
nix flake check --no-build
```

## WSL (Windows)

Works on WSL2. Follow the same steps above — macOS-specific tools (Karabiner, Homebrew casks) are automatically skipped on Linux.
