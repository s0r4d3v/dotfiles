# AGENTS.md - Coding Guidelines for Dotfiles Repository

This document provides guidelines for coding agents working in this Nix-based dotfiles repository. It includes build/test commands, code style, and conventions.

## 1. Build/Lint/Test Commands

### Build Commands
- **Full flake build**: `nix flake check` (validates flake outputs)
- **Home-manager config build**: `nix build ".#homeConfigurations.soranagano.activationPackage"` (builds activation package)
- **Activation**: Run `./result/activate` after build (applies home-manager configuration)
- **Short home build**: `nix build ".#packages.soranagano"` (shortcut to activation package)
- **Specific devshell**: `nix develop .#python` (enters Python devshell)

### Lint Commands
- **Nix formatting**: `nixfmt` (format Nix files - run manually or via LSP)
- **No automated linting** - relies on LSP linters in Neovim config (eslint, hlint, markdownlint, etc.)

### Test Commands
- **No formal tests** - this is a configuration repo, not a software project
- **Manual testing**: Build and activate, then verify tools/apps work (e.g., `tm`, `nd python`, `git status`)
- **Single "test"**: Build a specific output like `nix build .#homeConfigurations.soranagano.activationPackage --dry-run`

## 2. Code Style Guidelines

### Nix Code Style
- **Formatter**: Use `nixfmt-rfc-style` (configured in LSP)
- **Naming conventions**:
  - Functions: `camelCase` (e.g., `mkHomeConfig`)
  - Variables: `camelCase` or `snake_case` (e.g., `homeDir`, `hmModules`)
  - Modules: Lowercase with dashes (e.g., `firefox.nix`, `starship.nix`)
  - Flake outputs: `camelCase` (e.g., `homeConfigurations`)
- **Imports**: Use list syntax `[ ./path/to/module.nix ]`, avoid `import` for module lists
- **Let bindings**: Prefer `let ... in` for local variables, align with indentation
- **Functions**: Use `{ arg1, arg2 }: body` syntax, inherit where possible
- **Strings**: Prefer double quotes, use `''` for multiline
- **Comments**: Use `#` for single-line, avoid excessive comments

### Module Structure
- **Home-manager modules**: Follow `modules/home/` structure (e.g., `browser/firefox.nix`)
- **Devshells**: Place in `modules/devshells/` with `default.nix`
- **Core modules**: Keep in `modules/core/` (flake integration)
- **Imports order**: Config, options, then implementation
- **Avoid globals**: Use `config` and `pkgs` explicitly

### Error Handling
- **Nix expressions**: Failures propagate naturally - use `assert` for preconditions
- **Build errors**: Check with `nix log` after failed builds
- **Activation**: Run `./result/activate` manually after build

### Security Practices
- **No secrets managed by Nix** - Handle sensitive data manually outside the repository

### Git Practices
- **Commits**: Use descriptive messages (e.g., "Add Firefox extensions")
- **No force push**: Avoid `--force` unless necessary
- **Pre-commit**: No hooks configured, rely on manual formatting
- **Branches**: Use feature branches for changes

### Directory Structure
- `modules/core/`: Flake core (home.nix, systems.nix)
- `modules/home/`: Home-manager modules by category (cli/, editor/, etc.)
- `modules/devshells/`: Language-specific dev environments
- `home/`: User-specific home-manager config
- `.github/`: CI workflows (test.yml)

### Configuration Patterns
- **Packages**: Use `pkgs` from inputs, prefer stable unless unstable needed
- **Overlays**: Apply via `overlays` in `home.nix` (e.g., NUR)
- **Programs**: Enable via `programs.<name>.enable = true;`
- **Services**: Use `services.<name>` for daemons
- **Fonts**: Install via `fonts.packages`
- **Environment**: Set variables in `home.sessionVariables`

### Tool-Specific Conventions
- **Neovim**: Config in `editor/neovim.nix`, LSP in `editor/lsp.nix`
- **Shell**: Zsh/bash config in `cli/shell.nix`, starship in `cli/starship.nix`
- **Git**: Config in `cli/git.nix` and `editor/git.nix`
- **Tmux**: Config in `terminal/tmux.nix`
- **Firefox**: Extensions via NUR in `browser/firefox.nix`

### Adding New Modules
1. Create file in appropriate `modules/home/` subdirectory
2. Import in `modules/core/home.nix` via `hmModules`
3. Test with `nix build ".#homeConfigurations.soranagano.activationPackage"`
4. Run `./result/activate` to apply
5. Commit changes

### Devshell Usage
- **Available shells**: python, haskell, markdown, quarto, slidev, typst
- **Usage**: `nix develop .#lang` or `nd lang` (after activation)
- **Adding new**: Copy existing devshell, modify packages/tools

### SSH Management
- **Manual**: Manage SSH config and keys manually outside Nix

### Common Pitfalls
- **Unfree packages**: Not allowed globally, import nixpkgs without restrictions where needed
- **Darwin/Linux differences**: Use `pkgs.stdenv.isDarwin` for paths/OS-specific logic
- **Flake inputs**: Follows ensure compatibility (e.g., nixpkgs-unstable)

### Performance Tips
- **Build caching**: Nix handles caching automatically
- **Incremental updates**: `git pull && nix build ".#homeConfigurations.soranagano.activationPackage" && ./result/activate` for updates
- **Dry runs**: Use `--dry-run` for build commands to check without building
- **Parallel builds**: Nix builds in parallel by default

### Error Loop Resolution
- When encountering repeated build errors that cannot be resolved locally, research solutions on Nix documentation (https://nixos.org/manual/nix/unstable/) and community forums (https://discourse.nixos.org/)
- Document findings and solutions in AGENTS.md for future reference
- **You have to research solutions on documentation and forums when you stop with the error loop**

#### nix-index Database Error
- **Error**: `reading from the database at '/Users/.../.cache/nix-index/files' failed: I/O error: No such file or directory (os error 2)`. Followed by `eza: command not found`.
- **Cause**: The nix-index database is missing or corrupt. nix-index is a tool that indexes Nix packages for fast lookup, used by command-not-found functionality to suggest packages when a command is not found.
- **Solution**: Run `nix-index` to generate the database. Ensure nix-index is installed (e.g., via `nix-env -iA nixpkgs.nix-index` or include in home-manager packages). If error persists, check for symlink issues or rebuild the database.
- **References**: [GitHub Issue #265](https://github.com/nix-community/nix-index/issues/265), [NixOS Discourse](https://discourse.nixos.org/t/command-not-found-unable-to-open-database/3807), [Stack Overflow](https://stackoverflow.com/questions/36153603/command-not-found-not-working-because-programs-sqlite-is-missing)

### No Cursor Rules
No `.cursor/rules/` or `.cursorrules` file found in repository.

### No Copilot Rules
No `.github/copilot-instructions.md` file found in repository.