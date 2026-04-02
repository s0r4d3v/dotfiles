# Starship Prompt

The shell prompt is powered by [Starship](https://starship.rs) with a Tokyo Night-inspired color palette. Configuration lives in `config/.config/starship.toml`.

## Layout

```
 📁 …/dotfiles  main a1b2c3d ⇡1 +3 !1 ?2 +42 -7 🕐 14:30
❯
```

| Segment | Color | Description |
|---------|-------|-------------|
| OS icon (e.g. ``) | `#c0caf5` (fg) | Auto-detected OS |
| `📁 path` | `#769ff0` (blue) | Current directory (truncated to 3 levels) |
| ` branch` | `#bb9af7` (magenta) | Git branch (with remote tracking if applicable) |
| `hash` | `#bb9af7` (magenta) | Short commit hash (7 chars) |
| Git status | `#bb9af7` (magenta) | Per-type counts (see below) |
| `+added` / `-deleted` | `#9ece6a` / `#f7768e` | Line-level diff stats (git metrics) |
| Language versions | `#a0a9cb` (dim) | Node.js, Python, Rust, Go (context-dependent) |
| `❄️ state` | `#7dcfff` (cyan) | Nix shell indicator |
| `🕐 HH:MM` | `#565f89` (dimmer) | Current local time |
| `❯` | green / red | Prompt character (green on success, red on error) |

## Git Status Symbols

Each symbol only appears when that type of change is present. The number after the symbol is the count.

| Symbol | Meaning | Example |
|--------|---------|---------|
| `⇡N` | Ahead of remote by N commits | `⇡3` |
| `⇣N` | Behind remote by N commits | `⇣2` |
| `⇡N⇣M` | Diverged (N ahead, M behind) | `⇡1⇣2` |
| `=N` | Merge/rebase conflicts | `=1` |
| `*N` | Stash entries | `*2` |
| `+N` | Staged files | `+3` |
| `!N` | Modified (unstaged) files | `!5` |
| `»N` | Renamed files | `»1` |
| `✘N` | Deleted files | `✘2` |
| `?N` | Untracked files | `?4` |

## Git Metrics

Displayed after the status symbols, showing line-level diff stats for the current working tree:

- `+42` (green) — lines added
- `-7` (red) — lines deleted

## Tags

When HEAD points to a tagged commit, it appears after the hash:

```
 main a1b2c3d 🏷 v1.0.0
```

## Language Versions

Language modules only appear when relevant files are detected in the current directory:

| Emoji | Language | Detected by |
|-------|----------|-------------|
| `📦` | Node.js | `package.json`, `.nvmrc`, etc. |
| `🐍` | Python | `pyproject.toml`, `requirements.txt`, `.py`, etc. |
| `🦀` | Rust | `Cargo.toml` |
| `🐹` | Go | `go.mod` |

## Customization

Edit `config/.config/starship.toml` and run `./switch` to apply. Changes take effect in new shell sessions immediately after activation.

Refer to the [Starship configuration docs](https://starship.rs/config/) for all available modules and options.
