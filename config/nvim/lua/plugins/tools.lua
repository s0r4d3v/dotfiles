return {
  {
    "MagicDuck/grug-far.nvim",
    keys = {
      { "<leader>fR", "<cmd>GrugFar<cr>", desc = "Replace in project" },
    },
    opts = {},
  },
  {
    -- Better quickfix: preview pane, fzf filtering, <Tab> to select entries
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {},
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {},
  },
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
}
