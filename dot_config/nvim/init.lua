-- ============================================================
-- Bootstrap lazy.nvim
-- ============================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- Globals (set before plugins load)
-- ============================================================
vim.g.mapleader      = " "
vim.g.maplocalleader = " "
vim.g.molten_auto_open_output   = false
vim.g.molten_image_provider     = "none"
vim.g.molten_virt_lines_off_by_1 = true
vim.g.molten_virt_text_output   = true
vim.g.molten_wrap_output        = true

-- ============================================================
-- Plugin specs
-- ============================================================
require("lazy").setup({
    -- Colorscheme (load immediately)
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, lazy = false },

    -- UI core (load immediately for dashboard)
    { "folke/snacks.nvim", priority = 1000, lazy = false },

    -- Mini utilities
    { "echasnovski/mini.nvim", version = false },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
    { "nvim-treesitter/nvim-treesitter-context" },

    -- LSP / Mason
    { "williamboman/mason.nvim", build = ":MasonUpdate" },
    { "williamboman/mason-lspconfig.nvim", dependencies = { "williamboman/mason.nvim" } },

    -- Completion
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = { "rafamadriz/friendly-snippets" },
    },

    -- Formatting / Linting
    { "stevearc/conform.nvim" },
    { "mfussenegger/nvim-lint" },

    -- Git
    { "lewis6991/gitsigns.nvim" },

    -- Navigation / UI
    { "folke/which-key.nvim",    event = "VeryLazy" },
    { "folke/trouble.nvim" },
    { "folke/todo-comments.nvim" },
    { "folke/flash.nvim" },
    { "folke/lazydev.nvim",      ft = "lua" },
    { "akinsho/bufferline.nvim" },
    { "nvim-lualine/lualine.nvim" },
    { "MeanderingProgrammer/render-markdown.nvim" },
    { "windwp/nvim-autopairs" },

    -- File manager
    { "mikavilpas/yazi.nvim" },

    -- Notebook / scientific
    { "jmbuhr/otter.nvim" },
    {
        "quarto-dev/quarto-nvim",
        dependencies = { "jmbuhr/otter.nvim" },
    },
    { "benlubas/molten-nvim",   version = "^1.0.0", build = ":UpdateRemotePlugins" },
    { "GCBallesteros/jupytext.nvim" },

    -- Testing
    {
        "nvim-neotest/neotest",
        dependencies = { "nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim" },
    },

    -- Misc
    { "anuvyklack/hydra.nvim" },
    { "christoomey/vim-tmux-navigator" },
}, {
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip", "matchit", "matchparen", "netrwPlugin",
                "tarPlugin", "tohtml", "tutor", "zipPlugin",
            },
        },
    },
})

-- ============================================================
-- Options
-- ============================================================
vim.opt.autoindent    = true
vim.opt.clipboard     = "unnamedplus"
vim.opt.colorcolumn   = "80,120"
vim.opt.cursorline    = true
vim.opt.expandtab     = true
vim.opt.ignorecase    = true
vim.opt.list          = true
vim.opt.listchars     = { nbsp = "␣", tab = "→ ", trail = "·" }
vim.opt.mouse         = ""
vim.opt.number        = true
vim.opt.relativenumber = true
vim.opt.scrolloff     = 8
vim.opt.shiftwidth    = 4
vim.opt.sidescrolloff = 8
vim.opt.signcolumn    = "yes"
vim.opt.smartcase     = true
vim.opt.smartindent   = true
vim.opt.softtabstop   = 4
vim.opt.splitbelow    = true
vim.opt.splitright    = true
vim.opt.tabstop       = 4
vim.opt.termguicolors = true
vim.opt.undofile      = true
vim.opt.wrap          = false

-- ============================================================
-- Colorscheme & diagnostics
-- ============================================================
require("catppuccin").setup({ flavour = "macchiato", term_colors = true })

vim.diagnostic.config({
    severity_sort = true,
    signs         = true,
    virtual_lines = { current_line = true },
    virtual_text  = false,
})

vim.cmd([[colorscheme catppuccin]])

-- ============================================================
-- Plugin setup
-- ============================================================
require("mini.icons").setup({})
require("mini.surround").setup({})
MiniIcons.mock_nvim_web_devicons()

require("otter").setup({})
require("yazi").setup({ enable_mouse_support = false })

