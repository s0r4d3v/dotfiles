# Claude Code Context — chezmoi Dotfiles

## Overview

- **Manager:** chezmoi (v2.70.0+)
- **Secrets:** age encryption (`~/.config/sops/age/keys.txt`)
- **Packages:** Brewfile (macOS) + apt/cargo/standalone (Linux)
- **Theme:** Catppuccin Macchiato everywhere

## Stack

- **Shell:** zsh + zinit + starship + zoxide + atuin + fzf + direnv + mise
- **Editor:** Neovim (Lua + lazy.nvim, 24 plugins, LSP via vim.lsp.config)
- **Terminal:** tmux (prefix `C-a`, TPM, catppuccin) + ghostty
- **Git:** delta (pager) + difft (diff) + lazygit + jj
- **Infra:** kubectl + helm + terraform + docker
- **Languages:** Python (pyright/ruff/uv), JS/TS, Lua, Bash, Nix, YAML

## Structure

- `dot_*` / `dot_config/*` — chezmoi source files → `~/.*` / `~/.config/*`
- `run_once_before_*` — prerequisites (age key validation)
- `run_once_after_*` — one-time installs (gh extensions, tmux plugins)
- `run_onchange_*` — re-run on content change (packages, launchd)
- `.chezmoiexternal.toml` — external repos (zinit, lazy.nvim, TPM)
- `scripts/` — utility scripts (not managed by chezmoi)
- `dot_ssh/encrypted_*` — age-encrypted SSH keys

## Guidelines

- Read files before editing
- Test with `chezmoi diff` before applying
- Apply with `chezmoi apply`
- Secrets: `chezmoi add --encrypt <path>`

## New Machine First Setup

All config changes must also work on a fresh machine via `chezmoi init && chezmoi apply`.
Before committing, verify:

1. **CLI tools** — If a config depends on a CLI tool, ensure it's in `Brewfile` (macOS) or `run_onchange_install-packages.sh.tmpl` (Linux)
2. **Extensions/plugins** — If a config uses a gh extension, tmux plugin, or similar, ensure a `run_once_after_*` script installs it
3. **Graceful fallback** — If a tool may not be installed yet at first launch, guard with availability checks (e.g. `command -v`, `vim.fn.executable`, `vim.fn.system` checks)
4. **Encrypted files** — Age key must exist before `chezmoi apply`; `run_once_before_setup-age-key.sh` validates this
