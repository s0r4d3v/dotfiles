<div align="center">

# 🌲 Portable Nix Dev Environment

</div>

---

## ⚡ Quick Start

```bash
# Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Clone & activate
git clone https://github.com/m02uku/dotfiles.git ~/nix_env
cd ~/nix_env && ./activate.sh
```

---

## � What Each Directory Does

| Directory              | Purpose                                                          |
| :--------------------- | :--------------------------------------------------------------- |
| `modules/devshells/`   | 🐚 **Language support** - See available devshells here           |
| `modules/home/editor/` | ✏️ **Neovim LSP config** - Language servers, linters, formatters |
| `modules/home/`        | 🏠 **All other configs** - Browser, CLI, terminal, apps          |

**Want to add a new language?**

-   Devshell: Check `modules/devshells/` for examples
-   LSP config: Check `modules/home/editor/lsp.nix` (separate from devshells)

---

## � Using Devshells

Enter language-specific development environments:

```bash
# Python development
nix develop .#python

# Haskell development  
nix develop .#haskell

# Other languages
nix develop .#markdown
nix develop .#typst
nix develop .#quarto
nix develop .#slidev
nix develop .#nix
```

**Tip:** LSP features activate automatically when you open files in supported languages.

---

## �🖥️ Supported Systems

<div align="center">

|     | System              | Status |
| :-: | :------------------ | :----: |
| 🍎  | macOS Intel         |   ✅   |
| 🍎  | macOS Apple Silicon |   ✅   |
| 🐧  | Ubuntu/Linux x86    |   ✅   |
| 🐧  | Ubuntu/Linux ARM    |   ❓   |

</div>
