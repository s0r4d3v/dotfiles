# dotfiles

macOS + Linux dotfiles managed with Nix, Home Manager, and nix-darwin.

## Quick start

```sh
# 1. Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Clone and apply
git clone https://github.com/s0r4d3v/dotfiles.git ~/dotfiles
cd ~/dotfiles
./switch

# 3. After first run, the repo moves into ghq
cd ~/ghq/github.com/s0r4d3v/dotfiles
```

See [docs/setup.md](docs/setup.md) for full bootstrap instructions.

## Structure

```
flake.nix                        — inputs, per-user configs
switch                           — apply script (auto-detects OS/arch)
home/
  shared.nix                     — packages, zsh, git, tmux, sops secrets
  darwin.nix                     — macOS home (Ghostty, Karabiner)
  linux.nix                      — Linux home
darwin/
  configuration.nix              — nix-darwin (Homebrew casks, fonts, macOS defaults)
config/.config/
  nvim/                          — Neovim (lazy.nvim)
  tmux/tmux.conf                 — tmux
  ghostty/config                 — Ghostty terminal
  karabiner/karabiner.json       — Karabiner-Elements
  gh/                            — GitHub CLI
  yazi/                          — Yazi file manager
config/.claude/                  — Claude Code settings + hooks
secrets/
  secrets.yaml                   — sops-encrypted SSH keys and config
```

## Docs

- [Setup](docs/setup.md) — new machine bootstrap + troubleshooting
- [Usage](docs/usage.md) — daily workflow, common tasks
- [Keybindings](docs/keybindings.md) — tmux, zsh, neovim
- [Secrets](docs/secrets.md) — sops/age, SSH keys
