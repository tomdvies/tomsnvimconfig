return {
    {
        "benlubas/molten-nvim",
        version = "<2.0.0", -- use version <2.0.0 to avoid breaking changes
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

            -- don't change the mappings (unless it's related to your bug)
            vim.keymap.set("n", "<leader>mi", ":MoltenInit<CR>")
            vim.keymap.set("n", "<leader>e", ":MoltenEvaluateOperator<CR>",
                           {desc = "evaluate operator", silent = true})
            vim.keymap.set("n", "<leader>rr", ":MoltenReevaluateCell<CR>")
            vim.keymap.set("v", "<leader>r", ":<C-u>MoltenEvaluateVisual<CR>gv")
            vim.keymap
                .set("n", "<leader>os", ":noautocmd MoltenEnterOutput<CR>")
            vim.keymap.set("n", "<leader>oh", ":MoltenHideOutput<CR>")
            vim.keymap.set("n", "<leader>md", ":MoltenDelete<CR>")

            -- add cell
            vim.keymap.set("n", "<leader>cl", "o```python<CR><CR>```<ESC>k", { desc = "Add new Python cell" })
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
