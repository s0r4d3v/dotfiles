# dotfiles

## Installation

- Install [Determinate Nix](https://docs.determinate.systems/) to use `nix` command

In container:

```bash
curl -fsSL https://install.determinate.systems/nix | sh -s -- install linux --init none
echo '. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' >> ~/.bashrc && source ~/.bashrc
```

```bash
git clone https://github.com/s0r4d3v/dotfiles.git
cd dotfiles
nix build ".#homeConfigurations.$(whoami).activationPackage"
export USER="$(whoami)"
./result/activate
exec zsh
ghq get s0r4d3v/dotfiles
cd ..
rm -rf dotfiles
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
