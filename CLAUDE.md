# Claude Code Context - Nix Dotfiles

This file provides Claude Code with project-specific context, conventions, and workflows.

## 🎯 Project Overview

This is a **Nix/Home Manager dotfiles repository** for declarative system configuration management.

- **Purpose**: Cross-platform (macOS/Linux) environment configuration
- **Architecture**: Nix Flakes + flake-parts + import-tree
- **Theme**: Catppuccin Macchiato (consistent across all tools)
- **Package Count**: 100+ modern CLI tools and development utilities

## 📁 Repository Structure

```
dotfiles/
├── flake.nix              # Main flake definition with inputs
├── flake.lock             # Dependency lock file (auto-generated)
├── modules/
│   ├── core/              # Core configuration (home.nix, templates, etc.)
│   └── home/              # Home Manager modules (auto-imported)
│       ├── base.nix       # Base system settings
│       ├── cli/           # CLI tools (shell, git, packages, etc.)
│       ├── editor/        # Neovim (nixvim) configuration
│       ├── terminal/      # Ghostty, Zellij configuration
│       ├── browser/       # Browser settings
│       └── productivity/  # Productivity tools
├── templates/
│   ├── direnv/            # Nix development environment template
│   └── devenv/            # devenv (fast dev env) template
└── docs/                  # Documentation (SETUP, TOOLS, DEVENV, SECRETS)
```

## 🔧 Development Workflow

### Building and Updating

```bash
# Update dotfiles from remote + rebuild
pullenv && updateenv

# Build only (local changes)
updateenv

# Manual build (verbose)
nix build ".#homeConfigurations.$(whoami).activationPackage"
./result/activate

# Check for errors (fast, no build)
nix flake check --no-build
```

### Adding Packages

1. Search for package: `nix search nixpkgs <package-name>`
2. Add to `modules/home/cli/packages.nix`
3. Rebuild: `updateenv`

### Adding New Modules

- Create file in `modules/home/*/yourmodule.nix`
- Use flake-parts format:
  ```nix
  { ... }:
  {
    flake.modules.homeManager.yourmodule = { pkgs, ... }: {
      programs.yourapp.enable = true;
    };
  }
  ```
- import-tree auto-imports all modules in `modules/`

## ⚙️ Key Technologies

### Core Stack

- **Nix**: Declarative package management
- **Home Manager**: User environment configuration
- **flake-parts**: Modular flake organization
- **import-tree**: Automatic module discovery

### Development Tools

- **devenv**: Fast project environments (<100ms startup)
- **direnv**: Auto-activation of project environments
- **treefmt-nix**: Unified code formatting across languages
- **sops-nix**: Encrypted secrets management (temporarily disabled)

### Shell & Terminal

- **Zsh**: Shell with autosuggestions, syntax highlighting, and completion
- **Starship**: Fast, customizable prompt
- **Ghostty**: GPU-accelerated terminal emulator
- **Zellij**: Terminal multiplexer (tmux alternative)
- **Atuin**: SQLite-based shell history with fuzzy search

## 📋 Code Style & Conventions

### Nix Code Style

- Use `nixfmt` for formatting (configured in treefmt-nix)
- Prefer `with pkgs;` for package lists
- Use descriptive attribute names
- Add comments for non-obvious configurations
- Group related packages together

### Module Organization

- One module per file
- Group by functionality (cli, editor, terminal, etc.)
- Use flake-parts module format consistently
- Keep modules focused and small (<200 lines)

### Git Workflow

- Use conventional commits: `feat:`, `fix:`, `docs:`, etc.
- Run `nix flake check` before committing
- Use feature branches (no direct push to main)
- Leverage `git-cliff` for changelog generation

## 🛠️ Common Tasks

### Project Environment Setup

```bash
# For new project with direnv
cd ~/Projects/myproject
initdirenv  # Creates flake.nix + .envrc
direnv allow

# For new project with devenv (recommended)
cd ~/Projects/myproject
initdevenv  # Creates flake.nix + devenv.nix + .envrc
direnv allow
```

### Troubleshooting

```bash
# Clear Nix cache
nix-collect-garbage -d

# Update flake.lock
nix flake update

# Check package availability
nix search nixpkgs <package>

# Rebuild from scratch
pullenv && updateenv
```

### Code Formatting

```bash
# Format all files (configured via treefmt-nix)
treefmt

# Format specific files
treefmt modules/home/cli/packages.nix
```

## 🔐 Security Considerations

### Secrets Management

- **sops-nix**: Currently disabled due to GitHub connectivity issues
- See `docs/SECRETS.md` for full guide
- Alternative: Manual secrets in `~/.config/*/` (gitignored)

### Safe Commands

- Use `trash` instead of `rm -rf` (trash-cli installed)
- Verify changes with `git diff` before committing
- Test in devenv before applying system-wide

## 📚 Documentation

For detailed guides, see:

- **[SETUP.md](docs/SETUP.md)**: Installation and update procedures
- **[TOOLS.md](docs/TOOLS.md)**: Modern CLI tools usage guide
- **[DEVENV.md](docs/DEVENV.md)**: Development environment setup (direnv/devenv)
- **[SECRETS.md](docs/SECRETS.md)**: Secret management with sops-nix

## 🎨 Theme Configuration

All tools use **Catppuccin Macchiato** theme:

- Neovim, Starship, Ghostty, Zellij
- bat, eza, and other CLI tools
- Consistent color scheme across the entire environment

Theme is configured via the `catppuccin` flake input and applied automatically.

## ⚡ Performance Tips

- **devenv**: Starts in <100ms (vs. nix-shell ~3s)
- **Atuin**: Faster than default Ctrl+R history search
- **Modern tools**: bat (cat), eza (ls), procs (ps), etc. are Rust-based and faster

## 🔄 Update Policy

- **flake.lock**: Updated manually with `nix flake update`
- **Packages**: Follow nixos-25.11 stable channel
- **nixvim**: Aligned with nixos-25.11 for stability

## 💡 Tips for Claude Code

When making changes:

1. Always read files before editing
2. Validate with `nix flake check --no-build` after changes
3. Test locally before committing
4. Keep changes minimal and focused
5. Document non-trivial configurations
6. Respect existing code style and structure
