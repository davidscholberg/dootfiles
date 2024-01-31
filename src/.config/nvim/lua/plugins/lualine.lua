return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local custom_vscode = require("lualine.themes.vscode")
            custom_vscode.normal.a.bg = "1d60bf"
            custom_vscode.normal.b.fg = "#9cdcfe"
            require("lualine").setup({
                options = {
                    theme = custom_vscode,
                },
                sections = {
                    lualine_c = {{
                        "filename",
                        path = 1,
                    }},
                },
                inactive_sections = {
                    lualine_c = {{
                        "filename",
                        path = 1,
                    }},
                },
            })
        end,
    }
}
