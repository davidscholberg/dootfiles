local custom_codedark = require("lualine.themes.codedark")
custom_codedark.terminal = custom_codedark.insert

require("lualine").setup({
    options = {
        theme = custom_codedark,
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
