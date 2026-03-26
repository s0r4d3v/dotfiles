-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Molten globals
vim.g.molten_auto_open_output = false
vim.g.molten_image_provider = "none"
vim.g.molten_wrap_output = true
vim.g.molten_virt_text_output = true
vim.g.molten_virt_lines_off_by_1 = true

-- Mouse
vim.opt.mouse = ""

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Undo
vim.opt.undofile = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- UI
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- List chars
vim.opt.list = true
vim.opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }

-- Color column
vim.opt.colorcolumn = "80,120"

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- SSH clipboard: lemonade for remote Mac, OSC 52 fallback
if os.getenv("SSH_TTY") ~= nil or os.getenv("SSH_CLIENT") ~= nil then
    if vim.fn.exepath("lemonade") ~= "" then
        vim.g.clipboard = {
            name = "lemonade",
            copy = {
                ["+"] = { "lemonade", "--port", "2489", "copy" },
                ["*"] = { "lemonade", "--port", "2489", "copy" },
            },
            paste = {
                ["+"] = { "lemonade", "--port", "2489", "paste" },
                ["*"] = { "lemonade", "--port", "2489", "paste" },
            },
            cache_enabled = 0,
        }
    else
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
    end
end

-- Diagnostics
vim.diagnostic.config({
    virtual_lines = { current_line = true },
    virtual_text = false,
    signs = true,
    severity_sort = true,
})

-- Custom filetype
vim.filetype.add({
    extension = {
        mcfunction = "mcfunction",
    },
})
