# Daily Usage

## Apply changes

```sh
cd ~/dotfiles
./switch   # auto-detects OS and architecture
```

## Common tasks

| Task | File |
|------|------|
| Add/remove a package or LSP server | `home/shared.nix` |
| Add a Mac cask | `darwin/configuration.nix` |
| Change macOS system settings | `darwin/configuration.nix` → `system.defaults` |
| Add/edit a secret | `sops secrets/secrets.yaml` |
| Edit Neovim config | `config/nvim/` |
| Edit tmux config | `config/tmux/tmux.conf` |
| Update all inputs | `nix flake update` |

## Structure

```
flake.nix              — inputs, per-user system definitions
home/
  shared.nix           — packages, tools, zsh, git, tmux (all platforms)
  darwin.nix           — macOS-specific home config
  linux.nix            — Linux-specific home config
darwin/
  configuration.nix    — nix-darwin: homebrew casks, fonts, macOS defaults
config/
  nvim/                — Neovim config (lazy.nvim, plugins per category)
  tmux/tmux.conf       — tmux config
secrets/
  secrets.yaml         — sops-encrypted secrets (SSH keys, SSH config)
```

## Neovim plugins

Plugins are split by category in `config/nvim/lua/plugins/`:

| File | Contents |
|------|----------|
| `lsp.lua` | LSP servers, lazydev, SchemaStore |
| `completion.lua` | blink.cmp |
| `treesitter.lua` | Treesitter + autotag |
| `formatting.lua` | conform, nvim-lint |
| `git.lua` | gitsigns, lazygit, diffview |
| `navigation.lua` | fzf-lua, oil, harpoon, aerial, flash |
| `editor.lua` | surround, mini.*, multicursor, neogen |
| `tools.lua` | grug-far, nvim-bqf, render-markdown, persistence |
| `ui.lua` | snacks, lualine, which-key, noice, trouble, colorizer, zen-mode |
