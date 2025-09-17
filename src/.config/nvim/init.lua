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
vim.keymap.set("n", "<leader>ly", "0vg_\"+y", {})
vim.keymap.set("v", "<leader>ly", "0vg_\"+y", {})
vim.keymap.set("n", "<leader>/", ":nohlsearch<CR>", {})
vim.keymap.set("n", "<leader>`", ":b#<CR>", {})
vim.keymap.set("i", "<C-c>", "<Esc>", {})
vim.keymap.set("n", "<C-f>", "<C-d>zz", {})
vim.keymap.set("n", "<C-b>", "<C-u>zz", {})

-- Scroll type shit
vim.opt.wrap = false
vim.keymap.set("n", "<M-h>", "zh", {})
vim.keymap.set("n", "<M-j>", "<C-e>", {})
vim.keymap.set("n", "<M-k>", "<C-y>", {})
vim.keymap.set("n", "<M-l>", "zl", {})
vim.opt.list = true
vim.opt.listchars = {extends = ">", precedes = "<"}
vim.opt.fillchars = {eob = " "}

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

-- Allow project-specific configs to be loaded
vim.opt.exrc = true
vim.opt.secure = true

-- Make floating window styling more consistent
vim.api.nvim_set_hl(0, "NormalFloat", {link = "Normal"})

-- Set/modify colors for better syntax highlighting
local colors = require("include.colors")
vim.api.nvim_set_hl(0, "Statement", {fg = colors.lavender})
vim.api.nvim_set_hl(0, "Constant", {fg = colors.orange})
vim.api.nvim_set_hl(0, "PreProc", {fg = colors.orange})
vim.api.nvim_set_hl(0, "Type", {fg = colors.green})
vim.api.nvim_set_hl(0, "Special", {fg = colors.green})
vim.api.nvim_set_hl(0, "String", {fg = colors.light_green})
vim.api.nvim_set_hl(0, "Identifier", {link = "@variable"})
vim.api.nvim_set_hl(0, "@variable.builtin", {link = "@variable"})
vim.api.nvim_set_hl(0, "@constructor", {link = "Function"})
vim.api.nvim_set_hl(0, "@function.builtin", {link = "Function"})
vim.api.nvim_set_hl(0, "@string.regexp", {link = "String"})
vim.api.nvim_set_hl(0, "@string.escape", {link = "Constant"})
vim.api.nvim_set_hl(0, "@constant.builtin", {link = "Constant"})
vim.api.nvim_set_hl(0, "@type.builtin", {link = "Type"})

-- Load plugin spec
require("include.paq_spec")

-- Do plugin-specific setup
require("plugin_config")

-- Load miscellaneous scripts
require("scripts")
