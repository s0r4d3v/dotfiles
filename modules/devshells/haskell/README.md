# Haskell Development Environment

## Quick Start

```bash
nix develop .#hask
```

## Available Tools

-   **GHC**: Glasgow Haskell Compiler
-   **Haskell Language Server**: LSP for IDE support
-   **HLint**: Haskell linter
-   **Ormolu**: Haskell code formatter
-   **Cabal**: Haskell build tool

## Usage Examples

```bash
# Create a new project
cabal init

# Build project
cabal build

# Run tests
cabal test

# Format code
ormolu --mode inplace $(find . -name "*.hs")

# Lint code
hlint .



```
