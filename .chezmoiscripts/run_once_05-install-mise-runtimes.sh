#!/bin/sh
# Install default runtimes via mise
export PATH="$HOME/.local/bin:$PATH"
if command -v mise >/dev/null 2>&1; then
    mise install node@lts
    mise install python@latest
else
    echo "mise not found — skipping runtime install (run after brew install mise)"
fi
