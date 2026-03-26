# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## New Machine Setup

### 1. Restore age key

Copy your age key from a password manager (1Password/Bitwarden):

```bash
mkdir -p ~/.config/sops/age
vim ~/.config/sops/age/keys.txt
chmod 600 ~/.config/sops/age/keys.txt
```

### 2. Install chezmoi and apply dotfiles

**macOS:**

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
chezmoi init --apply s0r4d3v
```

**Linux / WSL:**

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply s0r4d3v
```

This will:
- Prompt for your name and email
- Install Homebrew + packages via `brew bundle` (macOS)
- Install packages via apt, cargo, and standalone installers (Linux)
- Clone external dependencies (zinit, lazy.nvim, TPM)
- Decrypt and install SSH keys
- Install gh extensions and tmux plugins
- Apply all configs

### 3. Switch chezmoi repo remote to SSH

After setup completes and SSH keys are decrypted:

```bash
chezmoi git remote set-url origin -- git@github.com:s0r4d3v/dotfiles.git
```

### 4. Change default shell to zsh (Linux only)

```bash
which zsh | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

## Daily Usage

```bash
chezmoi edit ~/.zshrc    # edit a managed file
chezmoi diff             # preview changes
chezmoi apply            # apply changes
```

## Sync Between Machines

On machine A (push changes):

```bash
chezmoi git add .
chezmoi git commit -- -m "update configs"
chezmoi git push
```

On machine B (pull and apply):

```bash
chezmoi update
```

## Secrets

Uses `chezmoi` + `age` for encrypted secrets. Keep your age key out of git.

```bash
chezmoi add --encrypt ~/.ssh/id_ed25519   # add encrypted file
chezmoi edit --apply ~/.ssh/id_ed25519    # edit encrypted file
chezmoi diff                              # view diff
```

## Shell Aliases

| Alias | Command | Note |
|---|---|---|
| `v`, `vi`, `vim` | `nvim` | Editor |
| `ls`, `ll`, `la`, `lt`, `l` | `eza` | Modern ls |
| `cat`, `less` | `bat` | Syntax-highlighted viewer |
| `cd`, `cdi` | `zoxide` | Smart directory jump |
| `..` / `...` / `....` | `cd ../..` etc. | Navigation |
| `repo` | `ghq` + `fzf` | Jump to any repo |
| `rm` | `trash` / `trash-put` | Safe delete |
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
| `oc` | `opencode` | AI coding assistant |

## Shell Functions

| Function | Usage |
|---|---|
| `dev [name]` | Start/attach tmux session with nvim |
| `mkcd <dir>` | mkdir + cd |
| `extract <file>` | Extract any archive format |
| `backup <file>` | Copy file with timestamp suffix |
| `port <n>` | Show processes using a port |

## Dev Environments

Use `devenv` for project environments and `direnv` as an auto-activate trigger:

```bash
devenv init        # creates flake.nix, devenv.nix, .envrc
direnv allow       # enable auto-activation
cd ~/projects/foo  # auto-activates
```

## License

MIT
