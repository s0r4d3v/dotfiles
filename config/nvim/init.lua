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
-- macOS (no SSH): pbcopy/pbpaste detected automatically — no override needed.
--
-- Inside tmux (TMUX set): use tmux buffer as the clipboard bridge.
--   copy:  load-buffer -w writes to tmux buffer AND forwards to outer terminal
--          clipboard via OSC 52 (requires set-clipboard=on in tmux.conf).
--   paste: refresh-client -l makes tmux query the outer terminal's clipboard and
--          load the response into its buffer; save-buffer - then reads it back.
--          The pane-focus-in hook in tmux.conf pre-fetches this on every focus
--          event so the buffer is ready before `p` is pressed.
--
-- SSH without remote tmux (SSH_TTY set, TMUX unset): raw OSC 52.
--   copy:  OSC 52 write passes through SSH to macOS tmux → set-clipboard=on
--          forwards to iTerm2/WezTerm → macOS clipboard updated.
--   paste: OSC 52 query answered by macOS tmux from its buffer, which the
--          pane-focus-in hook keeps in sync with the macOS clipboard.
if vim.env.TMUX then
  vim.g.clipboard = {
    name  = "tmux",
    copy  = {
      ["+"] = { "tmux", "load-buffer", "-w", "-" },
      ["*"] = { "tmux", "load-buffer", "-w", "-" },
    },
    paste = {
      ["+"] = { "bash", "-c", "tmux refresh-client -l && sleep 0.05 && tmux save-buffer -" },
      ["*"] = { "bash", "-c", "tmux refresh-client -l && sleep 0.05 && tmux save-buffer -" },
    },
    cache_enabled = 0,
  }
elseif vim.env.SSH_TTY then
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
