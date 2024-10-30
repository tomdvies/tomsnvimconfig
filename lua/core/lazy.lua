-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.cmd("set mouse = ")
-- Use a protected call so we don't error out on first use
local ok, lazy = pcall(require, "lazy")
if not ok then
	return
end

-- We have to set the leader key here for lazy.nvim to work
vim.g.mapleader = ","

-- Load plugins from specifications
-- (The leader key must be set before this)
lazy.setup("plugins")

-- Might as well set up an easy-access keybinding
vim.keymap.set('n', '<Leader>L', lazy.show ,{desc= "Show Lazy"})

