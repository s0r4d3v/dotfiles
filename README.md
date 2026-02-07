# dotfiles

## Installation

```bash
git clone https://github.com/s0r4d3v/dotfiles.git
cd dotfiles
nix build ".#homeConfigurations.$(whoami).activationPackage"
./result/activate
source ~/.zshrc
ghq get s0r4d3v/dotfiles
cd ..
rm dotfiles
```

## updating

> Once installed, you can use the following aliases.

To update with pull: 

```bash
pullenv && updateenv
```

If only local nix code changes:

```bash
updateenv
```

<br>

> Note: `updateenv` rebuilds and activates the configuration.

## Tmux

Start: `tm`

Keybindings: `Ctrl-a` prefix
