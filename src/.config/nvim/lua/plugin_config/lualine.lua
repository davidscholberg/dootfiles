local colors = require("include.colors")

local custom_theme = {
    normal = {
        a = {bg = colors.green, fg = colors.dark_grey, gui = "bold"},
        b = {bg = colors.dark_grey, fg = colors.green},
        c = {bg = colors.dark_grey, fg = colors.light_grey},
    },
}

custom_theme.insert = vim.deepcopy(custom_theme.normal)
custom_theme.insert.a.bg = colors.lavender
custom_theme.insert.b.fg = colors.lavender

custom_theme.visual = vim.deepcopy(custom_theme.normal)
custom_theme.visual.a.bg = colors.orange
custom_theme.visual.b.fg = colors.orange

custom_theme.command = vim.deepcopy(custom_theme.normal)
custom_theme.command.a.bg = colors.dark_cyan
custom_theme.command.b.fg = colors.dark_cyan

custom_theme.replace = vim.deepcopy(custom_theme.visual)
custom_theme.terminal = vim.deepcopy(custom_theme.insert)

require("lualine").setup({
    options = {
        theme = custom_theme,
        always_show_tabline = false,
        section_separators = "",
        component_separators = "",
        icons_enabled = false,
        globalstatus = true,
        ignore_focus = {
        },
    },
    sections = {
        lualine_a = {{
            "mode",
            fmt = string.lower,
        }},
        lualine_b = {'branch', 'diagnostics'},
        lualine_c = {{
            "filename",
            path = 1,
        }},
        lualine_x = {'encoding', 'fileformat'},
    },
    inactive_sections = {
        lualine_c = {{
            "filename",
            path = 1,
        }},
    },
    tabline = {
        lualine_a = {{
            'tabs',
            mode = 2,
            use_mode_colors = false,
        }},
    },
})

-- Disable default mode indicator
vim.opt.showmode = false
