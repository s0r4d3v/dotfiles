# Claude Code Context — chezmoi Dotfiles

Minimal project context for automated tooling.

- Uses chezmoi for dotfiles management
- Secrets encrypted with age
- Packages: Brewfile (macOS) + manual (Linux)
- Neovim: Lua + lazy.nvim
- Shell: zsh + zinit
- Theme: Catppuccin Macchiato everywhere

## Structure

- `dot_*` — chezmoi source files (mapped to `~/.*`)
- `dot_config/*` — mapped to `~/.config/*`
- `run_once_*` / `run_onchange_*` — chezmoi scripts
- `scripts/` — utility scripts (not managed by chezmoi)

## Guidelines

- Read files before editing
- Test with `chezmoi diff` before applying
- Apply with `chezmoi apply`
- Secrets: `chezmoi add --encrypt <path>`
