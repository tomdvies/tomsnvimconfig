-- GLOBAL NVIM OPTIONS - loaded after all plugins
-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- global status line
-- vim.opt.laststatus = 3
-- more colours
vim.opt.termguicolors = true

-- escape to exit term mode
vim.api.nvim_set_keymap("t", "<ESC>", "<C-\\><C-n>", {noremap = true})
vim.api.nvim_command("autocmd TermOpen * setlocal nonumber") -- no numbers
vim.api.nvim_command("autocmd TermEnter * setlocal signcolumn=no")

-- editing config
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.shiftwidth = 4
-- vim.o.relativenumber = true

-- set the theme
vim.opt.background = "dark" -- set this to dark or light
vim.cmd.colorscheme("modus")
-- some themes overwrite this so reset mini cursorword highlighting
vim.cmd("hi clear MiniCursorword")
vim.cmd("hi clear MiniCursorwordCurrent")
vim.cmd("hi MiniCursorwordCurrent gui=underline cterm=underline")
vim.cmd("hi MiniCursorword gui=underline cterm=underline")
-- vim.cmd("hi clear NvimTreeSpecialFile")
-- vim.cmd("hi NvimTreeSpecialFile guifg=#ff80ff")
vim.cmd(
    "hi Pmenu ctermfg=254 ctermbg=237 cterm=NONE guifg=#e1e1e1 guibg=#383838 gui=NONE")
vim.cmd(
    "hi PmenuSel ctermfg=135 ctermbg=239 cterm=NONE guifg=#b26eff guibg=#4e4e4e gui=NONE")
vim.cmd("hi NvimTreeNormal guifg=NONE guibg=NONE")
vim.cmd("hi NvimTreeNormalNC guifg=NONE guibg=NONE")
vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
vim.cmd("hi NormalNC guibg=NONE ctermbg=NONE")
vim.cmd("set mouse-=a")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "r",
    command = "setlocal shiftwidth=2 tabstop=2"
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    command = "setlocal shiftwidth=2 tabstop=2"
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "latex",
    command = "setlocal shiftwidth=2 tabstop=2"
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "c",
    command = "setlocal shiftwidth=2 tabstop=2"
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "html",
    command = "setlocal shiftwidth=2 tabstop=2"
})

-- Enable relative line numbers
-- vim.opt.number = true
vim.opt.relativenumber = true
-- vim.o.statuscolumn = "%s %l %r"
vim.opt.scrolloff = 10