require("which-key").setup({
    spec = {
        { "<leader>f",  group = "Find" },
        { "<leader>g",  group = "Git",        icon = " " },
        { "<leader>b",  group = "Buffer" },
        { "<leader>x",  group = "Diagnostics" },
        { "<leader>m",  group = "Molten" },
        { "<leader>mo", group = "Output" },
        { "<leader>mr", group = "Run" },
        { "<leader>sb", group = "Swap Block" },
        { "<localleader>r",  group = "Run Cell" },
        { "<localleader>R",  group = "Run All" },
    },
})

require("trouble").setup({})
require("treesitter-context").setup({})

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "lua", "nix", "python", "vim", "vimdoc", "bash",
        "json", "yaml", "toml", "markdown", "markdown_inline",
        "javascript", "typescript", "css", "html", "vue", "regex", "comment",
    },
    highlight = { enable = true },
    textobjects = {
        move = {
            enable    = true,
            set_jumps = false,
            goto_next_start = {
                ["]c"] = { desc = "next code block",     query = "@code_cell.inner" },
                ["]f"] = "@function.outer",
            },
            goto_previous_start = {
                ["[c"] = { desc = "previous code block", query = "@code_cell.inner" },
                ["[f"] = "@function.outer",
            },
        },
        select = {
            enable    = true,
            lookahead = true,
            keymaps = {
                ab  = { desc = "around block", query = "@code_cell.outer" },
                ac  = "@class.outer",
                af  = "@function.outer",
                ib  = { desc = "in block",     query = "@code_cell.inner" },
                ic  = "@class.inner",
                ["if"] = "@function.inner",
            },
        },
        swap = {
            enable    = true,
            swap_next     = { ["<leader>sbl"] = "@code_cell.outer" },
            swap_previous = { ["<leader>sbh"] = "@code_cell.outer" },
        },
    },
})

require("todo-comments").setup({})

require("snacks").setup({
    bigfile      = { enabled = true },
    bufdelete    = { enabled = true },
    dashboard    = {
        enabled  = true,
        sections = {
            { cmd = "pokemon-colorscripts --random --no-title", height = 20, indent = 4, section = "terminal" },
            { gap = 1, padding = 1, section = "keys" },
            {
                action  = function() Snacks.gitbrowse() end,
                desc    = "Browse Repo",
                icon    = " ",
                key     = "B",
                padding = 1,
                pane    = 2,
            },
            function()
                local in_git    = Snacks.git.get_root() ~= nil
                local has_remote = in_git and vim.fn.system("git remote") ~= ""
                local cmds = {
                    {
                        title  = "Notifications",
                        cmd    = "gh notify -s -a -n5",
                        action = function() vim.ui.open("https://github.com/notifications") end,
                        key    = "N", icon = " ", height = 5, enabled = true,
                    },
                    {
                        title  = "Open Issues",
                        cmd    = "gh issue list -L 3",
                        key    = "I",
                        action = function() vim.fn.jobstart("gh issue list --web", { detach = true }) end,
                        icon   = " ", height = 7,
                    },
                    {
                        icon   = " ",
                        title  = "Open PRs",
                        cmd    = "gh pr list -L 3",
                        key    = "P",
                        action = function() vim.fn.jobstart("gh pr list --web", { detach = true }) end,
                        height = 7,
                    },
                    {
                        icon   = " ",
                        title  = "Git Status",
                        cmd    = "git --no-pager diff --stat -B -M -C",
                        height = 10,
                    },
                }
                return vim.tbl_map(function(cmd)
                    return vim.tbl_extend("force", {
                        pane    = 2,
                        section = "terminal",
                        enabled = has_remote,
                        padding = 1,
                        ttl     = 5 * 60,
                        indent  = 3,
                    }, cmd)
                end, cmds)
            end,
        },
    },
    gh          = { enabled = true },
    git         = { enabled = true },
    gitbrowse   = { enabled = true },
    image       = { enabled = true },
    indent      = { enabled = true },
    input       = { enabled = true },
    lazygit     = { configure = true, enabled = true, win = { style = "lazygit" } },
    notifier    = { enabled = true },
    picker      = { enabled = true },
    quickfile   = { enabled = true },
    scope       = { enabled = true },
    scroll      = { enabled = true },
    statuscolumn = { enabled = true },
    words       = { enabled = true },
})

require("render-markdown").setup({})

require("quarto").setup({
    codeRunner = {
        default_method = "molten",
        enabled        = true,
        ft_runners     = { python = "molten" },
        never_run      = { "yaml" },
    },
})

