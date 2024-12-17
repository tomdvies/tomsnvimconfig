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
            require("lspconfig")["pyright"].setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            diagnosticSeverityOverrides = {
                                reportUnusedExpression = "none"
                            }
                        }
                    }
                }
            })
            require'lspconfig'.lua_ls.setup {}
            require'lspconfig'.clangd.setup {
                cmd = {"/Users/idkwhotomis/llvm-mos/llvm-mos/bin/clangd"}
            }
            -- R - needs to be installed from R directly
            require("lspconfig").r_language_server.setup({})
            vim.keymap.set("n", "<leader>q",
                           function() vim.diagnostic.open_float() end,
                           {desc = "LSP messages"})

            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
                noremap = true,
                silent = true,
                desc = "Go to Definition"
            })
            vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, {
                noremap = true,
                silent = true,
                desc = "Go to Type Definition"
            })
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {
                noremap = true,
                silent = true,
                desc = "Go to Implementation"
            })
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, {
                noremap = true,
                silent = true,
                desc = "Show References"
            })
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
                noremap = true,
                silent = true,
                desc = "Show Hover Documentation"
            })
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {
                noremap = true,
                silent = true,
                desc = "Show Signature Help"
            })
        end
    }
}
