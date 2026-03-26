-- lazy.nvim is managed by chezmoi (.chezmoiexternal.toml)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    error("lazy.nvim not found. Run 'chezmoi apply' to install it.")
end
vim.opt.rtp:prepend(lazypath)

-- Load core config before plugins
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Setup lazy.nvim
require("lazy").setup({
    { import = "plugins" },
}, {
    change_detection = { notify = false },
    rocks = { enabled = false },
})

-- Load clipboard config (after plugins)
require("config.clipboard")
