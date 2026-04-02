---
name: nix-rebuild
description: Rebuild and switch the Nix/Home Manager dotfiles configuration
---

## What I do

- Run `./switch` from the dotfiles root to rebuild and activate the configuration
- Diagnose and fix common Nix build errors (missing packages, type mismatches, infinite recursion)
- Verify the rebuild succeeded by checking the exit code and output

## When to use me

Use this skill after making changes to any `.nix` file in the dotfiles repo
(`flake.nix`, `home/*.nix`, `darwin/configuration.nix`) and you need to apply
those changes to the running system.
