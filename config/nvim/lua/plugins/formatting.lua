return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
    },
    opts = {
      formatters_by_ft = {
        lua             = { "stylua" },
        python          = { "ruff_format" },
        javascript      = { "prettier" },
        javascriptreact = { "prettier" },
        typescript      = { "prettier" },
        typescriptreact = { "prettier" },
        html            = { "prettier" },
        css             = { "prettier" },
        vue             = { "prettier" },
        json            = { "prettier" },
        yaml            = { "prettier" },
        markdown        = { "prettier" },
        sh              = { "shfmt" },
        nix             = { "nixfmt" },
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
        python          = { "ruff" },
        javascript      = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript      = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        vue             = { "eslint_d" },
        css             = { "stylelint" },
        sh              = { "shellcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        callback = function() lint.try_lint() end,
      })
    end,
  },
}
