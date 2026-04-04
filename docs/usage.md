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
| Edit Starship prompt | `config/.config/starship.toml` |
| Edit OpenCode config | `config/.config/opencode/opencode.json` |
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

## Git worktree workflow (ghq + gwq)

Repos are cloned via `ghq` into `~/ghq/github.com/owner/repo`.
Worktrees are managed via `gwq` at `~/ghq/github.com/owner/repo=branch`.

### Navigate

```sh
repo          # fzf picker: all repos + worktrees, preview git log + file list
              # renames the tmux window on jump
```

### Worktree lifecycle

```sh
gwq add -b feat/my-feature    # create worktree for current repo
gwq list                      # list worktrees for current repo
gwq list -g                   # list all worktrees across all repos
gwq remove                    # fzf-select and remove
gwq remove -b feat/done       # remove worktree and delete branch
```

### PR review

```sh
wpr 123    # checkout PR #123 into its own worktree, jump there
```

### Typical flow

```sh
# Start a feature
gwq add -b feat/my-thing
repo                          # jump to the new worktree

# Review a PR in parallel (open new tmux window: prefix+c)
wpr 456
# ... review done ...
gwq remove -b pr-branch

# Switch back to feature
repo
```

## Other CLI tools

broot, lazygit, lazydocker, yazi, ghq, gwq, just, mise, xh, sd, difftastic, hyperfine, tokei, gitleaks, bandwhich, glow, tldr, btop, delta, fx, vhs

## AI coding agents

- **claude-code** — Claude Code (Anthropic)
- **opencode** — OpenCode with MCP servers (config: `config/.config/opencode/opencode.json`)

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
