# Usage

## Apply changes

```sh
./switch
```

## Common tasks

| Task | File |
|------|------|
| Add/remove a package | `home/shared.nix` > `home.packages` |
| Add a Mac cask | `darwin/configuration.nix` > `homebrew.casks` |
| Change macOS system settings | `darwin/configuration.nix` > `system.defaults` |
| Edit Neovim config | `config/.config/nvim/` |
| Edit tmux config | `config/.config/tmux/tmux.conf` |
| Edit Ghostty config | `config/.config/ghostty/config` |
| Add/edit a secret | `sops secrets/secrets.yaml` |
| Update all Nix inputs | `nix flake update` |

## CLI aliases

| Alias | Tool | Replaces |
|-------|------|----------|
| `ls` / `ll` / `lt` | eza | ls |
| `cat` | bat | cat |
| `find` | fd | find |
| `du` | dust | du |
| `df` | duf | df |
| `ps` | procs | ps |
| `cd` / `cdi` | zoxide | cd |
| `vim` | neovim | vim |

## Other CLI tools

broot, lazygit (`lg`), lazydocker, yazi (`y`), ghq, just, mise, xh, sd, difftastic, hyperfine, tokei, gitleaks, bandwhich, glow, tldr, btop, delta, fx, vhs

## Neovim plugins

Plugins are split by category in `config/.config/nvim/lua/plugins/`:

| File | Contents |
|------|----------|
| `lsp.lua` | LSP servers, lazydev, SchemaStore |
| `completion.lua` | blink.cmp |
| `treesitter.lua` | Treesitter + autotag |
| `formatting.lua` | conform, nvim-lint |
| `git.lua` | gitsigns, lazygit, diffview |
| `navigation.lua` | fzf-lua, oil, Navigator, harpoon, aerial, flash |
| `editor.lua` | surround, mini.*, multicursor, neogen |
| `tools.lua` | grug-far, nvim-bqf, render-markdown, persistence |
| `ui.lua` | snacks, lualine, which-key, noice, trouble, colorizer, zen-mode |
| `notebook.lua` | Jupyter notebooks: molten, jupytext, quarto, otter, image.nvim |
