# Daily Usage

## Apply changes

```sh
cd ~/dotfiles
./switch   # auto-detects OS and architecture
```

## Remote development workflow

This setup uses **remote tmux** — tmux runs on the server, not locally.

```
Ghostty (local) → SSH → tmux on server → nvim
```

Typical session:

```sh
# Open a tab per project/server in Ghostty (Cmd+T)
ssh myserver
tmux attach   # or: tmux new -s work
```

- `C-h/j/k/l` navigate between tmux panes and nvim splits seamlessly
- Clipboard (`y` / `p`) syncs with macOS via OSC 52 through the SSH chain
- Session persists across SSH drops — `tmux attach` to resume from any machine

## CLI tools & aliases

| Command | Tool | Replaces |
|---------|------|---------|
| `ls` / `ll` / `lt` | eza | ls |
| `cat` | bat | cat |
| `find` | fd | find |
| `du` | dust | du |
| `df` | duf | df |
| `ps` | procs | ps |
| `cd` / `cdi` | zoxide | cd |
| `y` or `yazi` | yazi | file manager |
| `br` | broot | directory navigator |
| `lg` | lazygit | git |
| `lazydocker` | lazydocker | docker CLI |
| `just` | just | make |
| `xh` | xh | curl |
| `sd` | sd | sed |
| `dft` | difftastic | diff |
| `tokei` | tokei | cloc |
| `hyperfine` | hyperfine | time |
| `bandwhich` | bandwhich | nethogs |
| `gitleaks` | gitleaks | — |
| `vhs` | vhs | asciinema |

## Common tasks

| Task | File |
|------|------|
| Add/remove a package | `home/shared.nix` → `home.packages` |
| Add a Mac cask | `darwin/configuration.nix` → `homebrew.casks` |
| Change macOS system settings | `darwin/configuration.nix` → `system.defaults` |
| Edit Neovim config | `config/nvim/` |
| Edit tmux config | `config/tmux/tmux.conf` |
| Edit Ghostty config | `config/ghostty/config` |
| Add/edit a secret | `sops secrets/secrets.yaml` |
| Pin a runtime version | `mise use node@22` (creates `.mise.toml` in project) |
| Auto-load project env vars | add `.envrc` to project dir (direnv picks it up) |
| Update all inputs | `nix flake update` |

## Structure

```
flake.nix                  — inputs, per-user system definitions
home/
  shared.nix               — packages, tools, zsh, git, tmux (all platforms)
  darwin.nix               — macOS-specific: Ghostty, Karabiner
  linux.nix                — Linux-specific home config
darwin/
  configuration.nix        — nix-darwin: Homebrew casks, fonts, macOS defaults
config/
  nvim/                    — Neovim config (lazy.nvim, plugins per category)
  tmux/tmux.conf           — tmux config
  ghostty/config           — Ghostty terminal config (theme, font, keybinds)
  karabiner/karabiner.json — Karabiner-Elements: Esc→English, Caps Lock toggle
  claude-code/             — Claude Code settings + safety hooks
  gh/                      — GitHub CLI config
  yazi/                    — Yazi file manager config
secrets/
  secrets.yaml             — sops-encrypted secrets (SSH keys, SSH config)
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
| `navigation.lua` | fzf-lua, oil, Navigator, harpoon, aerial, flash |
| `editor.lua` | surround, mini.*, multicursor, neogen |
| `tools.lua` | grug-far, nvim-bqf, render-markdown, persistence |
| `ui.lua` | snacks, lualine, which-key, noice, trouble, colorizer, zen-mode |
