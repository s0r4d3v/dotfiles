# dotfiles

## Installation

- Install [Determinate Nix](https://docs.determinate.systems/) to use `nix` command

```bash
# In container
curl -fsSL https://install.determinate.systems/nix | sh -s -- install linux --init none
echo '. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' >> ~/.bashrc && source ~/.bashrc
```

```bash
git clone https://github.com/s0r4d3v/dotfiles.git
cd dotfiles
nix build ".#homeConfigurations.$(whoami).activationPackage"
export USER="$(whoami)"
./result/activate
cd ..
rm -rf dotfiles
exec zsh
ghq get s0r4d3v/dotfiles
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

**Note**: For SSH remote work, don't start tmux locally. Start tmux only on the remote host to avoid nested tmux issues.
