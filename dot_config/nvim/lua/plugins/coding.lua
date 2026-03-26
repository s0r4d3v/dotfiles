return {
    -- Mason
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = {
                "lua_ls",
                "pyright",
                "ruff",
                "marksman",
                "html",
                "cssls",
                "yamlls",
                "taplo",
                "jsonls",
                "bashls",
                "dockerls",
                "docker_compose_language_service",
                "terraformls",
                "helm_ls",
            },
            automatic_installation = true,
        },
    },
    -- LSP
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local servers = {
                "lua_ls", "pyright", "ruff", "marksman", "html",
                "cssls", "yamlls", "taplo", "jsonls", "bashls",
                "dockerls", "docker_compose_language_service",
                "terraformls", "helm_ls",
            }
            for _, server in ipairs(servers) do
                vim.lsp.config(server, {})
                vim.lsp.enable(server)
            end

            -- Servers not managed by mason (install manually)
            -- unocss: npm i -g unocss-language-server
            if vim.fn.executable("unocss-language-server") == 1 then
                vim.lsp.config("unocss", {})
                vim.lsp.enable("unocss")
            end
            -- spyglassmc: npm i -g @spyglassmc/language-server
            if vim.fn.executable("spyglassmc-language-server") == 1 then
                vim.lsp.config("spyglassmc_language_server", {})
                vim.lsp.enable("spyglassmc_language_server")
            end
        end,
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
