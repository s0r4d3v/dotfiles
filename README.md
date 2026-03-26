# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## New Machine Setup

### 1. Restore age key

```bash
mkdir -p ~/.config/sops/age
vim ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

### 2. Install chezmoi and apply dotfiles

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply s0r4d3v
```

This will:
- Install chezmoi
- Prompt for your name and email
- Install Homebrew + packages via `brew bundle` (macOS)
- Install packages via apt, cargo, and standalone installers (Linux)
- Clone external dependencies (zinit, lazy.nvim, TPM)
- Decrypt and install SSH keys
- Apply all configs

To add a new package, edit `Brewfile` (macOS) or the Linux section in `run_onchange_install-packages.sh.tmpl`, then run `chezmoi apply`.

## Daily Usage

```bash
chezmoi edit ~/.zshrc    # edit a managed file
chezmoi diff             # preview changes
chezmoi apply            # apply changes
```

## Sync Between Machines

On machine A (push changes):

```bash
chezmoi git add .
chezmoi git commit -- -m "update configs"
chezmoi git push
```

On machine B (pull and apply):

```bash
chezmoi update
```

## License

MIT
