# dotfiles

Personal dotfiles. macOS + Linux.

- **Packages & configs**: Nix + Home Manager + nix-darwin
- **Neovim plugins**: lazy.nvim (Lua, managed in `config/nvim/`)

---

## Setup — macOS

### 1. Install Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Clone and apply

```sh
git clone git@github.com:s0r4d3v/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
darwin-rebuild switch --flake .#soranagano
```

### 3. Install Neovim plugins

```sh
exec zsh
nvim  # lazy.nvim auto-installs on first launch
```

---

## Setup — Linux (remote server)

### 1. Install Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Install Home Manager and apply

```sh
nix run home-manager/master -- init --switch
git clone git@github.com:s0r4d3v/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
# Edit home/linux.nix: set home.username and home.homeDirectory
home-manager switch --flake .#linux
```

### 3. Install Neovim plugins

```sh
exec zsh
nvim
```

---

## Daily usage

| Task | Command |
|------|---------|
| Apply config changes | `darwin-rebuild switch --flake .#soranagano` (Mac) |
| Apply config changes | `home-manager switch --flake .#linux` (Linux) |
| Add/remove a package | edit `home/shared.nix` → apply |
| Add a Mac cask | edit `darwin/configuration.nix` → apply |
| Update all inputs | `nix flake update` → apply |

**Push to GitHub:**
```sh
cd ~/.config/dotfiles
git add -p && git commit -m "..." && git push
```

---

## Troubleshooting

**`error: experimental Nix feature 'nix-command' is disabled`**

The Nix installer enables this by default, but requires a full terminal restart (not just `exec zsh`) to take effect. If it still fails after reopening the terminal, enable it manually:

```sh
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Then retry the `nix run` command.

---

## Repository structure

```
flake.nix                  # entry point: defines Mac + Linux configurations
home/
  shared.nix               # packages, zsh, tmux, neovim (both platforms)
  darwin.nix               # macOS: PATH, aliases
  linux.nix                # Linux: PATH, aliases, genericLinux target
darwin/
  configuration.nix        # nix-darwin: homebrew casks, system settings
config/
  nvim/
    init.lua               # Neovim core options + keymaps
    lua/plugins.lua        # lazy.nvim plugin list
```
