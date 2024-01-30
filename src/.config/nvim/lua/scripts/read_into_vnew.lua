-- Put contents of shell command into vnew to the right of current buffer
vim.api.nvim_create_user_command(
    "ReadIntoVNew",
    function (opts)
        -- Split new buffer to the right of the current one
        local original_splitright = vim.o.splitright
        vim.o.splitright = true
        vim.cmd.vnew()
        vim.o.splitright = original_splitright

        -- Set the new buffer to be a scratch buffer
        vim.bo.bufhidden = "delete"
        vim.bo.buftype = "nofile"
        vim.bo.swapfile = false

        -- Read the output of the given shell command into the new buffer and
        -- set to read only
        vim.cmd("read! " .. opts.fargs[1])
        vim.api.nvim_feedkeys("ggdd", "x", true)
        vim.bo.readonly = true
    end,
    {
        desc = "Read shell command output into a scratch buffer to the right",
        nargs = 1,
    }
)
