# Setup

Prerequisites: Git, Nix, internet.

## Install

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
git clone https://github.com/s0r4d3v/dotfiles.git
cd dotfiles
nix build ".#homeConfigurations.$(whoami).activationPackage"
./result/activate
```

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
