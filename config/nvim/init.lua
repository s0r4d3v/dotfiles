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

-- Clipboard
-- Remote (SSH_TTY set): OSC 52 — writes travel through remote tmux + SSH +
--   local tmux (set-clipboard=on) to the outer terminal (Ghostty → macOS).
-- Local macOS (no SSH_TTY): pbcopy/pbpaste detected automatically.
if vim.env.SSH_TTY then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name  = "OSC 52",
    copy  = { ["+"] = osc52.copy("+"),  ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end
vim.opt.clipboard = "unnamedplus"

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
vim.keymap.set("n", "<leader>w",   "<cmd>w<cr>",             { desc = "Save" })
vim.keymap.set("n", "<leader>q",   "<cmd>q<cr>",             { desc = "Quit" })
vim.keymap.set("n", "<Esc>",       "<cmd>nohlsearch<cr>")    -- clear search highlight
vim.keymap.set("n", "<C-d>",       "<C-d>zz")                -- scroll down, keep centered
vim.keymap.set("n", "<C-u>",       "<C-u>zz")                -- scroll up, keep centered
vim.keymap.set("n", "n",           "nzzzv")                  -- next match, centered
vim.keymap.set("n", "N",           "Nzzzv")                  -- prev match, centered
vim.keymap.set("v", "<",           "<gv")                    -- indent, stay in visual
vim.keymap.set("v", ">",           ">gv")                    -- dedent, stay in visual

-- Buffer
vim.keymap.set("n", "[b",          "<cmd>bprev<cr>",         { desc = "Prev buffer" })
vim.keymap.set("n", "]b",          "<cmd>bnext<cr>",         { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd",  "<cmd>bd<cr>",            { desc = "Close buffer" })

-- Quickfix
vim.keymap.set("n", "<leader>xq",  "<cmd>copen<cr>",         { desc = "Open quickfix" })
vim.keymap.set("n", "[q",          "<cmd>cprev<cr>",         { desc = "Prev quickfix" })
vim.keymap.set("n", "]q",          "<cmd>cnext<cr>",         { desc = "Next quickfix" })

-- Diagnostics
vim.keymap.set("n", "<leader>cd",  vim.diagnostic.open_float, { desc = "Diagnostic float" })

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

-- Filetype detection for non-standard extensions
vim.filetype.add({
  extension = {
    mcfunction = "mcfunction",
  },
})

-- Plugins
require("lazy").setup("plugins")
