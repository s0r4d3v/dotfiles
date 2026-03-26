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
                "htmx",
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
            local lspconfig = require("lspconfig")
            local servers = {
                "lua_ls", "pyright", "ruff", "marksman", "html", "htmx",
                "cssls", "yamlls", "taplo", "jsonls", "bashls",
                "dockerls", "docker_compose_language_service",
                "terraformls", "helm_ls",
            }
            for _, server in ipairs(servers) do
                lspconfig[server].setup({})
            end

            -- Servers not managed by mason (install manually)
            -- unocss: npm i -g unocss-language-server
            if vim.fn.executable("unocss-language-server") == 1 then
                lspconfig.unocss.setup({})
            end
            -- spyglassmc: npm i -g @spyglassmc/language-server
            if vim.fn.executable("spyglassmc-language-server") == 1 then
                lspconfig.spyglassmc_language_server.setup({})
            end
        end,
    },
}
