# Dotfiles

[![Nix](https://img.shields.io/badge/Nix-5277C3?style=for-the-badge&logo=nix&logoColor=white)](https://nixos.org/)

## Prerequisites

Install Nix:
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install; exec $SHELL
```

## Installation

```bash
git clone https://github.com/s0r4d3v/dotfiles.git && cd dotfiles && nix build ".#homeConfigurations.$(whoami).activationPackage" && ./result/activate && source ~/.zshrc
```

## Updating

```bash
cd ~/ghq/github.com/s0r4d3v/dotfiles && git pull && nix build ".#homeConfigurations.$(whoami).activationPackage" && ./result/activate && source ~/.zshrc
```

## Customization

Add modules in `modules/home/`, edit files, rebuild:
```bash
nix build ".#homeConfigurations.$(whoami).activationPackage" && ./result/activate && source ~/.zshrc
```

## Troubleshooting

- Ignore warnings if builds succeed
- SSH: Check `~/.ssh/id_ed25519`
- Zsh: `setopt no_extended_glob`
- Failures: `nix flake update`
- nix-your-shell: `rm -f ~/.zcompdump* ~/.zshrc.zwc && exec zsh`

## Project Environments

```bash
initdirenv
```
in project root for direnv setup.

## Tmux

Start: `tm`

Keybindings: `Ctrl-a` prefix, `c` new window, `|`/`-` splits, `h/j/k/l` navigate, `r` reload.