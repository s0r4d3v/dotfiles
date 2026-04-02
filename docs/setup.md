# Setup

## 1. Install Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Open a new shell after installation.

## 2. Place age key

The age private key must exist before applying. Retrieve it from Bitwarden:

```sh
mkdir -p ~/.config/sops/age
vim ~/.config/sops/age/keys.txt   # paste your private key
```

## 3. Add yourself to `flake.nix` (if needed)

If your username isn't already listed, add entries:

```nix
darwinConfigurations = {
  "<username>-aarch64" = mkDarwin { username = "<username>"; system = "aarch64-darwin"; };
};
homeConfigurations = {
  "<username>-x86_64" = mkLinux { username = "<username>"; system = "x86_64-linux"; };
};
```

## 4. Bootstrap

Clone via HTTPS on first setup (SSH keys aren't placed until after activation):

```sh
git clone https://github.com/s0r4d3v/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

**Mac first time only** -- move files that conflict with nix-darwin:

```sh
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

**Apply (all platforms):**

```sh
./switch
```

`./switch` auto-detects OS and architecture. On first run it bootstraps `darwin-rebuild` or `home-manager` if not yet installed. On macOS it also updates Homebrew.

After the first run, the repo is migrated into ghq and the remote switches to SSH. Move into the new location:

```sh
cd ~/ghq/github.com/s0r4d3v/dotfiles
```

## 5. Neovim plugins

Open a new shell, then launch Neovim to auto-install plugins:

```sh
exec zsh
nvim
```

## Troubleshooting

**`Unexpected files in /etc`** -- nix-darwin needs to own these files:
```sh
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

**`Existing file '...' would be clobbered`** -- remove the conflicting file and re-apply:
```sh
rm ~/.ssh/config   # adjust path to match the error
./switch
```

**`Unable to remove some files. Please enable Full Disk Access`** -- Homebrew's `cleanup = "zap"` requires Full Disk Access:

System Settings > Privacy & Security > Full Disk Access > enable your terminal app

**`sops-nix.service failed` on WSL** -- enable systemd:
```sh
sudo tee -a /etc/wsl.conf <<'EOF'
[boot]
systemd=true
EOF
```
Then restart WSL: `wsl --shutdown`

**`sops-nix.service failed` -- age key missing:**
```sh
ls ~/.config/sops/age/keys.txt
```
If missing, retrieve from Bitwarden and place it, then re-run `./switch`.

**Local changes block git pull on `./switch`** -- stash or commit first:
```sh
git stash
./switch
git stash pop
```
