-- Convenience functions for creating named terminal buffers.

local M = {}

local terminals = {}

-- Gets bufnr of terminal buffer associated with name. Returns -1 if the buffer doesn't exist.
local function get_terminal_bufnr(name)
    if terminals[name] ~= nil then
        local bufnr = terminals[name].bufnr

        if vim.api.nvim_buf_is_loaded(bufnr) then
            return bufnr
        end
    end

    return -1
end

-- Get name of shell used in terminals. For now assumes that only the global value is used.
function M.get_shell_name()
    return vim.fs.basename(vim.o.shell):gsub([[(.+)%.exe]], "%1")
end

-- Returns the appropriate line ending to use depending on what shell is being used.
function M.get_shell_line_ending()
    local shell_name = M.get_shell_name()

    if
        shell_name == "cmd"
        or shell_name == "powershell"
        or shell_name == "pwsh"
    then
        return "\r\n"
    end

    return "\n"
end

-- Focus the terminal associated with the given name. Creates terminal if it doesn't exist.
function M.focus(name)
    local bufnr = get_terminal_bufnr(name)

    if bufnr ~= -1 then
        vim.cmd.buffer(bufnr)
    else
        vim.cmd.terminal()
        bufnr = vim.fn.bufnr()
        terminals[name] = {
            bufnr = bufnr,
            channel = vim.api.nvim_get_option_value("channel", {buf = bufnr}),
        }
    end
end

-- Focus the named terminal and run the command on it. Creates terminal if it doesn't exist.
function M.execute(name, cmd)
    -- Ensure we're in normal mode because otherwise nvim gets wonky when the feedkeys call happens
    -- below and we're still in insert mode.
    vim.cmd.stopinsert()

    -- Defer next calls because I think insert mode won't stop until the next event loop cycle.
    vim.defer_fn(
        function()
            M.focus(name)
            vim.api.nvim_feedkeys("G", "x", true)
            vim.api.nvim_chan_send(terminals[name].channel, cmd .. M.get_shell_line_ending())
        end,
        0
    )
end

return M
