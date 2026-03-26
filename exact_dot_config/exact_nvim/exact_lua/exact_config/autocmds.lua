-- Filetype-specific indentation
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "nix", "lua", "javascript", "typescript", "vue", "markdown", "quarto", "html", "css", "yaml", "json" },
    command = "setlocal shiftwidth=2 tabstop=2 softtabstop=2",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- Lint on events
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "LspAttach" }, {
    pattern = "*",
    callback = function()
        require("lint").try_lint()
    end,
})

-- Activate Quarto for markdown
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        require("quarto").activate()
    end,
})

-- Suppress noisy notifications
local orig_notify = vim.notify
vim.notify = function(msg, ...)
    if msg and msg:match("No explicit query provided") then return end
    orig_notify(msg, ...)
end
