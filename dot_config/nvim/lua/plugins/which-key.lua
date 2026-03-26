return {
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
}
