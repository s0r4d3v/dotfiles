<div align="center">

# Dotfiles

A Nix-based dotfiles repository using Home Manager for reproducible development environments.

[![Nix](https://img.shields.io/badge/Nix-5277C3?style=for-the-badge&logo=nix&logoColor=white)](https://nixos.org/)
[![License](https://img.shields.io/github/license/s0r4d3v/dotfiles?style=for-the-badge)](LICENSE)
[![Stars](https://img.shields.io/github/stars/s0r4d3v/dotfiles?style=for-the-badge)](https://github.com/s0r4d3v/dotfiles/stargazers)

</div>

---

## Quick Start

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Updating](#updating)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

Install Nix. Recommended one-liner:

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install; exec $SHELL
```

For other installation methods, see [Nix documentation](https://nixos.org/download).

---

## Installation

Clone the repository and activate the configuration:

```bash
git clone https://github.com/s0r4d3v/dotfiles.git && cd dotfiles
nix build ".#homeConfigurations.$(whoami).activationPackage" && ./result/activate
```

Test with commands like `nd python`, `tm`, or `v`.

---

## Updating

To update the configuration:

```bash
cd ~/ghq/github.com/s0r4d3v/dotfiles && git pull
nix build ".#homeConfigurations.$(whoami).activationPackage" && ./result/activate
```

---

## Customization

- Add new modules in `modules/home/` (e.g., `cli/my-tool.nix`).
- Edit existing files and rebuild with: `nix build ".#homeConfigurations.$(whoami).activationPackage" && ./result/activate`.

## Troubleshooting

- Ignore warnings if builds succeed.
- SSH issues: Check `~/.ssh/id_ed25519`.
- Zsh errors: Run `setopt no_extended_glob`.
- Build failures: Try `nix flake update`.

---

## Directory Structure

| Directory | Purpose |
|-----------|---------|
| `modules/home/` | Home Manager configurations (editor, CLI, browser, etc.) |

---



---

## Project Environments

To set up direnv in an existing project:

```bash
initdirenv
```

This initializes a basic flake with direnv support. Edit `flake.nix` to add packages, and the environment will load automatically.

---

## SSH and Tmux

- SSH: Configure manually in `~/.ssh/`.
- Tmux: Start with `tm`. Keybindings: `Ctrl-a` prefix, `c` for new window, `|`/`-` for splits, `h/j/k/l` for navigation, `r` to reload.

See [Tmux documentation](https://github.com/tmux/tmux/wiki) for more details.

---

## Contributing

Fork the repository, make changes, and submit a pull request. Report issues or suggest features in [GitHub Issues](https://github.com/s0r4d3v/dotfiles/issues).
