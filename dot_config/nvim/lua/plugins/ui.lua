return {
    -- Theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            flavour = "macchiato",
            term_colors = true,
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                theme = "catppuccin",
            },
        },
    },
    -- Bufferline
    {
        "akinsho/bufferline.nvim",
        event = "VeryLazy",
        dependencies = { "echasnovski/mini.icons" },
        opts = {},
    },
    -- Which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            spec = {
                { "<leader>f", group = "Find" },
                { "<leader>g", group = "Git", icon = " " },
                { "<leader>b", group = "Buffer" },
                { "<leader>x", group = "Diagnostics" },
                { "<leader>m", group = "Molten" },
                { "<leader>mo", group = "Output" },
                { "<leader>mr", group = "Run" },
                { "<leader>sb", group = "Swap Block" },
                { "<localleader>r", group = "Run Cell" },
                { "<localleader>R", group = "Run All" },
            },
        },
    },
    -- TODO highlights
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
    },
    -- Markdown rendering
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "quarto" },
        opts = {},
    },
}
