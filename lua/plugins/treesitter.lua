return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "c", "lua", "vim", "vimdoc", "query", "elixir", "heex",
                    "javascript", "html", "python", "r", "rust", "cpp"
                },
                sync_install = false,
                highlight = {enable = true},
                indent = {enable = true}
            })
        end
    }, {
        "folke/ts-comments.nvim",
        opts = {},
        enabled = vim.fn.has("nvim-0.10.0") == 1
    }
}
