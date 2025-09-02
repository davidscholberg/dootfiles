-- Disable netrw to make way for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Map leader to space
vim.g.mapleader = " "

-- General keybindings
vim.keymap.set("n", "<leader>a", "ggVG", {})
vim.keymap.set("n", "<leader>y", "\"+y", {})
vim.keymap.set("v", "<leader>y", "\"+y", {})
vim.keymap.set("n", "<leader>ly", "0vg_\"+y", {})
vim.keymap.set("v", "<leader>ly", "0vg_\"+y", {})
vim.keymap.set("n", "<leader>/", ":nohlsearch<CR>", {})
vim.keymap.set("n", "<leader>`", ":b#<CR>", {})
vim.keymap.set("i", "<C-c>", "<Esc>", {})
vim.keymap.set("n", "<C-f>", "<C-d>zz", {})
vim.keymap.set("n", "<C-b>", "<C-u>zz", {})

-- Scroll type shit
vim.opt.wrap = false
vim.opt.colorcolumn = "100"
vim.keymap.set("n", "<M-h>", "zh", {})
vim.keymap.set("n", "<M-j>", "<C-e>", {})
vim.keymap.set("n", "<M-k>", "<C-y>", {})
vim.keymap.set("n", "<M-l>", "zl", {})
vim.opt.list = true
vim.opt.listchars = {extends = ">", precedes = "<"}

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", {})
vim.keymap.set("n", "<C-j>", "<C-w>j", {})
vim.keymap.set("n", "<C-k>", "<C-w>k", {})
vim.keymap.set("n", "<C-l>", "<C-w>l", {})

-- Tab handling
vim.keymap.set("n", "<leader>z", ":$tab split<CR>", {})
vim.keymap.set("n", "<leader>t", ":tabnew<CR>", {})
vim.keymap.set("n", "<leader>w", ":tabclose<CR>", {})
vim.api.nvim_command("autocmd TabClosed * tabprevious")

-- Terminal settings
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", {})
vim.api.nvim_command("autocmd TermOpen * setlocal nonumber norelativenumber scrolloff=0")

-- Line settings
vim.wo.relativenumber = true
vim.wo.number = true
vim.o.scrolloff = 10

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
