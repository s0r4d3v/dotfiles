# Python Development Environment

## Quick Start

```bash
nix develop .#python
```

## Available Tools

-   **Jupyter**: Interactive notebooks
-   **uv**: Fast Python package installer
-   **Marimo**: Reactive notebooks (installed via uv)

## Usage Examples

```bash
# Install additional packages
uv pip install numpy pandas

# Start Jupyter notebook
jupyter notebook

# Run Marimo
marimo edit

# Activate virtual environment (auto-activated on shell entry)
source venv/bin/activate
```
