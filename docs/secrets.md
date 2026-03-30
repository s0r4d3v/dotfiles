# Secrets

Secrets are managed with [sops](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age) and automatically decrypted during activation via [sops-nix](https://github.com/Mic92/sops-nix).

## Age key setup (one time per identity)

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

## Add or edit secrets

```sh
cd ~/dotfiles
sops secrets/secrets.yaml
```

> **Note:** Before first activation, `SOPS_AGE_KEY_FILE` is not yet in your environment. Prefix the command:
> `SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops secrets/secrets.yaml`

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

## SSH keys

SSH keys are stored as sops secrets and decrypted to `~/.ssh/` on every activation.

**Add a new key:**

1. Edit secrets: `sops secrets/secrets.yaml`
2. Add under `ssh:`:
   ```yaml
   ssh:
       my_new_key: |
           -----BEGIN OPENSSH PRIVATE KEY-----
           ...
           -----END OPENSSH PRIVATE KEY-----
       my_new_key_pub: "ssh-ed25519 AAAA..."
   ```
3. Declare the path in `home/shared.nix`:
   ```nix
   sops.secrets."ssh/my_new_key"     = { path = "${config.home.homeDirectory}/.ssh/my_new_key";     mode = "0600"; };
   sops.secrets."ssh/my_new_key_pub" = { path = "${config.home.homeDirectory}/.ssh/my_new_key_pub"; mode = "0644"; };
   ```
4. Commit and apply: `git add -A && git commit -m "secrets: add my_new_key" && ./switch`

**Remove a key:**

1. Remove the `sops.secrets` entries from `home/shared.nix`
2. Remove the key from `secrets/secrets.yaml` via `sops secrets/secrets.yaml`
3. Commit and apply

## Edit SSH config

The SSH config (`~/.ssh/config`) is stored encrypted. To edit it:

```sh
sops secrets/secrets.yaml   # edit the ssh.config value
git add secrets/secrets.yaml && git commit -m "secrets: update ssh config"
./switch
```

## Sync secrets to another machine

```sh
git add secrets/secrets.yaml
git commit -m "secrets: update"
git push

# On the other machine:
git pull && ./switch
```
