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
cp -r templates/python-ml ~/your-project
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

- **Shared Private Key**: Use the same Ed25519 private key across all machines for consistent decryption.
- **Security**: Never commit private keys to the repository. Store securely (e.g., encrypted backup).

### Adding SSH Hosts

1. **Decrypt current config**:

   ```bash
   nix run nixpkgs#age -- -d -i ~/.ssh/id_ed25519 secrets/ssh/config.age > temp_ssh_config
   ```

2. **Edit the config**:

   ```bash
   # Add new host entries to temp_ssh_config
   # Example:
   # Host new-server
   #     HostName 192.168.1.100
   #     User username
   #     Port 22
   ```

3. **Re-encrypt and update**:

   ```bash
   nix run nixpkgs#age -- -e -i ~/.ssh/id_ed25519 -o secrets/ssh/config.age temp_ssh_config
   rm temp_ssh_config
   ```

4. **Commit changes**:

   ```bash
   git add secrets/ssh/config.age
   git commit -m "Add new SSH host: new-server"
   git push
   ```

5. **Activate on all machines**:

   ```bash
   ./activate.sh
   ```

### Setup on New Machine

1. **Copy private key securely**:

   ```bash
   # From existing machine to new machine
   scp ~/.ssh/id_ed25519 user@new-machine:~/.ssh/
   scp ~/.ssh/id_ed25519.pub user@new-machine:~/.ssh/
   ```

2. **Clone and activate**:

   ```bash
   git clone https://github.com/m02uku/dotfiles.git ~/nix_env
   cd ~/nix_env && ./activate.sh
   ```

3. **Verify SSH config**:

   ```bash
   cat ~/.ssh/config  # Should show decrypted hosts
   ssh aces-ubuntu-2  # Test connection
   ```

**Note**: The repository is safe to make public - encrypted secrets require the private key for decryption.

### Troubleshooting

#### SSH Config Decryption Errors

If `./activate.sh` fails with SSH-related errors, check the following:

##### Error: "age: error: no identity matched any of the recipients"

- **Cause**: Private key (`~/.ssh/id_ed25519`) is missing or incorrect.
- **Solution**: Copy the correct private key from an existing machine:

  ```bash
  scp ~/.ssh/id_ed25519 user@new-machine:~/.ssh/
  scp ~/.ssh/id_ed25519.pub user@new-machine:~/.ssh/
  ```

##### Error: "age: error: failed to decrypt" or similar decryption failure

- **Cause**: Private key doesn't match the encrypted file, or key is corrupted.
- **Solution**: Verify the key matches existing machines, or regenerate if necessary.

##### Error: Permission denied or file not found

- **Cause**: SSH directory permissions or key file permissions are incorrect.
- **Solution**: Ensure correct permissions:

  ```bash
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/id_ed25519
  chmod 644 ~/.ssh/id_ed25519.pub
  ```

After fixing, re-run `./activate.sh`. If issues persist, verify the key is the same across all machines.
