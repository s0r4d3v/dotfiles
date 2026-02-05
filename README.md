[![Nix](https://img.shields.io/badge/Nix-5277C3?style=for-the-badge&logo=nix&logoColor=white)](https://nixos.org/)

## Installation

```bash
git clone https://github.com/s0r4d3v/dotfiles.git && cd dotfiles && nix build ".#homeConfigurations.$(whoami).activationPackage" && ./result/activate && source ~/.zshrc
```

## Updating

To update with pull: `pullenv && updateenv`

If only local Nix code changes: `updateenv`

Note: `updateenv` rebuilds and activates the configuration.

## Tmux

Start: `tm`

Keybindings: `Ctrl-a` prefix, `c` new window, `|`/`-` splits, `h/j/k/l` navigate, `r` reload.
