# dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io). Supports macOS and Linux.

---

## Setup

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply s0r4d3v
exec zsh
nvim  # lazy.nvim auto-installs plugins on first launch
```

Inside Neovim, install formatters/linters:
```
:Mason
```

## Reset existing machine

```sh
rm -f ~/.zshrc ~/.tmux.conf && rm -rf ~/.config/nvim ~/.local/share/chezmoi ~/.config/chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin init --apply s0r4d3v  # same as first setup
exec zsh
```

> Already have chezmoi: `chezmoi init --apply s0r4d3v`

---

## Daily usage

| Task | Command |
|------|---------|
| Edit a config | `chezmoi edit ~/.zshrc` |
| Preview changes | `chezmoi diff` |
| Apply to home dir | `chezmoi apply` |
| Add a new file | `chezmoi add ~/.config/somefile` |
| Pull + apply from remote | `chezmoi update` |

**Edit packages** — edit `run_onchange_install-packages.sh.tmpl`, then `chezmoi apply` (script re-runs automatically):
```sh
chezmoi edit ~/.local/share/chezmoi/run_onchange_install-packages.sh.tmpl
chezmoi apply
```

**Push to GitHub:**
```sh
chezmoi cd
git add -p && git commit -m "..." && git push
```
