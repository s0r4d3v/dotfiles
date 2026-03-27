# dotfiles

macOS + Linux dotfiles managed with Nix + Home Manager + nix-darwin.

---

## New machine

### 1. Add an entry to `flake.nix`

**Mac:**
```nix
darwinConfigurations."<username>" = mkDarwin {
  username = "<username>";
  system   = "aarch64-darwin";  # or "x86_64-darwin" for Intel
};
```

**Linux:**
```nix
homeConfigurations."<username>" = mkLinux {
  username = "<username>";
  system   = "x86_64-linux";  # or "aarch64-linux"
};
```

### 2. Bootstrap

```sh
git clone git@github.com:s0r4d3v/dotfiles.git /path/to/dotfiles
cd /path/to/dotfiles
```

**Mac (first time only):**
```sh
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake .#<username>
exec zsh
sudo darwin-rebuild switch --flake .#<username>
```

**Linux:**
```sh
nix run home-manager/master -- switch --flake .#<username>
```

### 3. Install Neovim plugins

```sh
exec zsh && nvim
```

---

## Daily usage

```sh
cd /path/to/dotfiles
sudo darwin-rebuild switch --flake .#<username>   # Mac
home-manager switch --flake .#<username>          # Linux
```

| Task | File |
|------|------|
| Add/remove a package | `home/shared.nix` |
| Add a Mac cask | `darwin/configuration.nix` |
| Update all inputs | `nix flake update` |

---

## Troubleshooting

**`Unexpected files in /etc`** — nix-darwin needs to own these files:
```sh
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

**`Existing file '...' would be clobbered`** — remove the conflicting file and re-apply:
```sh
rm ~/.config/tmux/tmux.conf   # adjust path to match the error
sudo darwin-rebuild switch --flake .#<username>
```

**`Unable to remove some files. Please enable Full Disk Access`** — Homebrew's `cleanup = "zap"` requires Full Disk Access:

System Settings → Privacy & Security → Full Disk Access → enable your terminal app
