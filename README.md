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

| Directory              | Purpose                                                   |
| :--------------------- | :-------------------------------------------------------- |
| `modules/devshells/`   | Language support - See available devshells here           |
| `modules/home/editor/` | Neovim LSP config - Language servers, linters, formatters |
| `modules/home/`        | All other configs - Browser, CLI, terminal, apps          |

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
nix develop $DOTFILES_PATH#python

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

## Supported Systems

<div align="center">

|       | System              | Status |
| :---: | :------------------ | :----: |
| macOS | macOS Intel         |   ✅   |
| macOS | macOS Apple Silicon |   ✅   |
| Linux | Ubuntu/Linux x86    |   ✅   |
| Linux | Ubuntu/Linux ARM    |   ❓   |

</div>
