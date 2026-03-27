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
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "python", "bash", "go", "typescript", "javascript",
          "json", "yaml", "toml", "markdown", "markdown_inline",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup({
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
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = { "lua_ls", "pyright", "bashls" },
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      require("mason-lspconfig").setup_handlers({
        function(server)
          require("lspconfig")[server].setup({})
        end,
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup({
            settings = {
              Lua = { diagnostics = { globals = { "vim" } } },
            },
          })
        end,
      })
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

  -- ===========================================================================
  -- UI
  -- ===========================================================================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { theme = "tokyonight" } },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
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
