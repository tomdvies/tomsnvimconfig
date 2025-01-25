-- I should move to heirline
return {
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {'nvim-tree/nvim-web-devicons', 'folke/noice.nvim'},
        config = function()
            local colors = {
                blue = '#80a0ff',
                cyan = '#79dac8',
                black = '#080808',
                white = '#c6c6c6',
                red = '#ff5189',
                violet = '#d183e8',
                grey = '#303030',
                innerbg = '#080808'
            }

            local bubbles_theme = {
                normal = {
                    a = {fg = colors.black, bg = colors.violet},
                    b = {fg = colors.white, bg = colors.grey},
                    c = {fg = colors.white, bg = colors.innerbg}
                },

                insert = {a = {fg = colors.black, bg = colors.blue}},
                visual = {a = {fg = colors.black, bg = colors.cyan}},
                replace = {a = {fg = colors.black, bg = colors.red}},

                inactive = {
                    a = {fg = colors.white, bg = colors.black},
                    b = {fg = colors.white, bg = colors.black},
                    c = {fg = colors.white, bg = colors.innerbg}
                }
            }
            local function getWords()
                local wc = vim.fn.wordcount()
                if vim.fn.mode():find('[vV]') then
                    -- Return visual selection word count if in visual mode
                    return tostring(wc.visual_words or 0)
                else
                    -- Return total word count otherwise
                    return tostring(wc.words)
                end
            end

            require('lualine').setup({
                options = {
                    icons_enabled = true,
                    theme = bubbles_theme,
                    component_separators = '', -- {left = '', right = ''},
                    section_separators = {left = '', right = ''},
                    disabled_filetypes = {statusline = {}, winbar = {}},
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {statusline = 1000, tabline = 1000, winbar = 1000}
                },
                sections = {
                    lualine_a = {
                        {'mode', separator = {left = ''}, right_padding = 2}
                    },
                    lualine_b = {'branch', 'diff', 'diagnostics'},
                    lualine_c = {'filename'},
                    lualine_x = {
                        'encoding', 'filetype', {
                            require("noice").api.status.command.get,
                            cond = require("noice").api.status.command.has,
                            color = {fg = "#ff9e64"}
                        }
                    },
                    lualine_y = {'progress', getWords},
                    lualine_z = {
                        {
                            'location',
                            separator = {right = ''},
                            left_padding = 2
                        }
                    }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {'filename'},
                    lualine_x = {'location'},
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {"nvim-tree", "toggleterm"}
            })
        end
    }
}
