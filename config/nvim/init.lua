-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Clipboard — OSC 52 (syncs with Mac clipboard through tmux + SSH)
-- Uses base64 encoding internally, so Japanese/Unicode works identically to ASCII.
-- Requires Neovim 0.10+ (built-in, no plugin needed).
vim.opt.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
    ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
  },
}

-- Options
vim.g.mapleader = " "
vim.opt.mouse          = ""     -- disable mouse
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.expandtab      = true
vim.opt.shiftwidth     = 2
vim.opt.tabstop        = 2
vim.opt.smartindent    = true
vim.opt.wrap           = false
vim.opt.ignorecase     = true
vim.opt.smartcase      = true
vim.opt.termguicolors  = true
vim.opt.splitbelow     = true
vim.opt.splitright     = true
vim.opt.scrolloff      = 8

-- Keymaps
vim.keymap.set("n", "<leader>w",   "<cmd>w<cr>",        { desc = "Save" })
vim.keymap.set("n", "<leader>q",   "<cmd>q<cr>",        { desc = "Quit" })
vim.keymap.set("n", "<Esc>",       "<cmd>nohlsearch<cr>")   -- clear search highlight
vim.keymap.set("n", "<C-d>",       "<C-d>zz")               -- scroll down, keep centered
vim.keymap.set("n", "<C-u>",       "<C-u>zz")               -- scroll up, keep centered
vim.keymap.set("n", "n",           "nzzzv")                  -- next match, centered
vim.keymap.set("n", "N",           "Nzzzv")                  -- prev match, centered
vim.keymap.set("v", "<",           "<gv")                    -- indent, stay in visual
vim.keymap.set("v", ">",           ">gv")                    -- dedent, stay in visual

-- LSP keymaps (on attach)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    map("gd",          vim.lsp.buf.definition,    "Go to definition")
    map("gr",          vim.lsp.buf.references,    "References")
    map("K",           vim.lsp.buf.hover,         "Hover")
    map("<leader>cr",  vim.lsp.buf.rename,        "Rename")
    map("<leader>ca",  vim.lsp.buf.code_action,   "Code action")
    map("[d",          vim.diagnostic.goto_prev,  "Prev diagnostic")
    map("]d",          vim.diagnostic.goto_next,  "Next diagnostic")
  end,
})

-- Plugins
require("lazy").setup("plugins")
