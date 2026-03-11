# Setup

Prerequisites: Git, Nix, internet.

Quick install:

```
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
git clone https://github.com/s0r4d3v/dotfiles.git
cd dotfiles
nix build ".#homeConfigurations.$(whoami).activationPackage"
./result/activate
```

Update:
```
pullenv && updateenv
```
