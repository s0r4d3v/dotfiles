# Quarto Development Environment

## Quick Start

```bash
nix develop .#quarto
```

## Available Tools

-   **Quarto**: Scientific and technical publishing
-   **Jupyter**: Python code execution backend
-   **Matplotlib**: Python plotting library
-   **Pandas**: Python data analysis library

## Usage Examples

```bash
# Create a new document
quarto create

# Render document
quarto render document.qmd

# Preview document
quarto preview document.qmd

# Publish to various formats
quarto render document.qmd --to html
quarto render document.qmd --to pdf
```
