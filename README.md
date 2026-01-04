<div align="center">

# 🚀 Portable Nix Dev Environment

_A declarative, reproducible development environment using Nix and Home Manager._

[![Nix](https://img.shields.io/badge/Nix-5277C3?style=for-the-badge&logo=nix&logoColor=white)](https://nixos.org/)
[![License](https://img.shields.io/github/license/m02uku/dotfiles?style=for-the-badge)](LICENSE)
[![Stars](https://img.shields.io/github/stars/m02uku/dotfiles?style=for-the-badge)](https://github.com/m02uku/dotfiles/stargazers)

</div>

---

## 📋 Table of Contents

-   Quick Start
-   Directory Structure
-   Using Devshells
-   SSH Configuration
-   Zellij (Terminal Multiplexer)
-   Contributing

---

## 🚀 Quick Start

### On a New Machine

1. **Install Nix**: `curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install; exec $SHELL`
2. **Copy SSH key** (if needed): `scp ~/.ssh/id_ed25519* user@new-machine:~/.ssh/`
3. **Clone & activate**: `git clone https://github.com/m02uku/dotfiles.git && cd dotfiles && ./activate.sh`
4. **Verify**: `cat ~/.ssh/config; nd python`

**Note**: Works on Linux/macOS. Script detects OS.

**Troubleshooting**:

-   Warnings about 'builtins.toFile': Harmless.
-   SSH decryption failed: Ensure ~/.ssh/id_ed25519 exists.
-   Zsh glob errors: `setopt no_extended_glob`

### Updating on Existing Machines

```bash
cd ~/ghq/github.com/m02uku/dotfiles
git pull
./activate.sh
```

---

## 📁 Directory Structure

| Directory                     | Purpose                                                      |
| :---------------------------- | :----------------------------------------------------------- |
| `modules/devshells/`          | 🐍 Language support - See available devshells here           |
| `modules/home/base.nix`       | 🏠 Base home-manager configuration                           |
| `modules/home/browser/`       | 🌐 Web browser settings                                      |
| `modules/home/cli/`           | 💻 CLI tools and shell configuration                         |
| `modules/home/communication/` | 💬 Communication apps (Slack, Discord, etc.)                 |
| `modules/home/editor/`        | ✏️ Neovim LSP config - Language servers, linters, formatters |
| `modules/home/productivity/`  | 📅 Productivity tools (notes, calendar, etc.)                |
| `modules/home/terminal/`      | 🖥️ Terminal emulator settings                                |

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

### Key Management

- **Shared Private Key**: Use the same Ed25519 private key across all machines for consistent decryption.
- **Security**: Never commit private keys to the repository. Store securely (e.g., encrypted backup).

### Adding SSH Hosts

Use the provided script to add new SSH hosts securely:

```bash
# Set your editor if not already set
export EDITOR=nvim  # or code, vim, etc.

# Run the script
./add-ssh-host.sh
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
./activate.sh
```

**Note**: The script updates the encrypted config in the repository. After pushing, run `./activate.sh` on each machine to apply the changes.

**Note**: The repository is safe to make public - encrypted secrets require the private key for decryption.

## Zellij (Terminal Multiplexer)

Zellij provides panes, tabs, and layouts for terminal management.

### Usage

- **Start Zellij**: Use `ze`.
- **Development Layout**: `zellij --layout dev` for Neovim (left), zsh (top-right), zsh (bottom-right).
- **Layouts**: Defined in `~/.config/zellij/layouts/`.

See [Zellij documentation](https://zellij.dev/documentation/) for details.

## 🤝 Contributing

We welcome contributions! Please feel free to submit issues, feature requests, or pull requests.

- **Report Issues**: Found a bug? [Open an issue](https://github.com/m02uku/dotfiles/issues).
- **Feature Requests**: Have an idea? [Suggest it here](https://github.com/m02uku/dotfiles/discussions).
- **Contribute Code**: Fork the repo, make changes, and submit a PR.

For more details, see [CONTRIBUTING.md](CONTRIBUTING.md) (if available).

---

<div align="center">
  <p>Made with ❤️ using Nix and Home Manager</p>
</div>
