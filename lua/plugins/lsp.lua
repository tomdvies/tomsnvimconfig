return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason.nvim",
            {"williamboman/mason-lspconfig.nvim", config = function() end}
        },
        ---@param opts PluginLspOpts
        config = function(_, opts)
            local lspCapabilities = vim.lsp.protocol.make_client_capabilities()
            lspCapabilities.textDocument.completion.completionItem
                .snippetSupport = true
            
            -- Rust
            require("lspconfig").rust_analyzer.setup({
                ---@param client lsp.Client
                settings = {
                    ["rust-analyzer"] = {
                        check = {
                            -- ignore = {"unused_imports", "unused_variables"};
                        }
                    }
                }
            })

            -- R - needs to be installed from R directly
            require("lspconfig").r_language_server.setup({})
            
        end
    }
}
