# dotfiles

macOS + Linux dotfiles managed with Nix + Home Manager + nix-darwin.

## Docs

- [Setup](docs/setup.md) — new machine bootstrap
- [Usage](docs/usage.md) — daily workflow, file structure, tasks
- [Keybindings](docs/keybindings.md) — tmux, zsh, neovim
- [Secrets](docs/secrets.md) — sops/age, SSH keys, SSH config
- [Troubleshooting](docs/troubleshooting.md) — common errors and fixes

## Quick start

```sh
# 1. Install Nix (if not already installed)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Clone and apply
git clone https://github.com/s0r4d3v/dotfiles.git ~/dotfiles
cd ~/dotfiles
./switch

# 3. Repo is auto-migrated into ghq after first run
cd ~/ghq/github.com/s0r4d3v/dotfiles
```

See [docs/setup.md](docs/setup.md) for full bootstrap instructions.
