# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## New Machine Setup

Install [Homebrew](https://brew.sh) first, then restore your age key:

```bash
mkdir -p ~/.config/sops/age
nano ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

Then apply dotfiles:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply s0r4d3v
```

Open nvim once to finish plugin installation.

## Daily Usage

```bash
chezmoi edit ~/.zshrc    # edit a managed file
chezmoi apply            # apply changes
chezmoi update           # pull remote changes + apply
```

## Push Changes

```bash
chezmoi git add .
chezmoi git commit -- -m "update configs"
chezmoi git push
```

## License

MIT
