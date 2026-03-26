-- SSH clipboard configuration
-- lemonade for remote Mac clipboard, OSC 52 fallback
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
