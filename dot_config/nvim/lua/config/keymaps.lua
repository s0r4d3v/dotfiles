local map = vim.keymap.set

-- Window split
map("n", "<C-w>-", ":split<CR>", { desc = "Split window horizontally" })
map("n", "<C-w>\\", ":vsplit<CR>", { desc = "Split window vertically" })

-- File & Buffer commands
map("n", "<leader>w", ":w<CR>", { desc = "Write file" })
map("n", "<leader>W", ":wa<CR>", { desc = "Write all files" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>Q", ":qa<CR>", { desc = "Quit all" })

-- Clear search highlight
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Yazi
map("n", "<leader>e", "<cmd>Yazi<CR>", { desc = "Yazi Explorer" })

-- Snacks: Find
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
map("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Grep" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help" })

-- Snacks: Buffers
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Delete Buffer" })
map("n", "<leader>bD", function() Snacks.bufdelete.all() end, { desc = "Delete All Buffers" })
map("n", "<leader>bo", function() Snacks.bufdelete.other() end, { desc = "Delete Other Buffers" })

-- Snacks: Git
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
map("n", "<leader>gl", function() Snacks.lazygit.log() end, { desc = "Lazygit Log" })
map("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit File History" })
map("n", "<leader>gi", function() Snacks.picker.gh_issue() end, { desc = "GitHub Issues" })
map("n", "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, { desc = "GitHub Issues (all)" })
map("n", "<leader>gp", function() Snacks.picker.gh_pr() end, { desc = "GitHub PRs" })
map("n", "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, { desc = "GitHub PRs (all)" })
map("n", "<leader>gb", function() Snacks.git.blame_line() end, { desc = "Git Blame Line" })
map("n", "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })
map("v", "<leader>gB", function() Snacks.gitbrowse({ what = "permalink" }) end, { desc = "Git Browse (permalink)" })

-- Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Diagnostics" })
map("n", "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Buffer Diagnostics" })

-- Word references
map("n", "]]", function() Snacks.words.jump(1) end, { desc = "Next Reference" })
map("n", "[[", function() Snacks.words.jump(-1) end, { desc = "Prev Reference" })

-- Molten
map("n", "<leader>me", ":MoltenEvaluateOperator<CR>", { desc = "Evaluate operator" })
map("n", "<leader>mos", ":noautocmd MoltenEnterOutput<CR>", { desc = "Show output window" })
map("n", "<leader>mrr", ":MoltenReevaluateCell<CR>", { desc = "Re-eval cell" })
map("v", "<leader>mr", ":<C-u>MoltenEvaluateVisual<CR>gv", { desc = "Execute visual selection" })
map("n", "<leader>moh", ":MoltenHideOutput<CR>", { desc = "Hide output window" })
map("n", "<leader>md", ":MoltenDelete<CR>", { desc = "Delete Molten cell" })
map("n", "<leader>mx", ":MoltenOpenInBrowser<CR>", { desc = "Open output in browser" })
map("n", "<leader>mc", function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    vim.api.nvim_buf_set_lines(0, row, row, false, {
        "",
        "```{python}",
        "",
        "```",
        "",
    })
    vim.api.nvim_win_set_cursor(0, { row + 3, 0 })
    vim.cmd("startinsert")
end, { desc = "New code cell below" })

-- Quarto runner
map("n", "<localleader>rc", function() require("quarto.runner").run_cell() end, { desc = "Run Quarto/Jupyter cell" })
map("n", "<localleader>ra", function() require("quarto.runner").run_above() end, { desc = "Run cell and above" })
map("n", "<localleader>rA", function() require("quarto.runner").run_all() end, { desc = "Run all notebook cells" })
map("n", "<localleader>rl", function() require("quarto.runner").run_line() end, { desc = "Run Jupyter cell line" })
map("v", "<localleader>r", function() require("quarto.runner").run_range() end, { desc = "Run visual notebook cell selection" })
map("n", "<localleader>RA", function() require("quarto.runner").run_all(true) end, { desc = "Run all notebook cells (all languages)" })
