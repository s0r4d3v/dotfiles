return {
    -- Molten: Jupyter kernel integration
    {
        "benlubas/molten-nvim",
        build = ":UpdateRemotePlugins",
        ft = { "python", "quarto", "markdown" },
        init = function()
            -- Automatically import/export output chunks
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

            vim.api.nvim_create_autocmd("BufAdd", { pattern = { "*.ipynb" }, callback = imb })
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = { "*.ipynb" },
                callback = function(e)
                    if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then imb(e) end
                end,
            })
            vim.api.nvim_create_autocmd("BufWritePost", {
                pattern = { "*.ipynb" },
                callback = function()
                    if require("molten.status").initialized() == "Molten" then
                        vim.cmd("MoltenExportOutput!")
                    end
                end,
            })

            -- Toggle virt_lines mode based on filetype
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "*.py",
                callback = function(e)
                    if string.match(e.file, ".otter.") then return end
                    if require("molten.status").initialized() == "Molten" then
                        vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
                        vim.fn.MoltenUpdateOption("virt_text_output", false)
                    else
                        vim.g.molten_virt_lines_off_by_1 = false
                        vim.g.molten_virt_text_output = false
                    end
                end,
            })
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = { "*.qmd", "*.md", "*.ipynb" },
                callback = function(e)
                    if string.match(e.file, ".otter.") then return end
                    if require("molten.status").initialized() == "Molten" then
                        vim.fn.MoltenUpdateOption("virt_lines_off_by_1", true)
                        vim.fn.MoltenUpdateOption("virt_text_output", true)
                    else
                        vim.g.molten_virt_lines_off_by_1 = true
                        vim.g.molten_virt_text_output = true
                    end
                end,
            })

            -- NewNotebook command
            local default_notebook = [[
{
  "cells": [
    {
      "cell_type": "markdown",
      "metadata": {},
      "source": [ "" ]
    }
  ],
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
}]]
            vim.api.nvim_create_user_command("NewNotebook", function(opts)
                local path = opts.args .. ".ipynb"
                local file = io.open(path, "w")
                if file then
                    file:write(default_notebook)
                    file:close()
                    vim.cmd("edit " .. path)
                else
                    print("Error: Could not open new notebook file for writing.")
                end
            end, { nargs = 1, complete = "file" })
        end,
    },
    -- Quarto: notebook runner
    {
        "quarto-dev/quarto-nvim",
        ft = { "quarto", "markdown" },
        dependencies = { "jmbuhr/otter.nvim" },
        opts = {
            codeRunner = {
                enabled = true,
                default_method = "molten",
                ft_runners = {
                    python = "molten",
                },
                never_run = { "yaml" },
            },
        },
    },
    -- Otter: code cell editing
    {
        "jmbuhr/otter.nvim",
        ft = { "quarto", "markdown" },
        opts = {},
    },
    -- Jupytext: notebook format conversion
    {
        "GCBallesteros/jupytext.nvim",
        ft = { "python", "quarto", "markdown" },
        opts = {
            custom_language_formatting = {
                python = {
                    extension = "qmd",
                    style = "quarto",
                    force_ft = "quarto",
                },
            },
        },
    },
    -- Hydra for notebook-like interactions
    {
        "nvimtools/hydra.nvim",
        event = "VeryLazy",
        opts = {},
    },
    -- LazyDev for Neovim Lua development
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {},
    },
    -- Neotest
    {
        "nvim-neotest/neotest",
        cmd = "Neotest",
        opts = {},
    },
}
