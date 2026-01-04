<div align="center">

# Portable Nix Dev Environment

</div>

---

## Quick Start

```bash
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Clone & activate
git clone https://github.com/m02uku/dotfiles.git ~/nix_env
cd ~/nix_env && ./activate.sh
```

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

SSH settings are managed declaratively using Home Manager's `programs.ssh` module. Host configurations are defined in `modules/home/ssh.nix` and automatically applied to `~/.ssh/config` during activation.

### Current SSH Hosts

- **aces-ubuntu-2**: Jump server (150.249.250.83:11022)
- **aces-desktop-24**: Desktop via jump server (192.168.0.219)
- **aces-desktop-13**: Desktop via jump server (192.168.0.242)

### Adding SSH Hosts

1. **Edit SSH configuration**:

    ```bash
    # Edit modules/home/ssh.nix
    # Add new host to matchBlocks
    "new-server" = {
      hostname = "192.168.1.100";
      user = "username";
      port = 22;
    };
    ```

2. **Commit changes**:

    ```bash
    git add modules/home/ssh.nix
    git commit -m "Add new SSH host: new-server"
    git push
    ```

3. **Activate on all machines**:

    ```bash
    ./activate.sh
    ```

### Setup on New Machine

1. **Clone and activate**:

    ```bash
    git clone https://github.com/m02uku/dotfiles.git ~/nix_env
    cd ~/nix_env && ./activate.sh
    ```

2. **Verify SSH config**:

    ```bash
    cat ~/.ssh/config  # Should show configured hosts
    ssh aces-ubuntu-2  # Test connection
    ```

**Note**: SSH configurations are now fully declarative and version-controlled. No manual encryption/decryption required.
