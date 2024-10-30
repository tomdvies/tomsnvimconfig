return {
    {
        "miikanissi/modus-themes.nvim",
        priority = 1000,
        config = function()
            require("modus-themes").setup({
                variant = "default",
                on_colours = function(colors)
                    colors.bg_active = "#000000"
                end
            })
        end
    }
}