require("nvim-autopairs").setup({})
require("neotest").setup({})
require("lualine").setup({ options = { theme = "catppuccin" } })

local __lint = require("lint")
__lint.linters_by_ft = {
    bash    = { "shellcheck" },
    css     = { "stylelint" },
    html    = { "htmlhint" },
    python  = { "ruff" },
}

require("lazydev").setup({})

require("jupytext").setup({
    custom_language_formatting = {
        python = { extension = "qmd", force_ft = "quarto", style = "quarto" },
    },
})

hydra = require("hydra")
hydra.setup({})
__hydra_defs = {}
for _, hydra_config in ipairs(__hydra_defs) do
    hydra(hydra_config)
end

require("gitsigns").setup({})
require("flash").setup({})

require("conform").setup({
    format_after_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if ft == "quarto" or ft == "markdown" then
            return { lsp_format = "fallback" }
        end
    end,
    format_on_save    = { lsp_format = "fallback", timeout_ms = 3000 },
    formatters        = { prettier = { options = { ext_parsers = { ipynb = "markdown" } } } },
    formatters_by_ft  = {
        bash       = { "shfmt" },
        css        = { "prettier" },
        html       = { "prettier" },
        javascript = { "prettier" },
        json       = { "prettier" },
        lua        = { "stylua" },
        markdown   = { "prettier", "injected" },
        python     = { "ruff_format", "ruff_fix" },
        quarto     = { "prettier", "injected" },
        typescript = { "prettier" },
        yaml       = { "prettier" },
    },
})

require("bufferline").setup({})

require("blink.cmp").setup({
    completion = { documentation = { auto_show = true, auto_show_delay_ms = 200 } },
    keymap     = { preset = "default" },
    signature  = { enabled = true },
    sources    = {
        default   = { "lsp", "path", "snippets", "buffer", "lazydev" },
        providers = {
            lazydev = { module = "lazydev.integrations.blink", name = "LazyDev", score_offset = 100 },
            snippets = { opts = { friendly_snippets = true } },
        },
    },
})

-- ============================================================
-- Mason (LSP server installer)
-- ============================================================
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls", "cssls", "docker_compose_language_service", "dockerls",
        "helm_ls", "html", "htmx", "jsonls", "lua_ls", "marksman",
        "pyright", "ruff", "taplo", "terraformls", "yamlls",
        -- unocss + spyglassmc installed separately via npm (run_once script)
    },
    automatic_installation = false,
})

-- ============================================================
-- LSP (native vim.lsp API — Neovim 0.11+)
-- ============================================================
do
    local __lspCapabilities = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
        return capabilities
    end

    local __setup = { capabilities = __lspCapabilities() }
    local __wrapConfig = function(cfg)
        return vim.tbl_extend("keep", cfg or {}, __setup)
    end

    local servers = {
        "bashls", "cssls", "docker_compose_language_service", "dockerls",
        "helm_ls", "html", "htmx", "jsonls", "lua_ls", "marksman",
        "pyright", "ruff", "spyglassmc_language_server", "taplo",
        "terraformls", "unocss", "yamlls",
    }
    for _, server in ipairs(servers) do
        vim.lsp.config(server, __wrapConfig({}))
        vim.lsp.enable(server)
    end
end

