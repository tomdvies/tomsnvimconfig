return {
    {
        "stevearc/conform.nvim",
        dependencies = {
            "mason.nvim", "https://github.com/devOpifex/r.nvim",
            {"williamboman/mason-lspconfig.nvim", config = function() end}
        },
        cmd = {"ConformInfo"},
        keys = {
            {
                -- Customize or remove this keymap to your liking
                "<leader>f",
                function()
                    require("conform").format({
                        async = true,
                        lsp_fallback = true
                    })
                end,
                mode = "",
                desc = "Format buffer"
            }
        },
        init = function()
            -- If you want the formatexpr, here is the place to set it
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
        config = function()
            require("conform").setup {

                formatters = {
                    styler2 = {
                        -- hijacking "https://github.com/devOpifex/r.nvim",
                        args = {
                            "-s", "-e", "styler::style_file(commandArgs(TRUE))",
                            "--args", "$FILENAME"
                        },
                        stdin = false
                    }
                },

                -- Define your formatters
                formatters_by_ft = {
                    lua = {"lua-format"},
                    python = {"black"},
                    -- r = {"styler2"},
                    -- rmd = {"styler"},
                    rust = {"rustfmt"},
                    markdown = {"injected"},
                    javascript = {
                        "prettierd",
                        "prettier",
                        stop_after_first = true
                    }
                },
                -- Set default options
                default_format_opts = {lsp_format = "fallback"},
                -- Set up format-on-save
                -- format_on_save = false,
                -- Customize formatters
                formatters = {shfmt = {prepend_args = {"-i", "2"}}}
            }
            -- Customize the "injected" formatter
            require("conform").formatters.injected = {
                -- Set the options field
                options = {
                    -- Set to true to ignore errors
                    ignore_errors = false,
                    -- Map of treesitter language to file extension
                    -- A temporary file name with this extension will be generated during formatting
                    -- because some formatters care about the filename.
                    lang_to_ext = {
                        bash = "sh",
                        c_sharp = "cs",
                        elixir = "exs",
                        javascript = "js",
                        julia = "jl",
                        latex = "tex",
                        markdown = "md",
                        python = "py",
                        ruby = "rb",
                        rust = "rs",
                        teal = "tl",
                        typescript = "ts"
                    },
                    -- Map of treesitter language to formatters to use
                    -- (defaults to the value from formatters_by_ft)
                    lang_to_formatters = {}
                }
            }
        end,
        lazy = false

    }
}
