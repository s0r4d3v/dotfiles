# Tools & Aliases

Configuration lives in `modules/home/cli/`. All aliases are defined in `shell.nix`.

## Shell aliases

| Alias | Command | Note |
|---|---|---|
| `v`, `vi`, `vim` | `nvim` | Editor |
| `ls`, `ll`, `la`, `lt`, `l` | `eza` | Modern ls |
| `cat`, `less` | `bat` | Syntax-highlighted viewer |
| `cd`, `cdi` | `zoxide` | Smart directory jump |
| `..` / `...` / `....` | `cd ../..` etc. | Navigation |
| `repo` | `ghq` + `fzf` | Jump to any repo |
| `rm` | `trash-put` | Safe delete |
| `top` | `btop` | System monitor |
| `du` | `dust` | Disk usage |
| `df` | `duf` | Disk free |
| `ps` | `procs` | Process list |
| `watch` | `viddy` | Modern watch |
| `diff` | `difft` | Structural diff |
| `http` / `https` | `xh` | HTTP client |
| `md` | `glow` | Markdown viewer |
| `help`, `tldr` | `tealdeer` | Cheatsheets |
| `lg` | `lazygit` | Git TUI |
| `lzd` | `lazydocker` | Docker TUI |
| `tm` | `tmux` | Tmux |
| `k` | `kubectl` | Kubernetes CLI |
| `kl` | `stern` | K8s multi-pod logs |
| `kns` | `kubens` | K8s namespace switch |
| `nb` | `nom build` | Nix build with output monitor |
| `ns` | `nom shell` | Nix shell |
| `nd` | `nom develop` | Nix develop |
| `pullenv` | git pull dotfiles | Pull latest dotfiles |
| `updateenv` | build + activate | Rebuild and activate |
| `oc` | `opencode` | AI coding assistant |

## Shell functions

| Function | Usage |
|---|---|
| `dev [name]` | Start/attach tmux session with nvim |
| `mkcd <dir>` | mkdir + cd |
| `extract <file>` | Extract any archive format |
| `backup <file>` | Copy file with timestamp suffix |
| `port <n>` | Show processes using a port |
