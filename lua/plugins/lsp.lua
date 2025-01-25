-- return {
--     {
--         "neovim/nvim-lspconfig",
--         dependencies = {
--             "mason.nvim",
--             {"williamboman/mason-lspconfig.nvim", config = function() end}
--         },
--         ---@param opts PluginLspOpts
--         config = function(_, opts)
--             local lspCapabilities = vim.lsp.protocol.make_client_capabilities()
--             lspCapabilities.textDocument.completion.completionItem
--                 .snippetSupport = true
--
--             -- Rust
--             require("lspconfig").rust_analyzer.setup({
--                 ---@param client lsp.Client
--                 settings = {
--                     ["rust-analyzer"] = {
--                         check = {
--                             -- ignore = {"unused_imports", "unused_variables"};
--                         }
--                     }
--                 }
--             })
--             -- require("lspconfig")["pyright"].setup({
--             --     on_attach = on_attach,
--             --     capabilities = capabilities,
--             --     settings = {
--             --         python = {
--             --             analysis = {
--             --                 diagnosticSeverityOverrides = {
--             --                     reportUnusedExpression = "none"
--             --                 }
--             --             }
--             --         }
--             --     }
--             -- })
--             -- require'lspconfig'.pylsp.setup({
--             --     on_attach = on_attach,
--             --     capabilities = require('cmp_nvim_lsp').default_capabilities(),
--             --     settings = {
--             --         pylsp = {
--             --             plugins = {
--             --                 pycodestyle = {
--             --                     -- ignore = {'W391'},
--             --                     maxLineLength = 100
--             --                 },
--             --                 jedi_completion = {enabled = true}, -- Enable Jedi-based completions
--             --                 jedi_hover = {enabled = true}, -- Enable hover documentation
--             --                 jedi_references = {enabled = true}, -- Enable references
--             --                 jedi_signature_help = {enabled = true}, -- Enable signature help
--             --                 -- pylint = {enabled = true}, -- Enable pylint for linting
--             --                 -- flake8 = {enabled = true}, -- Enable flake8 for linting
--             --                 black = {enabled = true} -- Enable black for formatting
--             --                 -- pylsp_mypy = {enabled = true} -- Enable mypy for type checking
--             --             }
--             --         }
--             --     }
--             -- })
--             require'lspconfig'.pylsp.setup({
--                 settings = {
--                     pylsp = {
--                         plugins = {
--                             -- Disable pylint/flake8
--                             pylint = {enabled = false},
--                             flake8 = {enabled = false},
--                             pycodestyle = {enabled = false}, -- Often redundant with ruff/flake8
--                             -- Enable ruff
--                             ruff = {
--                                 enabled = true,
--                                 -- extendSelect = {"I"}, -- Optional: Add ignored rules
--                                 lineLength = 100 -- Match your Black line length
--                             },
--                             black = {enabled = true},
--                             mypy = {enabled = true} -- Optional: Keep mypy for type checking
--                         }
--                     }
--                 }
--             })
--
--             require'lspconfig'.lua_ls.setup {}
--             require'lspconfig'.clangd.setup {
--                 cmd = {"/Users/idkwhotomis/llvm-mos/llvm-mos/bin/clangd"}
--             }
--             -- R - needs to be installed from R directly
--             require("lspconfig").r_language_server.setup({})
--             vim.keymap.set("n", "<leader>q",
--                            function() vim.diagnostic.open_float() end,
--                            {desc = "LSP messages"})
--
--             vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
--                 noremap = true,
--                 silent = true,
--                 desc = "Go to Definition"
--             })
--             vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, {
--                 noremap = true,
--                 silent = true,
--                 desc = "Go to Type Definition"
--             })
--             vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {
--                 noremap = true,
--                 silent = true,
--                 desc = "Go to Implementation"
--             })
--             vim.keymap.set('n', 'gr', vim.lsp.buf.references, {
--                 noremap = true,
--                 silent = true,
--                 desc = "Show References"
--             })
--             vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
--                 noremap = true,
--                 silent = true,
--                 desc = "Show Hover Documentation"
--             })
--             vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, {
--                 noremap = true,
--                 silent = true,
--                 desc = "Show Signature Help"
--             })
--         end
--     }
-- }
return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp"
        },
        config = function(_, _)
            -- Common capabilities with snippet support
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities.textDocument.completion.completionItem.snippetSupport =
                true
            capabilities = require('cmp_nvim_lsp').default_capabilities(
                               capabilities)

            -- Common on_attach function
            local on_attach = function(client, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc',
                                            'v:lua.vim.lsp.omnifunc')

                -- Mappings
                local opts = {buffer = bufnr, noremap = true, silent = true}
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', '<leader>f', function()
                    vim.lsp.buf.format({async = true})
                end, opts)
            end

            -- Rust
            require("lspconfig").rust_analyzer.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        check = {
                            command = "clippy",
                            extraArgs = {
                                "--all", "--", "-W", "clippy::pedantic"
                            }
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
            -- Configure Jedi, but DISABLE all features except hover
            -- require("lspconfig")["jedi_language_server"].setup({
            --     -- Disable Jedi's diagnostics, completions, etc.
            --     on_attach = function(client, bufnr)
            --         -- Disable everything except "hover"
            --         client.server_capabilities.completionProvider = nil
            --         client.server_capabilities.definitionProvider = nil
            --         client.server_capabilities.referencesProvider = nil
            --         client.server_capabilities.renameProvider = nil
            --         client.server_capabilities.codeActionProvider = nil
            --         client.server_capabilities.documentSymbolProvider = nil
            --         -- ... disable other unwanted capabilities
            --     end,
            --     -- Optional: Reduce noise from Jedi
            --     init_options = {
            --         disable = {
            --             -- Disable Jedi features you don’t want
            --             completion = true,
            --             diagnostics = true,
            --             references = true,
            --             rename = true,
            --             code_action = true
            --         }
            --     }
            -- })
            require("lspconfig")["pyright"].setup({
                on_attach = function(client, bufnr)
                    -- Disable hover for Pyright
                    client.server_capabilities.hoverProvider = false
                    -- Attach all other default handlers
                    on_attach(client, bufnr)
                end,
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

            -- -- Python (pylsp with enhanced config)
            require("lspconfig").pylsp.setup({
                on_init = function(client)
                    -- Log active plugins on server start
                    vim.notify("[pylsp] Initialized plugins:\n" ..
                                   vim.inspect(
                                       client.config.settings.pylsp.plugins))
                end,
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            jedi_completion = {enabled = false},
                            jedi_hover = {enabled = true},
                            jedi_references = {enabled = false},
                            jedi_signature_help = {enabled = false},
                            ruff = {
                                enabled = false,
                                extendSelect = {"ALL"},
                                format = {"ALL"}
                            },
                            -- ruff = {
                            --     enabled = true,
                            --     lineLength = 100,
                            --     extendSelect = {"I", "B", "F", "E"}
                            -- },
                            black = {enabled = true, line_length = 100},
                            pylsp_mypy = {
                                enabled = false,
                                live_mode = true,
                                dmypy = true,
                                strict = false
                            },
                            pycodestyle = {enabled = false},
                            flake8 = {enabled = false},
                            pylint = {enabled = false},
                            mccabe = {enabled = false},
                            pyflakes = {enabled = false}
                        }
                    }
                }
            })
            -- require('lspconfig').ruff.setup({
            --     init_options = {settings = {logLevel = 'debug'}}
            -- })

            -- Lua
            require("lspconfig").lua_ls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {version = "LuaJIT"},
                        diagnostics = {globals = {"vim"}},
                        workspace = {checkThirdParty = false},
                        telemetry = {enable = false}
                    }
                }
            })

            -- C/C++
            require("lspconfig").clangd.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = {"/Users/idkwhotomis/llvm-mos/llvm-mos/bin/clangd"}
            })

            -- R
            require("lspconfig").r_language_server.setup({
                on_attach = on_attach,
                capabilities = capabilities
            })

            -- Diagnostic config
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {border = "rounded"}
            })

            -- Diagnostic keymaps
            vim.keymap.set("n", "<leader>q", vim.diagnostic.open_float,
                           {desc = "LSP messages"})
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,
                           {desc = "Previous diagnostic"})
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
                           {desc = "Next diagnostic"})
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, {desc = "Float Docs"})
        end
    }
}
