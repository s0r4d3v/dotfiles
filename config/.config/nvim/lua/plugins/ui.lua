return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy     = false,
    keys = {
      { "<leader>go", function() Snacks.gitbrowse() end, mode = { "n", "v" }, desc = "Git browse" },
      { "<leader>sd", function() Snacks.dashboard() end,                      desc = "Dashboard" },
    },
    opts = {
      indent    = { enabled = true },
      scroll    = { enabled = true },
      words     = { enabled = true },
      gitbrowse = { enabled = true },
      dashboard = {
        enabled = true,
        preset  = {
          header = [[
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
          keys = {
            { icon = " ", key = "f", desc = "Find File",       action = function() require("fzf-lua").files() end },
            { icon = " ", key = "g", desc = "Live Grep",       action = function() require("fzf-lua").live_grep() end },
            { icon = " ", key = "r", desc = "Recent Files",    action = function() require("fzf-lua").oldfiles() end },
            { icon = " ", key = "s", desc = "Restore Session", action = function() require("persistence").load() end },
            { icon = " ", key = "l", desc = "Lazy",            action = ":Lazy" },
            { icon = "󰒲 ", key = "u", desc = "Update Plugins", action = ":Lazy update" },
            { icon = " ", key = "q", desc = "Quit",            action = ":qa" },
          },
        },
      },
    },
  },
  {
    -- Inline CSS/hex/rgb/hsl color preview
    "NvChad/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      user_default_options = {
        css      = true,
        css_fn   = true,
        tailwind = true,
        mode     = "background",
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen mode" },
    },
    opts = { window = { width = 0.85 } },
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
        { "<leader>b",  group = "Buffer" },
        { "<leader>c",  group = "Code" },
        { "<leader>f",  group = "Find / Search" },
        { "<leader>g",  group = "Git" },
        { "<leader>m",  group = "Multicursor" },
        { "<leader>s",  group = "UI / View" },
        { "<leader>S",  group = "Session" },
        { "<leader>x",  group = "Diagnostics" },
        -- Standalone
        { "<leader>a",  desc = "Harpoon: add file" },
        { "<leader>e",  desc = "Explorer" },
        { "<leader>q",  desc = "Quit" },
        { "<leader>w",  desc = "Save" },
        { "<leader>z",  desc = "Zen mode" },
        { "<leader>1",  desc = "Harpoon: jump 1" },
        { "<leader>2",  desc = "Harpoon: jump 2" },
        { "<leader>3",  desc = "Harpoon: jump 3" },
        { "<leader>4",  desc = "Harpoon: jump 4" },
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
          ["vim.lsp.util.stylize_markdown"]                = true,
          ["cmp.entry.get_documentation"]                  = true,
        },
      },
      presets = {
        bottom_search        = true,
        command_palette      = true,
        long_message_to_split = true,
      },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "Diagnostics" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
    },
    opts = {},
  },
}
