-- Open terminal in vnew to the right of current buffer with given command and set to autoscroll.
vim.api.nvim_create_user_command(
    "TerminalVNew",
    function (opts)
        -- Split new buffer to the right of the current one
        local original_splitright = vim.o.splitright
        vim.o.splitright = true
        vim.cmd.vnew()
        vim.o.splitright = original_splitright

        -- Open terminal, set cursor to the end to autoscroll, and switch to left buffer.
        vim.cmd("terminal " .. opts.fargs[1])
        vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("G<C-w>h", true, false, true),
            "x",
            true
        )
    end,
    {
        desc = "Open terminal to the right with given command and set to autoscroll",
        nargs = 1,
    }
)

