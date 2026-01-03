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

## � What Each Directory Does

| Directory | Purpose |
| :-------- | :------ |
| `modules/devshells/` | 🐚 **Language support** - See available devshells here |
| `modules/home/editor/` | ✏️ **Neovim LSP config** - Language servers, linters, formatters |
| `modules/home/` | 🏠 **All other configs** - Browser, CLI, terminal, apps |

**Want to add a new language?** Check `modules/devshells/` for examples!

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
