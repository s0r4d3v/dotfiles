<div align="center">

# Portable Nix Dev Environment

*One command. Any machine. Same setup.*

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

| Directory              | Purpose                                                    |
| :--------------------- | :--------------------------------------------------------- |
| `modules/devshells/`   | Language support - See available devshells here           |
| `modules/home/editor/` | Neovim LSP config - Language servers, linters, formatters |
| `modules/home/`        | All other configs - Browser, CLI, terminal, apps          |

**Want to add a new language?**

- Devshell: Check `modules/devshells/` for examples
- LSP config: Check `modules/home/editor/lsp.nix` (separate from devshells)

---

## Using Devshells

Enter language-specific development environments:

```bash
# Example: Python development
nix develop .#python

# Other languages: Check modules/devshells/ directory!
```

**Tip:** LSP features activate automatically when you open files in supported languages.

---

## Project Environments with Direnv

For project-specific environments that activate automatically:

```bash
# In your project directory
echo "use flake" > .envrc
direnv allow

# Now environment activates automatically when you cd into the project!
```

**Tip:** Create `flake.nix` in your project for custom environments.

---

## Supported Systems

<div align="center">

|     | System              | Status |
| :-: | :------------------ | :----: |
| macOS | macOS Intel         |   ✅   |
| macOS | macOS Apple Silicon |   ✅   |
| Linux | Ubuntu/Linux x86    |   ✅   |
| Linux | Ubuntu/Linux ARM    |   ❓   |

</div>
