return {
    -- Mason (install LSP/formatters/linters manually via :Mason)
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {},
    },
    -- Bridge: auto-enable LSP servers installed via Mason
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            handlers = {
                function(server_name)
                    vim.lsp.enable(server_name)
                end,
            },
        },
    },
    -- LSP server configs (loaded by vim.lsp.enable via mason-lspconfig handlers)
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
    },
    -- Formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            format_on_save = {
                timeout_ms = 3000,
                lsp_format = "fallback",
            },
            format_after_save = function(bufnr)
                local ft = vim.bo[bufnr].filetype
                if ft == "quarto" or ft == "markdown" then
                    return { lsp_format = "fallback" }
                end
            end,
            formatters_by_ft = {
                nix = { "nixfmt" },
                python = { "ruff_format", "ruff_fix" },
                lua = { "stylua" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier", "injected" },
                quarto = { "prettier", "injected" },
                bash = { "shfmt" },
            },
            formatters = {
                prettier = {
                    options = {
                        ext_parsers = {
                            ipynb = "markdown",
                        },
                    },
                },
            },
        },
    },
    -- Linting
    {
        "mfussenegger/nvim-lint",
        event = { "BufWritePost", "BufReadPost", "InsertLeave" },
        config = function()
            require("lint").linters_by_ft = {
                python = { "ruff" },
                bash = { "shellcheck" },
                nix = { "nix" },
                html = { "htmlhint" },
                css = { "stylelint" },
            }
        end,
    },
    -- Completion
    {
        "saghen/blink.cmp",
        event = "InsertEnter",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
        opts = {
            keymap = { preset = "default" },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                },
            },
            signature = { enabled = true },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "lazydev" },
                providers = {
                    snippets = { opts = { friendly_snippets = true } },
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
        },
    },
    -- Diagnostics
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},
    },
}
