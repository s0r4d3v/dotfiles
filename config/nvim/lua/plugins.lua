return {

  -- ===========================================================================
  -- Colorscheme
  -- ===========================================================================
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight-night")
    end,
  },

  -- ===========================================================================
  -- Fuzzy Finder
  -- ===========================================================================
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>",       desc = "Find files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>",   desc = "Live grep" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>",     desc = "Buffers" },
      { "<leader>fr", "<cmd>FzfLua oldfiles<cr>",    desc = "Recent files" },
      { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Diagnostics" },
    },
    opts = {},
  },

  -- ===========================================================================
  -- File Explorer
  -- ===========================================================================
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "Open file explorer" },
    },
    opts = {
      default_file_explorer = true,
      view_options = { show_hidden = true },
    },
  },

  -- ===========================================================================
  -- Treesitter
  -- ===========================================================================
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua", "python", "bash", "go", "typescript", "javascript",
          "json", "yaml", "toml", "markdown", "markdown_inline",
        },
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
            goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          },
        },
      })
    end,
  },

  -- ===========================================================================
  -- LSP
  -- ===========================================================================
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "lua_ls", "pyright", "bashls" },
      automatic_enable = true,
    },
  },
  {
    "neovim/nvim-lspconfig",  -- provides default server configs (cmd, root_dir, etc.)
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    config = function()
      -- lua_ls needs custom settings; pyright/bashls use nvim-lspconfig defaults
      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })
      -- automatic_enable = true in mason-lspconfig calls vim.lsp.enable() for installed servers
    end,
  },

  -- ===========================================================================
  -- Completion
  -- ===========================================================================
  {
    "saghen/blink.cmp",
    version = "*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = { preset = "default" },
      appearance = { use_nvim_cmp_as_default = false },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },

  -- ===========================================================================
  -- Formatting & Linting  (conform + nvim-lint; none-ls is unmaintained)
  -- ===========================================================================
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
    },
    opts = {
      formatters_by_ft = {
        lua        = { "stylua" },
        python     = { "ruff_format" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json       = { "prettier" },
        yaml       = { "prettier" },
        markdown   = { "prettier" },
        sh         = { "shfmt" },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python     = { "ruff" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        sh         = { "shellcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        callback = function() lint.try_lint() end,
      })
    end,
  },

  -- ===========================================================================
  -- Git
  -- ===========================================================================
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>gh", "<cmd>Gitsigns preview_hunk<cr>",  desc = "Preview hunk" },
      { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>",    desc = "Stage hunk" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",    desc = "Reset hunk" },
      { "<leader>gb", "<cmd>Gitsigns blame_line<cr>",    desc = "Blame line" },
    },
    opts = {},
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Diff view" },
      { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    },
    opts = {},
  },

  -- ===========================================================================
  -- Navigation
  -- ===========================================================================
  {
    -- Seamless C-hjkl navigation between nvim windows and tmux panes.
    -- tmux config sends C-hjkl to nvim when nvim is active; Navigator handles the rest.
    "numToStr/Navigator.nvim",
    config = function()
      require("Navigator").setup()
      vim.keymap.set({ "n", "t" }, "<C-h>", "<CMD>NavigatorLeft<CR>")
      vim.keymap.set({ "n", "t" }, "<C-j>", "<CMD>NavigatorDown<CR>")
      vim.keymap.set({ "n", "t" }, "<C-k>", "<CMD>NavigatorUp<CR>")
      vim.keymap.set({ "n", "t" }, "<C-l>", "<CMD>NavigatorRight<CR>")
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end,                         { desc = "Harpoon add" })
      vim.keymap.set("n", "<C-e>",     function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })
    end,
  },

  -- ===========================================================================
  -- Editing
  -- ===========================================================================
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = {},
  },
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s",     function() require("flash").jump() end,              mode = { "n", "x", "o" }, desc = "Flash jump" },
      { "S",     function() require("flash").treesitter() end,        mode = { "n", "x", "o" }, desc = "Flash treesitter" },
      { "r",     function() require("flash").remote() end,            mode = "o",               desc = "Flash remote" },
      { "<c-s>", function() require("flash").toggle() end,            mode = "c",               desc = "Toggle flash search" },
    },
  },
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    -- Continue bullet/numbered list on <CR> or o/O
    "gaoDean/autolist.nvim",
    ft = { "markdown", "text" },
    config = function()
      require("autolist").setup()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "text" },
        callback = function()
          vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>",       { buffer = true })
          vim.keymap.set("n", "o",    "o<cmd>AutolistNewBullet<cr>",          { buffer = true })
          vim.keymap.set("n", "O",    "O<cmd>AutolistNewBulletBefore<cr>",    { buffer = true })
        end,
      })
    end,
  },
  {
    "jake-stewart/multicursor.nvim",
    event = "VeryLazy",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
      vim.keymap.set({ "n", "v" }, "<C-n>",     function() mc.matchAddCursor(1) end,  { desc = "Cursor next match" })
      vim.keymap.set({ "n", "v" }, "<C-p>",     function() mc.matchAddCursor(-1) end, { desc = "Cursor prev match" })
      vim.keymap.set({ "n", "v" }, "<leader>ma", mc.matchAllAddCursors,               { desc = "Cursor all matches" })
      vim.keymap.set("n", "<esc>", function()
        if not mc.cursorsEnabled() then     mc.enableCursors()
        elseif mc.hasCursors() then         mc.clearCursors()
        else vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
        end
      end)
    end,
  },

  -- ===========================================================================
  -- Search & Replace
  -- ===========================================================================
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      { "<leader>fR", "<cmd>GrugFar<cr>", desc = "Replace in project" },
    },
    opts = {},
  },

  -- ===========================================================================
  -- Markdown
  -- ===========================================================================
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {},
  },

  -- ===========================================================================
  -- Session
  -- ===========================================================================
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    keys = {
      { "<leader>Ss", function() require("persistence").load() end,               desc = "Restore session" },
      { "<leader>Sl", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>Sd", function() require("persistence").stop() end,               desc = "Don't save session" },
    },
    opts = {},
  },

  -- ===========================================================================
  -- UI
  -- ===========================================================================
  {
    -- Bundle: indent guides, smooth scroll, word highlight, and more
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      { "<leader>go", function() Snacks.gitbrowse() end, mode = { "n", "v" }, desc = "Git browse (open in browser)" },
    },
    opts = {
      indent     = { enabled = true },
      scroll     = { enabled = true },
      words      = { enabled = true },
      gitbrowse  = { enabled = true },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    keys = {
      { "<leader>ft", "<cmd>TodoFzfLua<cr>", desc = "Todo comments" },
    },
    opts = {},
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { theme = "tokyonight" } },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({ preset = "modern" })
      wk.add({
        -- Groups
        { "<leader>f",  group = "Find / Search" },
        { "<leader>g",  group = "Git" },
        { "<leader>c",  group = "Code" },
        { "<leader>x",  group = "Diagnostics" },
        { "<leader>S",  group = "Session" },
        -- Standalone
        { "<leader>w",  desc = "Save" },
        { "<leader>q",  desc = "Quit" },
        { "<leader>e",  desc = "Explorer" },
        { "<leader>a",  desc = "Harpoon: add file" },
        { "<leader>1",  desc = "Harpoon: jump 1" },
        { "<leader>2",  desc = "Harpoon: jump 2" },
        { "<leader>3",  desc = "Harpoon: jump 3" },
        { "<leader>4",  desc = "Harpoon: jump 4" },
        { "<leader>ma", desc = "Cursor: add to all matches" },
      })
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",          desc = "Diagnostics" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
    },
    opts = {},
  },

}
