# dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/) for macOS and Linux.

## New machine setup

### macOS

#### 1. Transfer age key

Secrets (SSH keys) are age-encrypted. Copy your age private key from an existing machine first:

```sh
mkdir -p ~/.config/age
# Copy ~/.config/age/key.txt from your old machine via a secure channel
```

#### 2. Apply dotfiles

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/s0r4d3v/dotfiles
```

This one command installs chezmoi, clones this repo, applies all dotfiles, and runs install scripts in order:

1. Install Homebrew
2. Install all packages (`brew bundle`)
3. Install npm LSP servers
4. Install tmux plugins (TPM)
5. Install language runtimes via mise (`node@lts`, `python@latest`)
6. Install lemonade + register LaunchAgent
7. Install extras (`gh-notify` extension, `pokemon-colorscripts`)

#### 3. Open a new terminal

Shell will be fully configured on next launch.

---

### Linux (remote server)

No age key needed — SSH keys are not deployed to Linux.

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply https://github.com/s0r4d3v/dotfiles
```

This runs the Linux-specific install script which:

1. Installs apt base packages (`git`, `curl`, `tmux`, `build-essential`, `xclip`, `sshfs`, `zathura`, `zathura-pdf-backend-mupdf`)
2. Installs [mise](https://mise.jdx.dev/)
3. Installs CLI tools via mise: `eza`, `bat`, `ripgrep`, `ripgrep-all`, `fd`, `starship`, `atuin`, `zoxide`, `fzf`, `direnv`, `neovim`, `lazygit`, `gh`, `delta`, `jujutsu`, `yazi`, `age`, `shellcheck`, `shfmt`, `stylua`
4. Installs language runtimes via mise (`node@lts`, `python@latest`)
5. Installs extras (`gh-notify` extension, `pokemon-colorscripts`)

> [!NOTE]
> The apt step requires `sudo`. If you don't have sudo on the server, the apt step will fail but mise tools will still install fine.

---

## Update config on existing machine

Pull latest changes and re-apply:

```sh
chezmoi update
```

Or if you've edited files in the source directory directly:

```sh
chezmoi apply
```

To preview what would change before applying:

```sh
chezmoi diff
```

---

## Add a package

### macOS — Homebrew

1. Edit `Brewfile` in the source dir
2. Install immediately:

```sh
brew bundle install --file=~/.local/share/chezmoi/Brewfile
```

3. Commit:

```sh
cd ~/.local/share/chezmoi && jj describe -m "Add <package> to Brewfile" && jj git push
```

### Linux — mise

Install a tool and it will be available immediately (no script change needed for ad-hoc installs):

```sh
mise use -g <tool>
```

To make it permanent (installed on all machines on next `chezmoi apply`), add it to `.chezmoiscripts/run_once_02b-linux-install-packages.sh.tmpl`.

### Linux — apt

Add the package to the apt install list in `.chezmoiscripts/run_once_02b-linux-install-packages.sh.tmpl` and commit.

---

## Edit a dotfile

```sh
chezmoi edit ~/.zshrc        # opens source file in $EDITOR
chezmoi apply ~/.zshrc       # apply just that file after editing
```

Or edit the source directly in `~/.local/share/chezmoi/` and run `chezmoi apply`.

---

## Structure

```
.
├── dot_zshrc.tmpl                  # ~/.zshrc (OS-templated)
├── dot_gitconfig                   # ~/.gitconfig
├── dot_config/                     # ~/.config/
│   ├── nvim/                       # Neovim (lazy.nvim)
│   ├── tmux/                       # tmux + TPM
│   ├── ghostty/                    # Ghostty terminal (macOS)
│   ├── starship.toml               # Starship prompt
│   ├── atuin/                      # Atuin shell history
│   ├── jj/                         # Jujutsu VCS
│   └── ...
├── private_dot_ssh/                # ~/.ssh/
│   ├── config.tmpl                 # SSH config
│   └── encrypted_private_*.age    # Age-encrypted private keys (macOS only)
├── dot_local/bin/                  # ~/.local/bin/ (shell scripts)
├── dot_claude/                     # Claude Code settings
├── Brewfile                        # Homebrew packages (macOS)
└── .chezmoiscripts/
    ├── run_once_01-install-homebrew.sh.tmpl          # macOS only
    ├── run_once_02-install-brew-packages.sh.tmpl     # macOS only
    ├── run_once_02b-linux-install-packages.sh.tmpl   # Linux only
    ├── run_once_03-install-npm-lsp-servers.sh
    ├── run_onchange_04-install-tmux-plugins.sh
    ├── run_once_05-install-mise-runtimes.sh
    ├── run_once_06-darwin-install-launchd-lemonade.sh.tmpl  # macOS only
    └── run_once_07-install-extras.sh
```

---

## Secrets

SSH private keys are stored age-encrypted in `private_dot_ssh/` and deployed on macOS only. chezmoi decrypts them automatically using `~/.config/age/key.txt`.

To re-encrypt a key:

```sh
age -r <recipient-pubkey> -o private_dot_ssh/encrypted_private_<name>.age < ~/.ssh/<name>
```

The age public key (recipient) is in `.chezmoi.toml.tmpl`.

---

License: MIT
