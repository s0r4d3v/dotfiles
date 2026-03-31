# Troubleshooting

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

**`sops-nix.service failed` on WSL** — sops-nix requires systemd. Enable it in WSL:

```sh
sudo tee -a /etc/wsl.conf <<'EOF'
[boot]
systemd=true
EOF
```

Then restart WSL from PowerShell: `wsl --shutdown`, reopen, and run `./switch` again.

**`sops-nix.service failed` — age key missing** — check the key exists:
```sh
ls ~/.config/sops/age/keys.txt
```

If missing, retrieve from Bitwarden and place it, then re-run `./switch`.

**noice.nvim: "An error happened while handling a ui event" (E5560 `localtime` in fast event)** — a noice.nvim bug; update the plugin to fix it:
```
:Lazy update
```

**Local changes block git pull on `./switch`** — stash or commit first:
```sh
git stash
./switch
git stash pop
```
