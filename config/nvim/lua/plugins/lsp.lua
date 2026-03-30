return {
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
    -- JSON/YAML schema catalog
    "b0o/SchemaStore.nvim",
    lazy = true,
  },
  {
    -- All LSP servers are installed via Nix (home.packages in shared.nix).
    -- This file only configures custom settings and enables servers.
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim" },
    config = function()
      -- Custom settings (servers without custom settings use lspconfig defaults)
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
      -- spyglassmc has no nixpkgs package; launch via npx (nodejs is in home.packages)
      vim.lsp.config("spyglassmc_language_server", {
        cmd = { "npx", "--yes", "@spyglassmc/language-server" },
      })

      -- Enable all servers
      vim.lsp.enable({
        "lua_ls",
        "pyright",
        "bashls",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        "vue_ls",
        "nixd",
        "spyglassmc_language_server",
      })
    end,
  },
}
