return {
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim"
        },
        config = function()
            require("mason").setup()

            require("mason-lspconfig").setup({
                automatic_installation = true,
                ensure_installed = {
                    "cssls", "eslint", "html", "jsonls", "pyright",
                    "tailwindcss", "rust_analyzer", "taplo"
                }
            })

            require("mason-tool-installer").setup({
                ensure_installed = {
                    "prettier", "stylua", -- lua formatter
                    "clangd",
                    "luaformatter",
                    "isort", -- python formatter
                    "black", -- python formatter
                    "luaformatter",
                    "ruff-lsp", "pylint", "eslint_d", "lua-language-server"
                }
            })
        end
    }
}
