-- Diagnostic keymaps
vim.keymap.set('n', 'gx', vim.diagnostic.open_float, {desc = "Show diagnostics under cursor"})

-- Deleting buffers
local buffers = require("helpers.buffers")
vim.keymap.set("n", "<leader>db", buffers.delete_this, {desc="Current buffer"})
vim.keymap.set("n", "<leader>do", buffers.delete_others, {desc="Other buffers"})
vim.keymap.set("n", "<leader>da", buffers.delete_all, {desc="All buffers"})

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>")
vim.keymap.set("n", "<S-h>", ":bprevious<CR>")

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Clear after search
vim.keymap.set("n", "<leader>ur", "<cmd>nohl<cr>", {desc = "Clear highlights"})
