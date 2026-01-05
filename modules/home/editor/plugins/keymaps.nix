{ ... }:
{
  # Neovim keymaps (imported by neovim.nix)
  flake.modules.homeManager.neovim-keymaps = {
    programs.nixvim.keymaps = [
      # ─────────────────────────────────────────────────────────────────────
      # Basic
      # ─────────────────────────────────────────────────────────────────────
      { mode = "n"; key = "<leader>w"; action = "<cmd>w<cr>"; options.desc = "Save"; }
      { mode = "n"; key = "<leader>q"; action = "<cmd>q<cr>"; options.desc = "Quit"; }
      { mode = "n"; key = "<leader>Q"; action = "<cmd>qa!<cr>"; options.desc = "Force Quit All"; }
      { mode = "n"; key = "<Esc>"; action = "<cmd>noh<cr>"; options.desc = "Clear Highlight"; }

      # ─────────────────────────────────────────────────────────────────────
      # Windows
      # ─────────────────────────────────────────────────────────────────────
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Window Left"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Window Down"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Window Up"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Window Right"; }
      { mode = "n"; key = "<leader>sv"; action = "<cmd>vsplit<cr>"; options.desc = "Split Vertical"; }
      { mode = "n"; key = "<leader>sh"; action = "<cmd>split<cr>"; options.desc = "Split Horizontal"; }

      # ─────────────────────────────────────────────────────────────────────
      # Buffers
      # ─────────────────────────────────────────────────────────────────────
      { mode = "n"; key = "<S-h>"; action = "<cmd>bprevious<cr>"; options.desc = "Prev Buffer"; }
      { mode = "n"; key = "<S-l>"; action = "<cmd>bnext<cr>"; options.desc = "Next Buffer"; }
      { mode = "n"; key = "<leader>bd"; action = "<cmd>lua MiniBufremove.delete()<cr>"; options.desc = "Delete Buffer"; }

      # ─────────────────────────────────────────────────────────────────────
      # Editing
      # ─────────────────────────────────────────────────────────────────────
      { mode = "v"; key = "J"; action = ":m '>+1<cr>gv=gv"; options.desc = "Move Down"; }
      { mode = "v"; key = "K"; action = ":m '<-2<cr>gv=gv"; options.desc = "Move Up"; }

      # ─────────────────────────────────────────────────────────────────────
      # LSP
      # ─────────────────────────────────────────────────────────────────────
      { mode = "n"; key = "gd"; action = "<cmd>lua vim.lsp.buf.definition()<cr>"; options.desc = "Definition"; }
      { mode = "n"; key = "gr"; action = "<cmd>lua vim.lsp.buf.references()<cr>"; options.desc = "References"; }
      { mode = "n"; key = "K"; action = "<cmd>lua vim.lsp.buf.hover()<cr>"; options.desc = "Hover"; }
      { mode = "n"; key = "<leader>la"; action = "<cmd>lua vim.lsp.buf.code_action()<cr>"; options.desc = "Code Action"; }
      { mode = "n"; key = "<leader>ln"; action = "<cmd>lua vim.lsp.buf.rename()<cr>"; options.desc = "Rename"; }
      { mode = "n"; key = "<leader>lf"; action = "<cmd>lua require('conform').format()<cr>"; options.desc = "Format"; }

      # ─────────────────────────────────────────────────────────────────────
      # Trouble (x = diagnostics)
      # ─────────────────────────────────────────────────────────────────────
      { mode = "n"; key = "<leader>xx"; action = "<cmd>Trouble diagnostics toggle<cr>"; options.desc = "Diagnostics"; }
      { mode = "n"; key = "<leader>xX"; action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>"; options.desc = "Buffer Diagnostics"; }
      { mode = "n"; key = "<leader>xs"; action = "<cmd>Trouble symbols toggle focus=false<cr>"; options.desc = "Symbols"; }

      # ─────────────────────────────────────────────────────────────────────
      # Find (f = find)
      # ─────────────────────────────────────────────────────────────────────
      { mode = "n"; key = "<leader>ff"; action = "<cmd>lua Snacks.picker.files()<cr>"; options.desc = "Files"; }
      { mode = "n"; key = "<leader>fg"; action = "<cmd>lua Snacks.picker.grep()<cr>"; options.desc = "Grep"; }
      { mode = "n"; key = "<leader>fb"; action = "<cmd>lua Snacks.picker.buffers()<cr>"; options.desc = "Buffers"; }
      { mode = "n"; key = "<leader>fh"; action = "<cmd>lua Snacks.picker.help()<cr>"; options.desc = "Help"; }
      { mode = "n"; key = "<leader>fr"; action = "<cmd>lua Snacks.picker.recent()<cr>"; options.desc = "Recent"; }
      { mode = "n"; key = "<leader>/"; action = "<cmd>lua Snacks.picker.lines()<cr>"; options.desc = "Search Buffer"; }

      # ─────────────────────────────────────────────────────────────────────
      # Git (g = git)
      # ─────────────────────────────────────────────────────────────────────
      { mode = "n"; key = "<leader>gg"; action = "<cmd>lua Snacks.lazygit()<cr>"; options.desc = "Lazygit"; }
      { mode = "n"; key = "<leader>gb"; action = "<cmd>lua Snacks.git.blame_line()<cr>"; options.desc = "Blame"; }
      { mode = "n"; key = "<leader>gB"; action = "<cmd>lua Snacks.gitbrowse()<cr>"; options.desc = "Browse"; }

      # ─────────────────────────────────────────────────────────────────────
      # Terminal (t = terminal)
      # ─────────────────────────────────────────────────────────────────────
      { mode = "n"; key = "<leader>tt"; action = "<cmd>lua Snacks.terminal()<cr>"; options.desc = "Terminal"; }
      { mode = "t"; key = "<Esc><Esc>"; action = "<C-\\><C-n>"; options.desc = "Exit Terminal"; }

      # ─────────────────────────────────────────────────────────────────────
      # Flash (motion)
      # ─────────────────────────────────────────────────────────────────────
      { mode = [ "n" "x" "o" ]; key = "s"; action = "<cmd>lua require('flash').jump()<cr>"; options.desc = "Flash"; }
      { mode = [ "n" "x" "o" ]; key = "S"; action = "<cmd>lua require('flash').treesitter()<cr>"; options.desc = "Flash Treesitter"; }

      # ─────────────────────────────────────────────────────────────────────
      # File explorer
      # ─────────────────────────────────────────────────────────────────────
      { mode = "n"; key = "\\"; action = "<cmd>Oil<cr>"; options.desc = "Oil"; }
    ];
  };
}
