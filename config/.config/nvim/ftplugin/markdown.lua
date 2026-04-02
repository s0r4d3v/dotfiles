-- Activate quarto-nvim for markdown buffers (provides LSP via otter + code runner).
-- This is the recommended approach from molten-nvim's Notebook-Setup guide.
-- quarto-nvim must have ft = { "quarto", "markdown" } in its lazy.nvim spec.
require("quarto").activate()
