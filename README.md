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

### 2. Place age key

The age private key must exist **before** applying. Retrieve it from Bitwarden:

```sh
mkdir -p ~/.config/sops/age
# Paste your private key content:
nano ~/.config/sops/age/keys.txt
```

### 3. Bootstrap

> **Note:** Clone via HTTPS on first setup — SSH keys are not yet placed until after activation.

```sh
git clone https://github.com/s0r4d3v/dotfiles.git /path/to/dotfiles
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

SSH keys are automatically decrypted to `~/.ssh/` during activation.

### 4. Install Neovim plugins

```sh
exec zsh && nvim
```

---

## Secrets

Secrets are managed with [sops](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age) and automatically decrypted during `darwin-rebuild switch` / `home-manager switch` via [sops-nix](https://github.com/Mic92/sops-nix).

### Age key setup (one time per identity)

```sh
# Generate your age key
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt

# Output looks like:
# Public key: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Print just the public key anytime:
age-keygen -y ~/.config/sops/age/keys.txt
```

**Save the private key (`~/.config/sops/age/keys.txt` content) to Bitwarden as a secure note.**

Then update `secrets/.sops.yaml` with your public key:

```yaml
creation_rules:
  - path_regex: secrets/.*\.yaml$
    age: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Add or edit secrets

```sh
cd /path/to/dotfiles

# Create or edit secrets (opens $EDITOR with decrypted content, saves encrypted)
sops secrets/secrets.yaml
```

The file structure for current secrets:

```yaml
ssh/id_ed25519: |
    -----BEGIN OPENSSH PRIVATE KEY-----
    <paste private key content>
    -----END OPENSSH PRIVATE KEY-----
ssh/id_ed25519_pub: "ssh-ed25519 AAAA... user@host"
```

To add a new secret, add the key in `secrets/secrets.yaml` via `sops`, then declare it in `home/shared.nix`:

```nix
sops.secrets."github_token" = {};
# Access at runtime: $(cat ${config.sops.secrets.github_token.path})
```

### Apply changes and sync to remote

```sh
# Commit encrypted secrets (safe to push — only readable with your age key)
git add secrets/secrets.yaml
git commit -m "secrets: update"
git push

# On remote machine — pull and apply (sops-nix decrypts automatically)
git pull
home-manager switch --flake .#<username>
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
| Add/edit a secret | `sops secrets/secrets.yaml` |
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
