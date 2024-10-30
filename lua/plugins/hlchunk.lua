return {
    {
        -- this highlights indent chunks
        "shellRaining/hlchunk.nvim",
        event = {"BufReadPre", "BufNewFile"},
        config = function()
            require("hlchunk").setup({
                chunk = {enable = true},
                indent = {enable = true}
            })
        end,
        enabled = true
    }, {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
        enabled = false
    }
}
