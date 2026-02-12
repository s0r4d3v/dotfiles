{ ... }:
{
  # Neovim keymaps (imported by neovim.nix)
  flake.modules.homeManager.neovim-keymaps = {
    programs.nixvim.keymaps = [
      # ─────────────────────────────────────────────────────────────────────
      # Basic
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<CR>";
        options.desc = "Save";
      }
      {
        mode = "n";
        key = "<leader>W";
        action = "<cmd>wa<CR>";
        options.desc = "Save All";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<CR>";
        options.desc = "Quit";
      }
      {
        mode = "n";
        key = "<leader>Q";
        action = "<cmd>qa!<CR>";
        options.desc = "Force Quit All";
      }
      {
        mode = "i";
        key = "jj";
        action = "<Esc>";
        options.desc = "Exit Insert and Clear Highlight";
      }
      {
        mode = [ "n" ];
        key = "<Esc>";
        action = ":nohl<CR>";
        options = {
          silent = true;
          desc = "Clear Highlight";
        };
      }

      # ─────────────────────────────────────────────────────────────────────
      # Windows
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Window Left";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Window Down";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Window Up";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Window Right";
      }
      {
        mode = "n";
        key = "<leader>sv";
        action = "<cmd>vsplit<CR>";
        options.desc = "Split Vertical";
      }
      {
        mode = "n";
        key = "<leader>sh";
        action = "<cmd>split<CR>";
        options.desc = "Split Horizontal";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Buffers
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<CR>";
        options.desc = "Prev Buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<CR>";
        options.desc = "Next Buffer";
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>lua MiniBufremove.delete()<CR>";
        options.desc = "Delete Buffer";
      }
      {
        mode = "n";
        key = "<leader>bo";
        action = "<cmd>lua MiniBufremove.wipeout()<CR>";
        options.desc = "Wipeout Buffer";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Editing
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options.desc = "Move Down";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options.desc = "Move Up";
      }
      {
        mode = "n";
        key = "x";
        action = "\"_x";
        options.desc = "Delete char (blackhole)";
      }
      {
        mode = "v";
        key = "x";
        action = "\"_x";
        options.desc = "Delete selection (blackhole)";
      }

      # ─────────────────────────────────────────────────────────────────────
      # LSP
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
        options.desc = "Definition";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<CR>";
        options.desc = "References";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        options.desc = "Hover";
      }
      {
        mode = "n";
        key = "<leader>la";
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        options.desc = "Code Action";
      }
      {
        mode = "n";
        key = "<leader>ln";
        action = "<cmd>lua vim.lsp.buf.rename()<CR>";
        options.desc = "Rename";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Trouble (x = diagnostics)
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<CR>";
        options.desc = "Diagnostics";
      }
      {
        mode = "n";
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
        options.desc = "Buffer Diagnostics";
      }
      {
        mode = "n";
        key = "<leader>xs";
        action = "<cmd>Trouble symbols toggle focus=false<CR>";
        options.desc = "Symbols";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Find (f = find)
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>lua Snacks.picker.files()<CR>";
        options.desc = "Files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>lua Snacks.picker.grep()<CR>";
        options.desc = "Grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>lua Snacks.picker.buffers()<CR>";
        options.desc = "Buffers";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>lua Snacks.picker.help()<CR>";
        options.desc = "Help";
      }
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>lua Snacks.picker.recent()<CR>";
        options.desc = "Recent";
      }
      {
        mode = "n";
        key = "<leader>/";
        action = "<cmd>lua Snacks.picker.lines()<CR>";
        options.desc = "Search Buffer";
      }
      {
        mode = "n";
        key = "<leader>?";
        action = "<cmd>WhichKey<CR>";
        options.desc = "Which Key";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Git (g = git)
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>lua Snacks.lazygit()<CR>";
        options.desc = "Lazygit";
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>lua Snacks.git.blame_line()<CR>";
        options.desc = "Blame";
      }
      {
        mode = "n";
        key = "<leader>gB";
        action = "<cmd>lua Snacks.gitbrowse()<CR>";
        options.desc = "Browse";
      }
      {
        mode = "n";
        key = "]c";
        action = "<cmd>lua require('gitsigns').next_hunk()<CR>";
        options.desc = "Next Hunk";
      }
      {
        mode = "n";
        key = "[c";
        action = "<cmd>lua require('gitsigns').prev_hunk()<CR>";
        options.desc = "Prev Hunk";
      }
      {
        mode = "n";
        key = "<leader>hs";
        action = "<cmd>lua require('gitsigns').stage_hunk()<CR>";
        options.desc = "Stage Hunk";
      }
      {
        mode = "n";
        key = "<leader>hr";
        action = "<cmd>lua require('gitsigns').reset_hunk()<CR>";
        options.desc = "Reset Hunk";
      }
      {
        mode = "n";
        key = "<leader>hp";
        action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
        options.desc = "Preview Hunk";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Flash (motion)
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "s";
        action = "<cmd>lua require('flash').jump()<CR>";
        options.desc = "Flash";
      }
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "S";
        action = "<cmd>lua require('flash').treesitter()<CR>";
        options.desc = "Flash Treesitter";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Undo Tree
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<leader>u";
        action = "<cmd>UndotreeToggle<CR>";
        options.desc = "Undo Tree";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Comments
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "]t";
        action = "<cmd>lua require('todo-comments').jump_next()<CR>";
        options.desc = "Next Todo";
      }
      {
        mode = "n";
        key = "[t";
        action = "<cmd>lua require('todo-comments').jump_prev()<CR>";
        options.desc = "Prev Todo";
      }

      # ─────────────────────────────────────────────────────────────────────
      # Markdown
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "<leader>mp";
        action = "<cmd>MarkdownPreview<CR>";
        options.desc = "Markdown Preview";
      }

      # ─────────────────────────────────────────────────────────────────────
      # File explorer
      # ─────────────────────────────────────────────────────────────────────
      {
        mode = "n";
        key = "\\";
        action = "<cmd>Yazi<CR>";
        options.desc = "Yazi";
      }
    ];
  };
}
