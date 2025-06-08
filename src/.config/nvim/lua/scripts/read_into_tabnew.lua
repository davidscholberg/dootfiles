-- Put contents of shell command into scratch buffer in new tab
vim.api.nvim_create_user_command(
    "ReadIntoTabNew",
    function (opts)
        vim.cmd.tabnew()
        vim.wo.relativenumber = false
        vim.wo.number = false

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
        desc = "Read shell command output into a scratch buffer in new tab",
        nargs = 1,
    }
)
