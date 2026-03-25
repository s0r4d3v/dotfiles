#!/bin/sh
# Install extras: gh-notify extension + pokemon-colorscripts

# ── gh-notify extension ────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
if command -v gh >/dev/null 2>&1; then
    gh extension list 2>/dev/null | grep -q "gh-notify" || \
        gh extension install meiji163/gh-notify
fi

# ── pokemon-colorscripts ───────────────────────────────────────────────────────
if ! command -v pokemon-colorscripts >/dev/null 2>&1; then
    TMPDIR=$(mktemp -d)
    git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git "$TMPDIR/pokemon-colorscripts"
    cd "$TMPDIR/pokemon-colorscripts" && sudo ./install.sh
    rm -rf "$TMPDIR"
fi
