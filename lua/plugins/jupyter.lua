return {
    {
        "benlubas/molten-nvim",
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        dependencies = {"3rd/image.nvim", "GCBallesteros/jupytext.nvim"},
        build = ":UpdateRemotePlugins",
        init = function()
            -- these are examples, not defaults. Please see the readme
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 20
            -- Output as virtual text. Allows outputs to always be shown, works with images, but can
            -- be buggy with longer images
            vim.g.molten_virt_text_output = true
            vim.g.molten_image_location = "float"

            -- this will make it so the output shows up below the \`\`\` cell delimiter
            vim.g.molten_virt_lines_off_by_1 = true
            vim.g.molten_virt_text_output = true
            vim.g.molten_auto_open_output = false
            vim.api.nvim_set_hl(0, "MoltenCell", {fg = "NONE", bg = "NONE"})

            -- don't change the mappings (unless it's related to your bug)
            vim.keymap.set("n", "<leader>mi", ":MoltenInit moltenkernel<CR>")
            vim.keymap.set("n", "<leader>e", ":MoltenEvaluateOperator<CR>",
                           {desc = "evaluate operator", silent = true})
            vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>")
            vim.keymap.set("v", "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>gv")
            vim.keymap
                .set("n", "<leader>os", ":noautocmd MoltenEnterOutput<CR>")
            vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<CR>")
            vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>")

            -- add cell
            vim.keymap.set("n", "<leader>cl", "o```python<CR><CR>```<ESC>k",
                           {desc = "Add new Python cell"})
            -- new notebook command
            -- Provide a command to create a blank new Python notebook
            -- note: the metadata is needed for Jupytext to understand how to parse the notebook.
            -- if you use another language than Python, you should change it in the template.
            local default_notebook = [[
  {
    "cells": [
     {
      "cell_type": "markdown",
      "metadata": {},
      "source": [
        ""
      ]
     }
    ],
    "metadata": {
     "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
     },
     "language_info": {
      "codemirror_mode": {
        "name": "ipython"
      },
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

            vim.api.nvim_create_user_command('NewNotebook', function(opts)
                new_notebook(opts.args)
            end, {nargs = 1, complete = 'file'})

            -- automatically import output chunks from a jupyter notebook
            -- tries to find a kernel that matches the kernel in the jupyter notebook
            -- falls back to a kernel that matches the name of the active venv (if any)
            local imb = function(e) -- init molten buffer
                vim.schedule(function()
                    local kernels = vim.fn.MoltenAvailableKernels()
                    local try_kernel_name = function()
                        local metadata = vim.json.decode(
                                             io.open(e.file, "r"):read("a"))["metadata"]
                        return metadata.kernelspec.name
                    end
                    local ok, kernel_name = pcall(try_kernel_name)
                    if not ok or not vim.tbl_contains(kernels, kernel_name) then
                        kernel_name = nil
                        local venv = os.getenv("VIRTUAL_ENV") or
                                         os.getenv("CONDA_PREFIX")
                        if venv ~= nil then
                            kernel_name = string.match(venv, "/.+/(.+)")
                        end
                    end
                    if kernel_name ~= nil and
                        vim.tbl_contains(kernels, kernel_name) then
                        vim.cmd(("MoltenInit %s"):format(kernel_name))
                    end
                    vim.cmd("MoltenImportOutput")
                end)
            end

            -- -- automatically import output chunks from a jupyter notebook
            -- vim.api.nvim_create_autocmd("BufAdd",
            --                             {pattern = {"*.ipynb"}, callback = imb})
            --
            -- -- we have to do this as well so that we catch files opened like nvim ./hi.ipynb
            -- vim.api.nvim_create_autocmd("BufEnter", {
            --     pattern = {"*.ipynb"},
            --     callback = function(e)
            --         if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
            --             imb(e)
            --         end
            --     end
            -- })
            -- -- automatically export output chunks to a jupyter notebook on write
            -- vim.api.nvim_create_autocmd("BufWritePost", {
            --     pattern = {"*.ipynb"},
            --     callback = function()
            --         if require("molten.status").initialized() == "Molten" then
            --             vim.cmd("MoltenExportOutput!")
            --         end
            --     end
            -- })
        end
    }, {
        -- see the image.nvim readme for more information about configuring this plugin
        "3rd/image.nvim",
        opts = {
            backend = "kitty", -- whatever backend you would like to use
            max_width = 100,
            max_height = 16,
            max_height_window_percentage = math.huge,
            max_width_window_percentage = math.huge,
            window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
            window_overlap_clear_ft_ignore = {"cmp_menu", "cmp_docs", ""}
        }
    }, {
        "GCBallesteros/jupytext.nvim",
        opts = {
            style = "markdown",
            output_extension = "md",
            force_ft = "markdown"
        },
        lazy = false,
        config = function(_, opts) require("jupytext").setup(opts) end
    }, -- plugins/quarto.lua
    {
        "quarto-dev/quarto-nvim",
        dependencies = {"jmbuhr/otter.nvim", "nvim-treesitter/nvim-treesitter"},
        ft = {"quarto", "markdown"},
        opts = {
            lspFeatures = {
                -- NOTE: put whatever languages you want here:
                languages = {"python"},
                chunks = "all",
                diagnostics = {enabled = true, triggers = {"BufWritePost"}},
                completion = {enabled = true}
            },
            keymap = {
                -- NOTE: setup your own keymaps:
                hover = "H",
                definition = "gd",
                rename = "<leader>rn",
                references = "gr",
                format = "<leader>gf"
            },
            codeRunner = {enabled = true, default_method = "molten"}
        },
        config = function(_, opts)
            local quarto = require("quarto")
            quarto.setup(opts)
            quarto.activate()
            local runner = require("quarto.runner")
            vim.keymap.set("n", "<leader>rc", runner.run_cell,
                           {desc = "run cell", silent = true})
            vim.keymap.set("n", "<leader>ra", runner.run_above,
                           {desc = "run cell and above", silent = true})
            vim.keymap.set("n", "<leader>rA", runner.run_all,
                           {desc = "run all cells", silent = true})
            vim.keymap.set("n", "<leader>rl", runner.run_line,
                           {desc = "run line", silent = true})
            vim.keymap.set("v", "<leader>r", runner.run_range,
                           {desc = "run visual range", silent = true})
            vim.keymap.set("n", "<leader>RA",
                           function() runner.run_all(true) end, {
                desc = "run all cells of all languages",
                silent = true
            })
        end
    }, -- {
    --     "benlubas/molten-nvim",
    --     dependencies = {"3rd/image.nvim"},
    --     build = ":UpdateRemotePlugins",
    --     init = function()
    --         vim.g.molten_image_provider = "image.nvim"
    --         vim.g.molten_use_border_highlights = true
    --         -- add a few new things
    --
    --         -- don't change the mappings (unless it's related to your bug)
    --         vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>")
    --         vim.keymap.set("n", "<leader>e", ":MoltenEvaluateOperator<CR>")
    --         vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>")
    --         vim.keymap.set("v", "<leader>r",
    --                        ":<C-u>MoltenEvaluateVisual<CR>gv")
    --         vim.keymap.set("n", "<leader>os",
    --                        ":noautocmd MoltenEnterOutput<CR>")
    --         vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<CR>")
    --         vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>")
    --     end
    -- }, {
    --     "3rd/image.nvim",
    --     opts = {
    --         backend = "kitty",
    --         integrations = {},
    --         max_width = 100,
    --         max_height = 12,
    --         max_height_window_percentage = math.huge,
    --         max_width_window_percentage = math.huge,
    --         window_overlap_clear_enabled = true,
    --         window_overlap_clear_ft_ignore = {"cmp_menu", "cmp_docs", ""}
    --     },
    --     version = "1.1.0" -- or comment out for latest
    -- }, 
    {
        "vhyrro/luarocks.nvim",
        priority = 1000, -- Very high priority is required, luarocks.nvim should run as the first plugin in your config.
        opts = {rocks = {"magick"}}
    }
}
