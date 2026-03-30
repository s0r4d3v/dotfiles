return {
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
    -- gS: split one-liner to multi-line  /  gJ: join to one-liner
    "echasnovski/mini.splitjoin",
    event = "VeryLazy",
    opts = {},
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
        pattern  = { "markdown", "text" },
        callback = function()
          vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>",    { buffer = true })
          vim.keymap.set("n", "o",    "o<cmd>AutolistNewBullet<cr>",       { buffer = true })
          vim.keymap.set("n", "O",    "O<cmd>AutolistNewBulletBefore<cr>", { buffer = true })
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
      vim.keymap.set({ "n", "v" }, "<C-n>",      function() mc.matchAddCursor(1) end,  { desc = "Cursor next match" })
      vim.keymap.set({ "n", "v" }, "<C-p>",      function() mc.matchAddCursor(-1) end, { desc = "Cursor prev match" })
      vim.keymap.set({ "n", "v" }, "<leader>ma", mc.matchAllAddCursors,                { desc = "Cursor all matches" })
      vim.keymap.set("n", "<esc>", function()
        if not mc.cursorsEnabled() then   mc.enableCursors()
        elseif mc.hasCursors() then       mc.clearCursors()
        else vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)
        end
      end)
    end,
  },
  {
    -- Makes . repeat work correctly for plugin operations (surround, etc.)
    "tpope/vim-repeat",
    event = "VeryLazy",
  },
  {
    -- Generate JSDoc / Python docstrings / annotations
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>cn", function() require("neogen").generate() end, desc = "Generate annotation" },
    },
    opts = { snippet_engine = "nvim" }, -- uses vim.snippet (neovim 0.10+ built-in)
  },
}
