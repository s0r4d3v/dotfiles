# Other Development Environment

## Quick Start

```bash
nix develop .#other
```

## Available Tools

-   **Python 3.13**: Programming language
-   **pip**: Python package installer
-   **virtualenv**: Python virtual environment tool
-   **Pyright**: Python type checker (LSP)
-   **Ruff**: Fast Python linter and formatter

## Usage Examples

```bash
# Create virtual environment
virtualenv venv
source venv/bin/activate

# Install packages
pip install requests flask

# Lint code
ruff check .

# Format code
ruff format .

# Type check
pyright
```
