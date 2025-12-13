-- Disable netrw to make way for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Map leader to space
vim.g.mapleader = " "

-- Disable intro message
vim.opt.shortmess:append("I")

-- General keybindings
vim.keymap.set("n", "<leader>a", "ggVG", {})
vim.keymap.set("n", "<leader>y", "\"+y", {})
vim.keymap.set("v", "<leader>y", "\"+y", {})
vim.keymap.set("n", "<leader>/", ":nohlsearch<CR>", {})
vim.keymap.set("n", "<leader>`", ":b#<CR>", {})
vim.keymap.set("i", "<C-c>", "<Esc>", {})

-- Scroll type shit
vim.opt.wrap = false
vim.keymap.set("n", "<C-h>", "<ScrollWheelLeft>", {})
vim.keymap.set("n", "<C-j>", "<ScrollWheelDown>", {})
vim.keymap.set("n", "<C-k>", "<ScrollWheelUp>", {})
vim.keymap.set("n", "<C-l>", "<ScrollWheelRight>", {})
vim.opt.list = true
vim.opt.listchars = {extends = ">", precedes = "<"}
vim.opt.fillchars = {eob = " "}
vim.cmd("autocmd FileType markdown,text setlocal wrap linebreak")

-- Window handling
vim.keymap.set("n", "<M-h>", "<C-w>h", {})
vim.keymap.set("n", "<M-j>", "<C-w>j", {})
vim.keymap.set("n", "<M-k>", "<C-w>k", {})
vim.keymap.set("n", "<M-l>", "<C-w>l", {})
vim.keymap.set("n", "<leader>w", function ()
    -- close the first floating window found
    for _, win_id in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_config(win_id).relative ~= "" then
            vim.api.nvim_win_close(win_id, true)
            break
        end
    end
end, {})

-- Tab handling
vim.keymap.set("n", "<leader>z", ":$tab split<CR>", {})
vim.api.nvim_command("autocmd TabClosed * tabprevious")

-- Terminal settings
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", {})
vim.api.nvim_command("autocmd TermOpen * setlocal nonumber norelativenumber scrolloff=0")

-- Line settings
vim.wo.relativenumber = true
vim.wo.number = true

-- Global tab and indent settings
vim.o.smartindent = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 0
vim.o.shiftwidth = 0
vim.o.shiftround = true

-- Language-specific tab and indent settings
vim.api.nvim_command("autocmd FileType haskell setlocal tabstop=2")

-- Allow project-specific configs to be loaded
vim.opt.exrc = true
vim.opt.secure = true

-- Set custom colorscheme
require("include.colorscheme")

-- Load plugin spec
require("include.paq_spec")

-- Do plugin-specific setup
require("plugin_config")

-- Load miscellaneous scripts
require("scripts")
