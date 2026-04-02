# Secrets

Secrets are managed with [sops](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age) and decrypted automatically during activation via [sops-nix](https://github.com/Mic92/sops-nix).

## Edit secrets

```sh
sops secrets/secrets.yaml
```

> Before first activation, `SOPS_AGE_KEY_FILE` may not be set. Prefix the command:
> `SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops secrets/secrets.yaml`

## Add an SSH key

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
3. Declare in `home/shared.nix`:
   ```nix
   sops.secrets."ssh/my_new_key"     = { path = "${config.home.homeDirectory}/.ssh/my_new_key";     mode = "0600"; };
   sops.secrets."ssh/my_new_key_pub" = { path = "${config.home.homeDirectory}/.ssh/my_new_key_pub"; mode = "0644"; };
   ```
4. Apply: `./switch`

## Remove an SSH key

1. Remove the `sops.secrets` entries from `home/shared.nix`
2. Remove the key from `secrets/secrets.yaml` via `sops secrets/secrets.yaml`
3. Apply: `./switch`

## SSH config

The SSH config (`~/.ssh/config`) is stored encrypted in `secrets/secrets.yaml` under `ssh.config`. Edit it with `sops secrets/secrets.yaml`, then `./switch`.

## Sync to another machine

```sh
git push
# On the other machine:
git pull && ./switch
```
