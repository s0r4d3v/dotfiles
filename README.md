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

### 2. Clone and bootstrap (first time only)

```sh
git clone git@github.com:s0r4d3v/dotfiles.git ~/.local/share/chezmoi
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake ~/.local/share/chezmoi#soranagano
```

### 3. Reload shell and apply

`darwin-rebuild` is not available until the shell is reloaded:

```sh
exec zsh
sudo darwin-rebuild switch --flake ~/.local/share/chezmoi#soranagano
```

### 4. Install Neovim plugins

```sh
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
| Apply config changes | `sudo darwin-rebuild switch --flake ~/.local/share/chezmoi#soranagano` (Mac) |
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

The Nix installer enables this by default, but requires a full terminal restart (not just `exec zsh`) to take effect.

On the first bootstrap, nix-darwin needs to take over `/etc/nix/nix.conf`, so you cannot pre-write to it. Instead, pass the flags inline for the bootstrap run only:

```sh
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .#soranagano
```

After a successful bootstrap, nix-darwin manages `/etc/nix/nix.conf` and `experimental-features` is set permanently via `nix.settings.experimental-features` in `darwin/configuration.nix`.

**`Unexpected files in /etc, aborting activation`**

nix-darwin wants to manage `/etc/nix/nix.conf`, `/etc/bashrc`, and `/etc/zshrc`. Rename them:

```sh
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

**`Existing file '...' would be clobbered`**

Home Manager refuses to overwrite files it didn't create. Remove the conflicting file and re-apply:

```sh
rm ~/.config/tmux/tmux.conf   # adjust path to match the error
darwin-rebuild switch --flake ~/.local/share/chezmoi#soranagano
```

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
