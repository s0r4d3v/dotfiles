# dotfiles

Nix + Home Manager dotfiles for macOS and Linux (including WSL).

## Quick start

```bash
# Install Nix (if needed)
curl -fsSL https://install.determinate.systems/nix | sh -s -- install

# Clone and build
git clone https://github.com/s0r4d3v/dotfiles.git
cd dotfiles
nix build ".#homeConfigurations.$(whoami).activationPackage"
./result/activate
```

## Docs
- [Setup](docs/SETUP.md)
- [Tools & Aliases](docs/TOOLS.md)
- [Devenv](docs/DEVENV.md)
- [Secrets](docs/SECRETS.md)

License: MIT
