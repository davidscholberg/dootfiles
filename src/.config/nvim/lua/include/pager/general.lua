local colors = require("include.colors")

vim.api.nvim_create_autocmd(
    "BufWinEnter",
    {
        desc = "Set buffer to behave as a general pager",
        callback = function(event)
            vim.api.nvim_set_option_value("filetype", "", {buf = event.buf})
            local win = vim.fn.bufwinid(event.buf)
            vim.api.nvim_set_option_value("number", false, {win = win})
            vim.api.nvim_set_option_value("relativenumber", false, {win = win})

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
                        color = {fg = colors.light_grey, gui = "bold"},
                    }},
                    lualine_b = {},
                    lualine_x = {},
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
                        color = {fg = colors.light_grey, gui = "bold"},
                    }},
                },
            })
        end
    }
)
