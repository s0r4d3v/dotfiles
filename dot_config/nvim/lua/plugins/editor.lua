return {
    -- Motion
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        },
    },
    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    -- Mini (icons + surround)
    {
        "echasnovski/mini.nvim",
        event = "VeryLazy",
        config = function()
            require("mini.icons").setup()
            require("mini.surround").setup()
            MiniIcons.mock_nvim_web_devicons()
        end,
    },
    -- File explorer
    {
        "mikavilpas/yazi.nvim",
        event = "VeryLazy",
        opts = {
            enable_mouse_support = false,
        },
    },
    -- Tmux navigation
    {
        "christoomey/vim-tmux-navigator",
        event = "VeryLazy",
    },
    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
    },
}
