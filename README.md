# dotfiles

Nix + Home Manager による macOS / Linux 向けの dotfiles。

## Quick start

# Install Nix (if needed)
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# Clone and build
git clone https://github.com/s0r4d3v/dotfiles.git
cd dotfiles
nix build ".#homeConfigurations.$(whoami).activationPackage"
./result/activate

## Docs
- [Setup](docs/SETUP.md)
- [Devenv](docs/DEVENV.md)
- [Tools](docs/TOOLS.md)
- [Secrets](docs/SECRETS.md)

License: MIT
