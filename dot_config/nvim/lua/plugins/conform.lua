return {
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
}
