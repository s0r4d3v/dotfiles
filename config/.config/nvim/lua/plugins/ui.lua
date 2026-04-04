return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		keys = {
			{
				"<leader>go",
				function()
					Snacks.gitbrowse()
				end,
				mode = { "n", "v" },
				desc = "Git browse",
			},
			{
				"<leader>sd",
				function()
					Snacks.dashboard()
				end,
				desc = "Dashboard",
			},
		},
		opts = {
			indent = { enabled = true },
			scroll = { enabled = true },
			words = { enabled = true },
			gitbrowse = { enabled = true },
			dashboard = {
				enabled = true,
				preset = {
					header = [[
  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
					keys = {
						{
							icon = vim.fn.nr2char(0xf07c),
							key = "f",
							desc = "Find File",
							action = function()
								require("fzf-lua").files()
							end,
						},
						{
							icon = vim.fn.nr2char(0xf002),
							key = "g",
							desc = "Live Grep",
							action = function()
								require("fzf-lua").live_grep()
							end,
						},
						{
							icon = vim.fn.nr2char(0xf1da),
							key = "r",
							desc = "Recent Files",
							action = function()
								require("fzf-lua").oldfiles()
							end,
						},
						{
							icon = vim.fn.nr2char(0xf0e7),
							key = "s",
							desc = "Restore Session",
							action = function()
								require("persistence").load()
							end,
						},
						{ icon = vim.fn.nr2char(0xf013), key = "l", desc = "Lazy", action = ":Lazy" },
						{ icon = vim.fn.nr2char(0xf0ed), key = "u", desc = "Update Plugins", action = ":Lazy update" },
						{ icon = vim.fn.nr2char(0xf011), key = "q", desc = "Quit", action = ":qa" },
					},
				},
				sections = {
					{ section = "header" },
					{
						pane = 2,
						section = "terminal",
						cmd = "git log --graph --color=always --format='%C(auto)%h%d %<(35,trunc)%s' -10 2>/dev/null || echo 'not a git repo'",
						height = 10,
						padding = 1,
						title = " Recent Commits",
						icon = "",
					},
					{ section = "keys", gap = 1, padding = 1 },
					{
						pane = 2,
						icon = "",
						desc = "Browse Repo",
						key = "b",
						padding = 1,
						action = function()
							Snacks.gitbrowse()
						end,
					},
					function()
						local in_git = Snacks.git.get_root() ~= nil
						local cmds = {
							{
								title = "Notifications",
								cmd = "gh notify -s -a -n5",
								key = "n",
								icon = "",
								height = 5,
								enabled = true,
								action = function()
									vim.ui.open("https://github.com/notifications")
								end,
							},
							{
								title = "Open Issues",
								cmd = "gh issue list -L 3",
								key = "i",
								icon = "",
								height = 7,
								action = function()
									vim.fn.jobstart("gh issue list --web", { detach = true })
								end,
							},
							{
								title = "Open PRs",
								cmd = "gh pr list -L 3",
								key = "P",
								icon = "",
								height = 7,
								action = function()
									vim.fn.jobstart("gh pr list --web", { detach = true })
								end,
							},
							{
								title = "Git Status",
								cmd = "git --no-pager diff --stat -B -M -C",
								icon = "",
								height = 10,
							},
						}
						return vim.tbl_map(function(cmd)
							return vim.tbl_extend("force", {
								pane = 2,
								section = "terminal",
								enabled = in_git,
								padding = 1,
								ttl = 5 * 60,
								indent = 3,
							}, cmd)
						end, cmds)
					end,
					{ section = "startup" },
				},
			},
		},
	},
	{
		-- Inline CSS/hex/rgb/hsl color preview
		"NvChad/nvim-colorizer.lua",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			user_default_options = {
				css = true,
				css_fn = true,
				tailwind = true,
				mode = "background",
			},
		},
	},
	{
		"folke/zen-mode.nvim",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Zen mode" },
		},
		opts = { window = { width = 0.85 } },
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufReadPost",
		keys = {
			{ "<leader>ft", "<cmd>TodoFzfLua<cr>", desc = "Todo comments" },
		},
		opts = {},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = { options = { theme = "tokyonight" } },
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({ preset = "modern" })
			wk.add({
				{ "<leader>b", group = "Buffer" },
				{ "<leader>c", group = "Code" },
				{ "<leader>f", group = "Find / Search" },
				{ "<leader>g", group = "Git" },
				{ "<leader>m", group = "Multicursor" },
				{ "<leader>s", group = "UI / View" },
				{ "<leader>S", group = "Session" },
				{ "<leader>x", group = "Diagnostics" },
			})
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
		},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
			{ "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
		},
		opts = {},
	},
}
