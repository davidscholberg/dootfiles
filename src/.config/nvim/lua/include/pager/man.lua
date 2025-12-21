local colors = require("include.colors")

vim.api.nvim_create_autocmd(
    "BufWinEnter",
    {
        desc = "Set buffer to behave as a pager for man",
        callback = function(event)
            vim.api.nvim_set_option_value("filetype", "man", {buf = event.buf})

            -- Push buffer contents through term to render ANSI escape codes
            local lines = vim.api.nvim_buf_get_lines(event.buf, 0, -1, false)
            vim.api.nvim_buf_set_lines(event.buf, 0, -1, false, {})
            vim.api.nvim_chan_send(vim.api.nvim_open_term(event.buf, {}), table.concat(lines, "\n"))

            vim.api.nvim_set_option_value("modifiable", false, {buf = event.buf})

            vim.keymap.set("n", "q", "<cmd>qa<cr>", { silent = true, buffer = event.buf })

            require("lualine").setup({
                sections = {
                    lualine_a = {{
                        "mode",
                        fmt = function() return "pager" end,
                        color = {bg = colors.light_grey, gui = "bold"},
                    }},
                    lualine_b = {},
                    lualine_x = {},
                    lualine_y = {{
                        "progress",
                        color = {fg = colors.light_grey},
                    }},
                    lualine_z = {{
                        "location",
                        color = {bg = colors.light_grey, gui = "bold"},
                    }},
                },
            })
        end
    }
)
