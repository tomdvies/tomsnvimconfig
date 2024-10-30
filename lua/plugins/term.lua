return {
    {
        'chomosuke/term-edit.nvim',
        event = 'TermOpen',
        version = '1.*',
        config = function()
            require'term-edit'.setup {
                -- Mandatory option:
                -- Set this to a lua pattern that would match the end of your prompt.
                -- Or a table of multiple lua patterns where at least one would match the
                -- end of your prompt at any given time.
                -- For most bash/zsh user this is '%$ '.
                -- For most powershell/fish user this is '> '.
                -- For most windows cmd user this is '>'.
                prompt_end = '%$ '
                -- How to write lua patterns: https://www.lua.org/pil/20.2.html
            }
        end
    }, {
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = { --[[ things you want to change go here]]
            size = function(term)
                if term.direction == "horizontal" then
                    return 20
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.3
                end
            end,
            open_mapping = Nil,
            start_in_insert = false
        },
        config = function(_, opts)
            require("toggleterm").setup(opts)
            local trim_spaces = true
            -- send selection
            vim.keymap.set("v", "<leader>s", function()
                require("toggleterm").send_lines_to_terminal("visual_lines",
                                                             trim_spaces, {
                    args = vim.v.count
                })
            end)
            -- number of term to toggle then do key command - else toggle all
            vim.keymap.set("n", "<C-l>",
                           '<Cmd>execute v:count . "ToggleTerm direction=vertical"<CR>',
                           {desc = "Toggle Terminal", silent = true})
            vim.keymap.set("i", "<C-l>",
                           '<Cmd>execute v:count . "ToggleTerm direction=vertical"<CR>',
                           {desc = "Toggle Terminal", silent = true})
            vim.keymap.set("t", "<C-l>",
                           '<Cmd>execute v:count . "ToggleTerm direction=vertical"<CR>',
                           {desc = "Toggle Terminal", silent = true})
            vim.keymap.set("n", "<C-j>",
                           '<Cmd>execute v:count . "ToggleTerm direction=horizontal"<CR>',
                           {desc = "Toggle Terminal", silent = true})
            vim.keymap.set("i", "<C-j>",
                           '<Cmd>execute v:count . "ToggleTerm direction=horizontal"<CR>',
                           {desc = "Toggle Terminal", silent = true})
            vim.keymap.set("t", "<C-j>",
                           '<Cmd>execute v:count . "ToggleTerm direction=horizontal"<CR>',
                           {desc = "Toggle Terminal", silent = true})
            -- vim.keymap.set("i", "<C-k>", function()
            --     require("toggleterm").toggle(Nil, Nil, Nil, "vertical")
            -- end)
            -- vim.keymap.set("t", "<C-k>", function()
            --     require("toggleterm").toggle(Nil, Nil, Nil, "vertical")
            -- end)
            -- vim.keymap.set("n", "<C-o>", function()
            --     require("toggleterm").toggle(Nil, Nil, Nil, "horizontal")
            -- end)
            -- vim.keymap.set("i", "<C-o>", function()
            --     require("toggleterm").toggle(Nil, Nil, Nil, "horizontal")
            -- end)
            -- vim.keymap.set("t", "<C-o>", function()
            --     require("toggleterm").toggle(Nil, Nil, Nil, "horizontal")
            -- end)

            vim.keymap.set("v", "<leader>s", function()
                require("toggleterm").send_lines_to_terminal("visual_lines",
                                                             trim_spaces, {
                    args = vim.v.count
                })
            end)
        end
    }
}
