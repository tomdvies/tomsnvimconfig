-- return {
--     {
--         'nvim-telescope/telescope.nvim',
--         dependencies = {'nvim-lua/plenary.nvim'}
--     }
-- }
return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-fzf-native.nvim' -- Optional: For faster fuzzy finding
        },
        config = function()
            local telescope = require('telescope')
            local actions = require('telescope.actions')
            local pickers = require('telescope.pickers')
            local finders = require('telescope.finders')
            local conf = require('telescope.config').values

            -- Setup Telescope
            telescope.setup({
                defaults = {
                    layout_strategy = 'vertical',
                    layout_config = {width = 0.9, height = 0.9},
                    border = true,
                    borderchars = {
                        '─', '│', '─', '│', '╭', '╮', '╯', '╰'
                    }
                },
                pickers = {
                    live_grep = {theme = 'dropdown'},
                    find_files = {theme = 'dropdown'}
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = 'smart_case'
                    }
                }
            })

            -- Load Telescope extensions
            telescope.load_extension('fzf') -- Optional: For faster fuzzy finding

            -- Custom function to search LSP documentation
            local function search_lsp_docs()
                local params = vim.lsp.util.make_position_params()
                vim.lsp.buf_request(0, 'textDocument/hover', params,
                                    function(err, result, ctx, config)
                    if err then
                        vim.notify('Error fetching documentation: ' ..
                                       err.message, vim.log.levels.ERROR)
                        return
                    end
                    if not result or not result.contents then
                        vim.notify('No documentation found', vim.log.levels.INFO)
                        return
                    end

                    -- Extract the contents of the hover response
                    local contents = result.contents
                    if type(contents) == 'table' then
                        contents = vim.lsp.util.convert_input_to_markdown_lines(
                                       contents)
                    elseif type(contents) == 'string' then
                        contents = {contents}
                    end

                    -- Create a Telescope picker to display the documentation
                    pickers.new({}, {
                        prompt_title = 'LSP Documentation',
                        finder = finders.new_table({results = contents}),
                        sorter = conf.generic_sorter({}),
                        previewer = conf.grep_previewer({}),
                        attach_mappings = function(prompt_bufnr, map)
                            actions.select_default:replace(function()
                                actions.close(prompt_bufnr)
                            end)
                            return true
                        end
                    }):find()
                end)
            end

            -- Keybindings
            local map = vim.keymap.set
            map('n', '<leader>fd',
                '<cmd>Telescope current_buffer_fuzzy_find<CR>',
                {desc = 'Search docstrings in current buffer'})
            map('n', '<leader>sd',
                '<cmd>Telescope live_grep cwd=~/path/to/docs<CR>',
                {desc = 'Search documentation files'})
            map('n', '<leader>od', search_lsp_docs,
                {desc = 'Search LSP documentation'})
            map('n', '<leader>hh', '<cmd>Telescope help_tags<CR>',
                {desc = 'Search Neovim help tags'})
        end
    }, {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make' -- Build the fzf-native extension
    }
}
