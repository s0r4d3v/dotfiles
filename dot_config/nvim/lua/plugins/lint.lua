return {
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
}
