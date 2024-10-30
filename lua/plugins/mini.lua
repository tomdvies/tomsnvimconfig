return {
    {
        'echasnovski/mini.basics',
        version = '*',
        config = function()
            require("mini.basics").setup({mappings = {windows = true}})
        end
    },
    {
        'echasnovski/mini.cursorword',
        config = function()
            require("mini.cursorword").setup()
        end
    }
}
