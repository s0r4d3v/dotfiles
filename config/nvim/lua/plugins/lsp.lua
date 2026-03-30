return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",                     -- Lua
        "pyright",                    -- Python
        "bashls",                     -- Shell
        "ts_ls",                      -- TypeScript / JavaScript
        "html",                       -- HTML
        "cssls",                      -- CSS
        "jsonls",                     -- JSON
        "yamlls",                     -- YAML
        "vue_ls",                     -- Vue / Slidev (formerly "volar")
        "spyglassmc_language_server", -- mcfunction (Minecraft datapacks)
        -- nixd: installed via Nix (home.packages), enabled below via vim.lsp.enable
      },
      automatic_enable = true,
    },
  },
  {
    -- Auto-installs formatters and linters that Mason doesn't handle via mason-lspconfig
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",     -- Lua formatter
        "prettier",   -- JS/TS/HTML/CSS/Vue/JSON/YAML/Markdown formatter
        "shfmt",      -- Shell formatter
        "ruff",       -- Python linter
        "eslint_d",   -- JS/TS/Vue linter
        "shellcheck", -- Shell linter
        "stylelint",  -- CSS linter
        -- nixfmt is installed via Nix (home.packages), not Mason
      },
    },
  },
  {
    -- Lua LSP enhancements for editing neovim config (replaces neodev.nvim)
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    -- JSON/YAML schema catalog (plugs into jsonls + yamlls)
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim", "b0o/SchemaStore.nvim" },
    config = function()
      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })
      vim.lsp.config("nixd", {
        settings = { nixd = { formatting = { command = { "nixfmt" } } } },
      })
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas  = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore = { enable = false, url = "" },
            schemas     = require("schemastore").yaml.schemas(),
          },
        },
      })
      vim.lsp.enable("nixd") -- nixd installed via Nix, not mason
    end,
  },
}
