-- Here we extend/modify the default colorscheme.

local colors = require("include.colors")

-- Syntax highlighting shiz
vim.api.nvim_set_hl(0, "Function", {fg = colors.dark_cyan})
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
vim.api.nvim_set_hl(0, "@string.escape", {link = "String"})
vim.api.nvim_set_hl(0, "@character", {link = "String"})
vim.api.nvim_set_hl(0, "@constant.builtin", {link = "Constant"})
vim.api.nvim_set_hl(0, "@type.builtin", {link = "Type"})

-- Window styling shiz
vim.api.nvim_set_hl(0, "NormalFloat", {link = "Normal"})
vim.api.nvim_set_hl(0, "WinSeparator", {fg = colors.dark_grey})
vim.api.nvim_set_hl(0, "FloatBorder", {link = "WinSeparator"})
vim.api.nvim_set_hl(0, "TelescopeBorder", {link = "FloatBorder"})
vim.api.nvim_set_hl(0, "TelescopeTitle", {fg = "NvimLightGrey4"})