-- ============================================================
-- Keymaps
-- ============================================================
do
    local map = vim.keymap.set
    -- Splits
    map("n", "<C-w>-",  ":split<CR>",  { desc = "Split window horizontally" })
    map("n", "<C-w>\\", ":vsplit<CR>", { desc = "Split window vertically" })
    -- File / buffer
    map("n", "<leader>w", ":w<CR>",   { desc = "Write file" })
    map("n", "<leader>W", ":wa<CR>",  { desc = "Write all files" })
    map("n", "<leader>q", ":q<CR>",   { desc = "Quit" })
    map("n", "<leader>Q", ":qa<CR>",  { desc = "Quit all" })
    map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
    -- Explorer
    map("n", "<leader>e", "<cmd>Yazi<CR>", { desc = "Yazi Explorer" })
    -- Picker
    map("n", "<leader>ff", "<cmd>lua Snacks.picker.files()<CR>",   { desc = "Find Files" })
    map("n", "<leader>fg", "<cmd>lua Snacks.picker.grep()<CR>",    { desc = "Grep" })
    map("n", "<leader>fb", "<cmd>lua Snacks.picker.buffers()<CR>", { desc = "Buffers" })
    map("n", "<leader>fh", "<cmd>lua Snacks.picker.help()<CR>",    { desc = "Help" })
    -- Buffers
    map("n", "<leader>bd", "<cmd>lua Snacks.bufdelete()<CR>",        { desc = "Delete Buffer" })
    map("n", "<leader>bD", "<cmd>lua Snacks.bufdelete.all()<CR>",    { desc = "Delete All Buffers" })
    map("n", "<leader>bo", "<cmd>lua Snacks.bufdelete.other()<CR>",  { desc = "Delete Other Buffers" })
    -- Git
    map("n", "<leader>gg", "<cmd>lua Snacks.lazygit()<CR>",                          { desc = "Lazygit" })
    map("n", "<leader>gl", "<cmd>lua Snacks.lazygit.log()<CR>",                      { desc = "Lazygit Log" })
    map("n", "<leader>gf", "<cmd>lua Snacks.lazygit.log_file()<CR>",                 { desc = "Lazygit File History" })
    map("n", "<leader>gi", "<cmd>lua Snacks.picker.gh_issue()<CR>",                  { desc = "GitHub Issues" })
    map("n", "<leader>gI", "<cmd>lua Snacks.picker.gh_issue({ state = 'all' })<CR>", { desc = "GitHub Issues (all)" })
    map("n", "<leader>gp", "<cmd>lua Snacks.picker.gh_pr()<CR>",                     { desc = "GitHub PRs" })
    map("n", "<leader>gP", "<cmd>lua Snacks.picker.gh_pr({ state = 'all' })<CR>",    { desc = "GitHub PRs (all)" })
    map("n", "<leader>gb", "<cmd>lua Snacks.git.blame_line()<CR>",                   { desc = "Git Blame Line" })
    map("n", "<leader>gB", "<cmd>lua Snacks.gitbrowse()<CR>",                        { desc = "Git Browse" })
    map("v", "<leader>gB", "<cmd>lua Snacks.gitbrowse({ what = 'permalink' })<CR>",  { desc = "Git Browse (permalink)" })
    -- Diagnostics
    map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",              { desc = "Diagnostics" })
    map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer Diagnostics" })
    map("n", "]]",         "<cmd>lua Snacks.words.jump(1)<CR>",                { desc = "Next Reference" })
    map("n", "[[",         "<cmd>lua Snacks.words.jump(-1)<CR>",               { desc = "Prev Reference" })
    -- Molten
    map("n", "<leader>me",  ":MoltenEvaluateOperator<CR>",   { desc = "Evaluate operator" })
    map("n", "<leader>mos", ":noautocmd MoltenEnterOutput<CR>", { desc = "Show output window" })
    map("n", "<leader>mrr", ":MoltenReevaluateCell<CR>",      { desc = "Re-eval cell" })
    map("v", "<leader>mr",  ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Execute visual selection" })
    map("n", "<leader>moh", ":MoltenHideOutput<CR>",          { desc = "Hide output window" })
    map("n", "<leader>md",  ":MoltenDelete<CR>",              { desc = "Delete Molten cell" })
    map("n", "<leader>mx",  ":MoltenOpenInBrowser<CR>",       { desc = "Open output in browser" })
    map("n", "<leader>mc",  function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        vim.api.nvim_buf_set_lines(0, row, row, false, { "", "```{python}", "", "```", "" })
        vim.api.nvim_win_set_cursor(0, { row + 3, 0 })
        vim.cmd("startinsert")
    end, { desc = "New code cell below" })
    -- Quarto runner
    map("n", "<localleader>rc", require("quarto.runner").run_cell,  { desc = "Run Quarto/Jupyter cell" })
    map("n", "<localleader>ra", require("quarto.runner").run_above, { desc = "Run cell and above" })
    map("n", "<localleader>rA", require("quarto.runner").run_all,   { desc = "Run all notebook cells" })
    map("n", "<localleader>rl", require("quarto.runner").run_line,  { desc = "Run Jupyter cell line" })
    map("v", "<localleader>r",  require("quarto.runner").run_range, { desc = "Run visual notebook cell selection" })
    map("n", "<localleader>RA", function() require("quarto.runner").run_all(true) end,
        { desc = "Run all notebook cells (all languages)" })
end

-- ============================================================
-- Filetype detection
-- ============================================================
vim.filetype.add({ extension = { mcfunction = "mcfunction" } })

-- ============================================================
-- Misc (suppress noisy notifications)
-- ============================================================
local orig_notify = vim.notify
vim.notify = function(msg, ...)
    if msg and msg:match("No explicit query provided") then return end
    orig_notify(msg, ...)
end

-- ============================================================
-- SSH clipboard (lemonade → OSC 52 fallback)
-- ============================================================
if os.getenv("SSH_TTY") ~= nil or os.getenv("SSH_CLIENT") ~= nil then
    if vim.fn.exepath("lemonade") ~= "" then
        vim.g.clipboard = {
            name  = "lemonade",
            copy  = {
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
            name  = "OSC 52",
            copy  = {
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

-- ============================================================
-- Autocommands
-- ============================================================
vim.api.nvim_create_autocmd("FileType", {
    pattern  = "markdown",
    callback = function() require("quarto").activate() end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "nix,lua,javascript,typescript,vue,markdown,quarto,html,css,yaml,json",
    command = "setlocal shiftwidth=2 tabstop=2 softtabstop=2",
})

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern  = "*",
    command  = "silent! lua vim.highlight.on_yank()",
})

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "LspAttach" }, {
    pattern  = "*",
    command  = "lua require('lint').try_lint()",
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
        require("otter").activate()
    end,
    desc = "Activate otter on LSP attach",
})

