<div align="center">

# Portable Nix Dev Environment

</div>

---

## Quick Start

### On a New Machine

1. **Install Nix**:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   exec $SHELL  # Reload shell
   ```

2. **Copy SSH private key** (if you have an existing setup):
   ```bash
   # From existing machine to new machine
   scp ~/.ssh/id_ed25519 user@new-machine:~/.ssh/
   scp ~/.ssh/id_ed25519.pub user@new-machine:~/.ssh/
   ```

3. **Clone & activate**:
   ```bash
   git clone https://github.com/m02uku/dotfiles.git
   cd dotfiles && ./scripts/activate.sh

   # Move to ghq-managed location (ghq is now available)
   rm -rf ../dotfiles
   ghq get https://github.com/m02uku/dotfiles.git
   cd ~/ghq/github.com/m02uku/dotfiles
   ./scripts/activate.sh  # Run again if needed for path updates
   ```

4. **Verify setup**:
   ```bash
   cat ~/.ssh/config  # Should show decrypted hosts
   nd python  # Test devshell
   ```

**Note**: This setup works on both Linux and macOS. The activation script automatically detects the OS and adjusts commands accordingly.

## Updating on Existing Machines

If you've updated the dotfiles on another machine and want to apply the changes:

```bash
cd ~/ghq/github.com/m02uku/dotfiles
git pull
./scripts/activate.sh
```

This will pull the latest changes and reapply the Home Manager configuration.

---

## What Each Directory Does

| Directory                     | Purpose                                                   |
| :---------------------------- | :-------------------------------------------------------- |
| `modules/devshells/`          | Language support - See available devshells here           |
| `modules/home/base.nix`       | Base home-manager configuration                           |
| `modules/home/browser/`       | Web browser settings                                      |
| `modules/home/cli/`           | CLI tools and shell configuration                         |
| `modules/home/communication/` | Communication apps (Slack, Discord, etc.)                 |
| `modules/home/editor/`        | Neovim LSP config - Language servers, linters, formatters |
| `modules/home/productivity/`  | Productivity tools (notes, calendar, etc.)                |
| `modules/home/terminal/`      | Terminal emulator settings                                |

**Want to add a new language?**

-   Devshell: Check `modules/devshells/` for examples
-   LSP config: Check `modules/home/editor/lsp.nix` (separate from devshells)

---

## Using Devshells

Enter language-specific development environments:

```bash
# From dotfiles directory
nix develop .#python

# From any project directory (after running ./activate.sh)
nd python

# Or explicitly
nix develop "$DOTFILES_PATH#python"

# Other languages: Check modules/devshells/ directory!
```

**Tip:** LSP features activate automatically when you open files in supported languages.

---

## Project Environments with Direnv

For project-specific environments that activate automatically:

```bash
# Copy template to your project
cp -r modules/templates/python-ml ~/your-project
cd ~/your-project

# Create .envrc file
echo "use flake" > .envrc

# Edit flake.nix for your needs
# Then activate
direnv allow

# Environment activates automatically when you cd into the project!
```

**Tip:** Templates include ready-to-use `flake.nix` files.

---

## SSH Configuration Management

SSH settings are securely encrypted using [agenix](https://github.com/ryantm/agenix). Sensitive host information (IP addresses, ports) is protected while maintaining declarative configuration.

### Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   secrets/      │    │   ~/.ssh/        │    │   SSH Hosts     │
│                 │    │                  │    │                 │
│ config.age      │───▶│ id_ed25519       │───▶│ aces-ubuntu-2   │
│ (encrypted)     │    │ (private key)    │    │ aces-desktop-24 │
│                 │    │                  │    │ etc.            │
└─────────────────┘    └──────────────────┘    └─────────────────┘
       ▲                        ▲                        │
       │                        │                        │
       └───── secrets.nix ───────┘                        │
              (public keys)                               │
                                                         ▼
                                                ┌─────────────────┐
                                                │   ~/.ssh/config │
                                                │   (decrypted)   │
                                                └─────────────────┘
```

### Key Management

-   **Shared Private Key**: Use the same Ed25519 private key across all machines for consistent decryption.
-   **Security**: Never commit private keys to the repository. Store securely (e.g., encrypted backup).

### Adding SSH Hosts

Use the provided script to add new SSH hosts securely:

```bash
# Set your editor if not already set
export EDITOR=nvim  # or code, vim, etc.

# Run the script
./scripts/add-ssh-host.sh
```

The script will:

1. Decrypt the current SSH config
2. Open your editor to add new host entries
3. Re-encrypt and save the config

**Example host entry to add:**

```bash
Host new-server
    HostName 192.168.1.100
    User username
    Port 22
    IdentityFile ~/.ssh/id_ed25519
```

After running the script, commit the changes:

```bash
git add secrets/ssh/config.age
git commit -m "Add new SSH host: new-server"
git push
```

Then activate on all machines:

```bash
./scripts/activate.sh
```

**Note**: The script updates the encrypted config in the repository. After pushing, run `./scripts/activate.sh` on each machine to apply the changes.

**Note**: The repository is safe to make public - encrypted secrets require the private key for decryption.
