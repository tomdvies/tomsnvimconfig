return {
    {"nvim-treesitter/nvim-treesitter-textobjects"}, {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {"nvim-treesitter/nvim-treesitter-textobjects"},
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "rust", "javascript", "css",
                    "javascript", "html", "python", "r", "rust", "cpp",
                    "markdown", "markdown_inline", "rnoweb", "yaml"
                },
                sync_install = false,
                highlight = {enable = true},
                indent = {enable = true},

                textobjects = {
                    move = {
                        enable = true,
                        set_jumps = false, -- you can change this if you want.
                        goto_next_start = {
                            --- ... other keymaps
                            ["]b"] = {
                                query = "@code_cell.inner",
                                desc = "next code block"
                            }
                        },
                        goto_previous_start = {
                            --- ... other keymaps
                            ["[b"] = {
                                query = "@code_cell.inner",
                                desc = "previous code block"
                            }
                        }
                    }
                }
                --     select = {
                --         enable = true,
                --         lookahead = true, -- you can change this if you want
                --         keymaps = {
                --             --- ... other keymaps
                --             ["ib"] = {
                --                 query = "@code_cell.inner",
                --                 desc = "in block"
                --             },
                --             ["ab"] = {
                --                 query = "@code_cell.outer",
                --                 desc = "around block"
                --             }
                --         }
                --     },
                --     swap = { -- swap only works with code blocks that are under the same
                --         -- markdown header
                --         enable = true,
                --         swap_next = {
                --             --- ... other keymap
                --             ["<leader>sbl"] = "@code_cell.outer"
                --         },
                --         swap_previous = {
                --             --- ... other keymap
                --             ["<leader>sbh"] = "@code_cell.outer"
                --         }
                --     }
                -- },

            })
        end
    }, -- lazy.nvim
    {
        "chrisgrieser/nvim-various-textobjs",
        opts = {usedefaultkeymaps = true},
        enabled = false
    }, {
        "terrortylor/nvim-comment",
        dependencies = {"JoosepAlviste/nvim-ts-context-commentstring"},
        config = function()
            require('nvim_comment').setup({
                hook = function()
                    if vim.api.nvim_buf_get_option(0, "filetype") == "markdown" then
                        require("ts_context_commentstring.internal").update_commentstring()
                    end
                end
            })
        end
    },
    {
        "folke/ts-comments.nvim",
        opts = {},
        enabled = vim.fn.has("nvim-0.10.0") == 1
    }
}
