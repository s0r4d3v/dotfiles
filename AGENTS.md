# AGENTS.md - Coding Guidelines for Dotfiles Repository

This document provides guidelines for coding agents working in this Nix-based dotfiles repository. It includes build/test commands, code style, and conventions.

## 1. Build/Lint/Test Commands

### Build Commands
- **Full flake build**: `nix flake check` (validates flake outputs)
- **Home-manager config build**: `nix build ".#homeConfigurations.soranagano.activationPackage"` (builds home config for user)
- **Specific devshell**: `nix develop .#python` (enters Python devshell)
- **Activation script**: `./activate.sh` (builds and activates home-manager config, decrypts SSH)

### Lint Commands
- **Nix formatting**: `nixfmt` (format Nix files - run manually or via LSP)
- **No automated linting** - relies on LSP linters in Neovim config (eslint, hlint, markdownlint, etc.)

### Test Commands
- **No formal tests** - this is a configuration repo, not a software project
- **Manual testing**: Run `./activate.sh` and verify tools/apps work (e.g., `tm`, `nd python`, `git status`)
- **SSH test**: After activation, check `cat ~/.ssh/config` and test SSH connections
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
- **Activation**: `./activate.sh` handles errors with exit codes
- **SSH decryption**: Script checks key existence and decryption success

### Security Practices
- **Secrets**: Use `agenix` for encrypted files (e.g., `secrets/ssh/config.age`)
- **Never commit keys**: Private keys stay in `~/.ssh/`, not repo
- **Public repo safe**: Encrypted secrets require private key for decryption
- **Permissions**: SSH config set to 600 after decryption

### Git Practices
- **Commits**: Use descriptive messages (e.g., "Add Firefox extensions")
- **No force push**: Avoid `--force` unless necessary
- **Pre-commit**: No hooks configured, rely on manual formatting
- **Branches**: Use feature branches for changes

### Directory Structure
- `modules/core/`: Flake core (home.nix, systems.nix)
- `modules/home/`: Home-manager modules by category (cli/, editor/, etc.)
- `modules/devshells/`: Language-specific dev environments
- `secrets/`: Encrypted sensitive data
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
4. Run `./activate.sh` to apply
5. Commit changes

### Devshell Usage
- **Available shells**: python, haskell, markdown, quarto, slidev, typst
- **Usage**: `nix develop .#lang` or `nd lang` (after activation)
- **Adding new**: Copy existing devshell, modify packages/tools

### SSH Management
- **Adding hosts**: Use `./add-ssh-host.sh` (decrypts, edits, re-encrypts)
- **Key location**: `~/.ssh/id_ed25519` (not in repo)
- **Config**: Encrypted in `secrets/ssh/config.age`
- **Activation**: Decrypted on `./activate.sh` run

### Common Pitfalls
- **Unfree packages**: Not allowed globally, import nixpkgs without restrictions where needed
- **Darwin/Linux differences**: Use `pkgs.stdenv.isDarwin` for paths/OS-specific logic
- **Flake inputs**: Follows ensure compatibility (e.g., nixpkgs-unstable)
- **Activation order**: SSH decryption happens before home-manager activation
- **CI builds**: Skip SSH decryption in CI environments

### Performance Tips
- **Build caching**: Nix handles caching automatically
- **Incremental updates**: `git pull && ./activate.sh` for updates
- **Dry runs**: Use `--dry-run` for build commands to check without building
- **Parallel builds**: Nix builds in parallel by default

### No Cursor Rules
No `.cursor/rules/` or `.cursorrules` file found in repository.

### No Copilot Rules
No `.github/copilot-instructions.md` file found in repository.