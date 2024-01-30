-- General keybindings
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", ":Explore<CR>", {})

-- Enable relative line numbers with absolute line number for current line
vim.wo.relativenumber = true
vim.wo.number = true

-- Global tab and indent settings
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 0
vim.o.shiftwidth = 0
vim.o.shiftround = true

-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Setup and configure plugins
require("lazy").setup("plugins")

-- Load miscellaneous scripts
require("scripts")
