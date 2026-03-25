# Claude Code Context - chezmoi Dotfiles

Minimal project context for automated tooling.

- Uses chezmoi for dotfiles management
- Age encryption for secrets (`~/.config/age/key.txt`)
- macOS package management via Homebrew (`Brewfile`)

## Structure

- `dot_*` / `private_dot_*` — config files (map to `~/`)
- `.chezmoi.toml.tmpl` — chezmoi bootstrap config
- `.chezmoiscripts/` — install scripts (run_once / run_onchange)
- `Brewfile` — Homebrew packages
- `private_dot_ssh/` — SSH config and age-encrypted keys

## Guidelines

- Read files before editing
- Test with `chezmoi apply --dry-run` before applying
- Secrets are age-encrypted (`.age` files); age key at `~/.config/age/key.txt`
