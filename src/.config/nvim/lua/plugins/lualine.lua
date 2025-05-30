return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local custom_vscode = require("lualine.themes.vscode")
            custom_vscode.normal.a.bg = "#1d60bf"
            custom_vscode.normal.b.fg = "#9cdcfe"
            require("lualine").setup({
                options = {
                    theme = custom_vscode,
                    always_show_tabline = false,
                    section_separators = "",
                    component_separators = "",
                    icons_enabled = false,
                    globalstatus = true,
                    ignore_focus = {
                        "NvimTree",
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
                        tabs_color = {
                            active = {bg = custom_vscode.normal.a.bg, fg = '#ffffff', gui = ''},
                            inactive = {bg = '#333333', fg = '#666666', gui = ''},
                        },
                    }},
                },
            })
            -- Disable default mode indicator
            vim.opt.showmode = false
        end,
    }
}
