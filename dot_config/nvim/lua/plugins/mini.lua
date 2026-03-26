return {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
        require("mini.icons").setup()
        require("mini.surround").setup()
        -- Mock nvim-web-devicons with mini.icons
        MiniIcons.mock_nvim_web_devicons()
    end,
}
