# Development environment (devenv)

Use `devenv` for project environments and `direnv` only as an auto-activate trigger.

Quick steps:

1. Initialize:

```
devenv init
```

2. Allow direnv:

```
direnv allow
```

3. Enter project (auto-activates):

```
cd ~/projects/myproject
```

Files created: `flake.nix`, `devenv.nix`, `.envrc` (`.envrc` contains `use devenv`).
