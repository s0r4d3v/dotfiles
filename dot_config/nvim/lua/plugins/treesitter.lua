return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            highlight = { enable = true },
            ensure_installed = {
                "lua", "nix", "python", "vim", "vimdoc", "bash",
                "json", "yaml", "toml", "markdown", "markdown_inline",
                "javascript", "typescript", "css", "html", "vue",
                "regex", "comment",
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["ib"] = { query = "@code_cell.inner", desc = "in block" },
                        ["ab"] = { query = "@code_cell.outer", desc = "around block" },
                    },
                },
                move = {
                    enable = true,
                    set_jumps = false,
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = { query = "@code_cell.inner", desc = "next code block" },
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = { query = "@code_cell.inner", desc = "previous code block" },
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>sbl"] = "@code_cell.outer",
                    },
                    swap_previous = {
                        ["<leader>sbh"] = "@code_cell.outer",
                    },
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
