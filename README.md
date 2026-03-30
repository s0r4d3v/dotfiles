# dotfiles

macOS + Linux dotfiles managed with Nix + Home Manager + nix-darwin.

---

## New machine

### 1. Add yourself to `flake.nix`

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

### 2. Place age key

The age private key must exist **before** applying. Retrieve it from Bitwarden:

```sh
mkdir -p ~/.config/sops/age
nano ~/.config/sops/age/keys.txt   # paste your private key
```

### 3. Bootstrap

> **Note:** Clone via HTTPS on first setup — SSH keys are not yet placed until after activation.

```sh
git clone https://github.com/s0r4d3v/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

**Mac (first time only):**
```sh
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin

# Detect arch and bootstrap nix-darwin (required only on first run)
ARCH=$(uname -m | sed 's/arm64/aarch64/')
sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin -- switch --flake ".#<username>-${ARCH}"
exec zsh

# All subsequent applies:
./switch
```

**Linux:**
```sh
ARCH=$(uname -m)
nix run home-manager/master -- switch --flake ".#<username>-${ARCH}"

# All subsequent applies:
./switch
```

SSH keys are automatically decrypted to `~/.ssh/` during activation.

### 4. Install Neovim plugins

```sh
exec zsh && nvim
```

---

## Daily usage

```sh
cd ~/dotfiles
./switch   # auto-detects OS and architecture
```

| Task | File |
|------|------|
| Add/remove a package | `home/shared.nix` |
| Add a Mac cask | `darwin/configuration.nix` |
| Add/edit a secret | `sops secrets/secrets.yaml` |
| Update all inputs | `nix flake update` |

---

## Secrets

Secrets are managed with [sops](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age) and automatically decrypted during activation via [sops-nix](https://github.com/Mic92/sops-nix).

### Age key setup (one time per identity)

```sh
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
# Public key: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Print public key anytime:
age-keygen -y ~/.config/sops/age/keys.txt
```

**Save the private key (`~/.config/sops/age/keys.txt`) to Bitwarden as a secure note.**

Then add your public key to `.sops.yaml`:

```yaml
creation_rules:
  - path_regex: secrets/.*\.yaml$
    age: age1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Add or edit secrets

```sh
cd ~/dotfiles
sops secrets/secrets.yaml
```

> **Note:** Before first activation, `SOPS_AGE_KEY_FILE` is not yet in your environment. Prefix the command: `SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops secrets/secrets.yaml`

The secrets file uses nested YAML under each top-level key:

```yaml
ssh:
    id_ed25519: |
        -----BEGIN OPENSSH PRIVATE KEY-----
        <private key>
        -----END OPENSSH PRIVATE KEY-----
    id_ed25519_pub: "ssh-ed25519 AAAA... user@host"
```

To add a new secret, edit `secrets/secrets.yaml` via `sops`, then declare it in `home/shared.nix`:

```nix
sops.secrets."github_token" = {};
# Access at runtime: $(cat ${config.sops.secrets.github_token.path})
```

### Sync secrets to another machine

```sh
git add secrets/secrets.yaml
git commit -m "secrets: update"
git push

# On the other machine:
git pull && ./switch
```

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
rm ~/.ssh/config   # adjust path to match the error
./switch
```

**`Unable to remove some files. Please enable Full Disk Access`** — Homebrew's `cleanup = "zap"` requires Full Disk Access:

System Settings → Privacy & Security → Full Disk Access → enable your terminal app
