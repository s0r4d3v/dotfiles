# Keybindings

## Tmux (`prefix` = `Ctrl+A`)

### Popups
| Key | Action |
|-----|--------|
| `prefix + t` | Floating terminal (current dir) |
| `prefix + g` | Lazygit popup (current dir) |
| `prefix + f` | fzf file picker → open in nvim |

### Panes & windows
| Key | Action |
|-----|--------|
| `prefix + -` | Split horizontal |
| `prefix + \` | Split vertical |
| `C-h/j/k/l` | Move between panes / nvim windows |
| `prefix + r` | Reload tmux config |

### Copy mode (vi)
| Key | Action |
|-----|--------|
| `prefix + v` | Enter copy mode |
| `v` | Begin selection |
| `V` | Select line |
| `y` | Copy selection |

---

## Zsh

| Key | Action |
|-----|--------|
| `Esc` | Vi normal mode |
| `v` (normal mode) | Edit command in `$EDITOR` |
| `Ctrl+R` | fzf history search |
| `Ctrl+T` | fzf file insert at cursor |
| `Alt+C` | fzf cd into subdirectory |
| `↑` / `↓` | History search by substring |
| `Tab` | fzf completion menu |

---

## Neovim (`<leader>` = `Space`)

### Find
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recent files |
| `<leader>fd` | Diagnostics |
| `<leader>ft` | Todo comments |
| `<leader>fR` | Search & replace (grug-far) |

### Git
| Key | Action |
|-----|--------|
| `<leader>gg` | Lazygit |
| `<leader>gd` | Diff view |
| `<leader>gH` | File history |
| `<leader>gh` | Preview hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gb` | Blame line |
| `<leader>go` | Open in browser |

### Code
| Key | Action |
|-----|--------|
| `<leader>cf` | Format buffer |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>cs` | Symbol outline |
| `<leader>cn` | Generate annotation |
| `<leader>cd` | Diagnostic float |
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover |
| `[d` / `]d` | Prev/next diagnostic |

### Buffer & window
| Key | Action |
|-----|--------|
| `<leader>bd` | Close buffer |
| `[b` / `]b` | Prev/next buffer |
| `<leader>e` | File explorer |
| `<leader>w` | Save |
| `<leader>q` | Quit |

### Quickfix
| Key | Action |
|-----|--------|
| `<leader>xx` | Diagnostics list |
| `<leader>xb` | Buffer diagnostics |
| `<leader>xq` | Open quickfix |
| `[q` / `]q` | Prev/next quickfix |

### Navigation
| Key | Action |
|-----|--------|
| `s` | Flash jump |
| `S` | Flash treesitter |
| `<leader>a` | Harpoon add |
| `<C-e>` | Harpoon menu |
| `<leader>1-4` | Harpoon jump 1-4 |
| `{` / `}` | Prev/next symbol (aerial) |

### UI
| Key | Action |
|-----|--------|
| `<leader>z` | Zen mode |
| `<leader>sd` | Dashboard |
| `<leader>Ss` | Restore session |
| `<leader>Sl` | Restore last session |
