<div align="center">

# 🌲 Portable Nix Dev Environment

**One command. Any machine. Same setup.**

[![Nix](https://img.shields.io/badge/Nix-5277C3?style=for-the-badge&logo=nixos&logoColor=white)](https://nixos.org)
[![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io)

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

**That's it.** Your development environment is ready. ✨

---

## 🛠️ Language Support

| Language | LSP | Linter | Formatter |
| :------- | :-- | :----- | :-------- |
| **Python** | pyright | ruff | ruff |
| **Nix** | nil | statix | nixfmt-rfc-style |
| **Haskell** | HLS | hlint | ormolu |
| **Vue.js** | vue-ls | eslint | prettierd |
| **TypeScript** | vue-ls | eslint | prettierd |
| **JavaScript** | vue-ls | eslint | prettierd |
| **Markdown** | marksman | markdownlint | prettierd |
| **Typst** | tinymist | - | typstyle |

### 🐚 Devshells

Project-specific environments with `direnv`:

- `python` - Python development
- `haskell` - Haskell toolchain
- `markdown` - Markdown tools
- `quarto` - Quarto + Jupyter
- `typst` - Typst compiler
- `slidev` - Node.js + pnpm
- `nix` - Nix development

---

## 📁 Project Structure

```
📦 nix_env/
├── flake.nix          # Main flake
├── activate.sh        # Setup script
├── modules/
│   ├── devshells/     # Language-specific shells
│   ├── home/          # Home Manager modules
│   └── core/          # Core configuration
└── templates/         # Project templates
```

---

## 🖥️ Supported Systems

<div align="center">

|     | System              | Status |
| :-: | :------------------ | :----: |
| 🍎  | macOS Intel         |   ✅   |
| 🍎  | macOS Apple Silicon |   ✅   |
| 🐧  | Ubuntu/Linux x86    |   ✅   |
| 🐧  | Ubuntu/Linux ARM    |   ❓   |

</div>
