vim.api.nvim_create_user_command(
    "HelpNoSplit",
    function (opts)
        vim.cmd("help " .. opts.args)

        local below_window_nr = vim.fn.winnr("j")
        local current_window_nr = vim.fn.winnr()

        if below_window_nr ~= 0 and below_window_nr ~= current_window_nr then
            vim.cmd(below_window_nr .. "close")
        end
    end,
    {
        desc = "Help function that closes the window below (if any) to simulate help opening in the current window.",
        nargs = "?",
        bar = true,
        complete = "help",
    }
)

vim.keymap.set("n", "<leader>h", ":HelpNoSplit ", {})
