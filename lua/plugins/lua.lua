return {
    {
        "bfredl/nvim-luadev",
        ft = "lua",
        keys = {
            -- Evaluate the current line
            { "<leader>ul", "<Plug>(Luadev-RunLine)", desc = "Run Lua Line" },
            -- Evaluate the current word (e.g., a function name)
            { "<leader>ue", "<Plug>(Luadev-RunWord)", desc = "Evaluate Lua Word" },
            -- Evaluate a motion (e.g., `<leader>raj` to evaluate next j lines)
            { "<leader>up", "<Plug>(Luadev-Run)", desc = "Run Lua Motion", mode = {"n", "v"} },
            -- Evaluate a visual selection
            { "<leader>ub", "<Plug>(Luadev-RunBlock)", desc = "Run Lua Block", mode = "v" },
        },
        config = function()
            -- Optional: Set up a command to open the Lua REPL
            vim.api.nvim_create_user_command("LuaRun", function(opts)
                require("luadev").exec(opts.args)
            end, {nargs = "*"})
        end
    }
}


