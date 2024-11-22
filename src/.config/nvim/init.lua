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
vim.keymap.set("n", "<leader>3", ":b#<CR>", {})
vim.keymap.set("i", "<C-c>", "<Esc>", {})
vim.keymap.set("n", "<C-f>", "<C-d>zz", {})
vim.keymap.set("n", "<C-b>", "<C-u>zz", {})

-- Split navigation
vim.keymap.set("n", "<leader>h", "<C-w>h", {})
vim.keymap.set("n", "<leader>j", "<C-w>j", {})
vim.keymap.set("n", "<leader>k", "<C-w>k", {})
vim.keymap.set("n", "<leader>l", "<C-w>l", {})

-- Tab handling
vim.keymap.set("n", "<leader>z", ":$tab split<CR>", {})
vim.keymap.set("n", "<leader>t", ":tabnew<CR>", {})
vim.keymap.set("n", "<leader>w", ":tabclose<CR>", {})
vim.api.nvim_command("autocmd TabClosed * tabprevious")

-- Terminal settings
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", {})
vim.api.nvim_command("autocmd TermOpen * startinsert")
vim.api.nvim_command("autocmd TermOpen * setlocal nonumber norelativenumber")
if vim.fn.has("win32") == 1 then
    -- taken from :help shell-powershell
    vim.o.shell = (vim.fn.executable("pwsh") == 1) and "pwsh" or "powershell"
    vim.o.shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[\'Out-File:Encoding\']=\'utf8\';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
    vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
    vim.o.shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
end

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

-- Load conditional scripts
require("conditional")
