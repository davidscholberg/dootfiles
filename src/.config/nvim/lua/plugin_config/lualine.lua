local colors = require("include.colors")

local custom_theme = {
    normal = {
        a = {bg = colors.dark_grey, fg = colors.green, gui = "bold"},
        b = {bg = colors.dark_grey, fg = colors.light_grey},
        c = {bg = colors.dark_grey, fg = colors.light_grey},
        y = {bg = colors.dark_grey, fg = colors.light_grey},
    },
}

custom_theme.insert = vim.deepcopy(custom_theme.normal)
custom_theme.insert.a.fg = colors.lavender

custom_theme.visual = vim.deepcopy(custom_theme.normal)
custom_theme.visual.a.fg = colors.orange

custom_theme.command = vim.deepcopy(custom_theme.normal)
custom_theme.command.a.fg = colors.darker_cyan

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
        lualine_b = {'diagnostics'},
        lualine_c = {{
            "filename",
            path = 1,
            fmt = function (s)
                if s:find("^term://") then
                    local terminal_name = require("include.terminals").get_terminal_name(vim.fn.bufnr())
                    if terminal_name then
                        return "term://" .. terminal_name
                    end
                    return "term://unnamed"
                end
                return s
            end
        }},
        lualine_x = {'fileformat'},
        lualine_y = {
            function ()
                return tostring(vim.fn.line("$")) .. "L"
            end
        },
        lualine_z = {{
            "location",
            fmt = function(s)
                return s:gsub("^%s*(.-):(.-)%s*$", "%1,%2")
            end,
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