-- Molten: auto import/export ipynb outputs
local imb = function(e)
    vim.schedule(function()
        local kernels = vim.fn.MoltenAvailableKernels()
        local try_kernel_name = function()
            local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
            return metadata.kernelspec.name
        end
        local ok, kernel_name = pcall(try_kernel_name)
        if not ok or not vim.tbl_contains(kernels, kernel_name) then
            kernel_name = nil
            local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
            if venv ~= nil then
                kernel_name = string.match(venv, "/.+/(.+)")
            end
        end
        if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
            vim.cmd(("MoltenInit %s"):format(kernel_name))
        end
        vim.cmd("MoltenImportOutput")
    end)
end
vim.api.nvim_create_autocmd("BufAdd",  { pattern = { "*.ipynb" }, callback = imb })
vim.api.nvim_create_autocmd("BufEnter", {
    pattern  = { "*.ipynb" },
    callback = function(e)
        if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then imb(e) end
    end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern  = { "*.ipynb" },
    callback = function()
        if require("molten.status").initialized() == "Molten" then
            vim.cmd("MoltenExportOutput!")
        end
    end,
})
vim.api.nvim_create_autocmd("BufEnter", {
    pattern  = "*.py",
    callback = function(e)
        if string.match(e.file, ".otter.") then return end
        if require("molten.status").initialized() == "Molten" then
            vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
            vim.fn.MoltenUpdateOption("virt_text_output", false)
        else
            vim.g.molten_virt_lines_off_by_1 = false
            vim.g.molten_virt_text_output    = false
        end
    end,
})
vim.api.nvim_create_autocmd("BufEnter", {
    pattern  = { "*.qmd", "*.md", "*.ipynb" },
    callback = function(e)
        if string.match(e.file, ".otter.") then return end
        if require("molten.status").initialized() == "Molten" then
            vim.fn.MoltenUpdateOption("virt_lines_off_by_1", true)
            vim.fn.MoltenUpdateOption("virt_text_output", true)
        else
            vim.g.molten_virt_lines_off_by_1 = true
            vim.g.molten_virt_text_output    = true
        end
    end,
})

-- New notebook user command
local default_notebook = [[
  {
    "cells": [{ "cell_type": "markdown", "metadata": {}, "source": [""] }],
    "metadata": {
      "kernelspec": {
        "display_name": "Python 3",
        "language": "python",
        "name": "python3"
      },
      "language_info": {
        "codemirror_mode": { "name": "ipython" },
        "file_extension": ".py",
        "mimetype": "text/x-python",
        "name": "python",
        "nbconvert_exporter": "python",
        "pygments_lexer": "ipython3"
      }
    },
    "nbformat": 4,
    "nbformat_minor": 5
  }
]]
local function new_notebook(filename)
    local path = filename .. ".ipynb"
    local file = io.open(path, "w")
    if file then
        file:write(default_notebook)
        file:close()
        vim.cmd("edit " .. path)
    else
        print("Error: Could not open new notebook file for writing.")
    end
end
vim.api.nvim_create_user_command("NewNotebook", function(opts)
    new_notebook(opts.args)
end, { nargs = 1, complete = "file" })
