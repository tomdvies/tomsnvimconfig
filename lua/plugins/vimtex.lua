return {
    {
        "lervag/vimtex",
        lazy = false, -- we don't want to lazy load VimTeX
        -- tag = "v2.15", -- uncomment to pin to a specific release
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_method = "skim"
            vim.g.vimtex_matchparen_enabled = 0
            vim.g.vimtex_view_skim_sync = 1
            vim.g.vimtex_view_skim_activate = 1
            require("lspconfig").digestif.setup({})
            vim.g.tex_flavor = "latex"
            vim.keymap.set("n", "<leader>;;",
                           function() vim.cmd("VimtexCompile") end, {})
            vim.g.vimtex_compiler_latexmk = {
                build_dir = '.vimtex',
                callback = 1,
                continuous = 1,
                out_dir = '.',
                options = {
                    "-verbose", "-file-line-error", "-synctex=1",
                    "-interaction=nonstopmode", "-shell-escape"
                }
            }
            -- vim.g.vimtex_compiler_latexmk_engines = {
            --     _ = '-lualatex' -- Set LuaLaTeX as the default engine
            -- }
        end
    }, {
        "utilyre/sentiment.nvim",
        version = "*",
        event = "VeryLazy", -- keep for lazy loading
        opts = {
            -- config
        },
        init = function()
            -- `matchparen.vim` needs to be disabled manually in case of lazy loading
            vim.g.loaded_matchparen = 1
        end
    }, {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
            default = {
                prompt_for_file_name = true,
                dir_path = "images", -- Save images to ./images/
            },
            filetypes = {
                tex = {
                    use_absolute_path = false, -- Use relative paths
                    relative_template_path = true -- Path relative to LaTeX doc
                }
            }
        },
        keys = {
            -- suggested keymap
            {
                "<leader>p",
                "<cmd>PasteImage<cr>",
                desc = "Paste image from system clipboard"
            }
        }
    }
}
