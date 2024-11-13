return {
    {
        "saecki/live-rename.nvim",
        config = function()
            local live_rename = require("live-rename")
            live_rename.setup({})
            -- the following are equivalent
            vim.keymap.set("n", "<leader>z", live_rename.map({insert = true}),
                           {desc = "LSP rename"})
        end
    }
}
