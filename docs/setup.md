# Setup — New Machine

## 1. Add yourself to `flake.nix`

If your username isn't already listed, add entries for the platforms you use:

```nix
darwinConfigurations = {
  "<username>-aarch64" = mkDarwin { username = "<username>"; system = "aarch64-darwin"; };
  "<username>-x86_64"  = mkDarwin { username = "<username>"; system = "x86_64-darwin"; };
};
homeConfigurations = {
  "<username>-x86_64"  = mkLinux { username = "<username>"; system = "x86_64-linux"; };
  "<username>-aarch64" = mkLinux { username = "<username>"; system = "aarch64-linux"; };
};
```

## 2. Place age key

The age private key must exist **before** applying. Retrieve it from Bitwarden:

```sh
mkdir -p ~/.config/sops/age
vim ~/.config/sops/age/keys.txt    # paste your private key
```

## 3. Bootstrap

> **Note:** Clone via HTTPS on first setup — SSH keys are not yet placed until after activation.

```sh
git clone https://github.com/s0r4d3v/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

**Mac (first time only — move files that conflict with nix-darwin):**
```sh
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

**All platforms (first run and every run after):**
```sh
./switch
```

`./switch` auto-detects OS and architecture. On first run it bootstraps via `nix run` if `darwin-rebuild` / `home-manager` are not yet installed.

SSH keys are automatically decrypted to `~/.ssh/` during activation.

After the first run, `./switch` migrates the repo into ghq automatically. Since a script cannot change the parent shell's directory, run this manually:

```sh
cd ~/ghq/github.com/s0r4d3v/dotfiles
```

## 4. Install Neovim plugins

```sh
exec zsh && nvim
```
