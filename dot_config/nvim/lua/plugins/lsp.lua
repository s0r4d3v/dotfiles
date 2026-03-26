return {
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
}
