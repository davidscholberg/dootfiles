-- Convenience functions for managing terminal buffers.

local M = {}

local terminals = {}

-- Gets bufnr of terminal buffer associated with name. Returns -1 if the buffer doesn't exist.
local function get_terminal_bufnr(name)
    local terminal = terminals[name]

    if terminal ~= nil and terminal.bufnr ~= nil then
        local bufnr = terminal.bufnr

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
        return "\r"
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
        if terminals[name] == nil then
            terminals[name] = {}
        end
        terminals[name].bufnr = bufnr
        terminals[name].channel = vim.api.nvim_get_option_value("channel", {buf = bufnr})
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

-- Setup keybindings to focus named terminals or run cmds in them.
-- Can be called multiple times and the configs will be merged.
function M.setup(terminal_configs)
    for _, terminal_config in ipairs(terminal_configs) do
        local terminal_name = terminal_config.name
        if terminals[terminal_name] == nil then
            terminals[terminal_name] = {}
        end

        local terminal = terminals[terminal_name]
        local old_config = terminal.config
        terminal.config = terminal_config

        if old_config ~= nil then
            if old_config.focus_key_binding ~= "" then
                vim.keymap.del("n", old_config.focus_key_binding)
            end

            if old_config.cmds ~= nil then
                for _, cmd_config in ipairs(old_config.cmds) do
                    if cmd_config.run_key_binding ~= "" then
                        vim.keymap.del("n", cmd_config.run_key_binding)
                    end
                end
            end
        end

        if
            terminal.config.focus_key_binding ~= nil
            and terminal.config.focus_key_binding ~= ""
        then
            vim.keymap.set(
                "n",
                terminal.config.focus_key_binding,
                function()
                    M.focus(terminal_name)
                end
            )
        end

        if terminal.config.cmds ~= nil then
            for _, cmd_config in ipairs(terminal.config.cmds) do
                if
                    cmd_config.run_key_binding ~= nil
                    and cmd_config.run_key_binding ~= ""
                then
                    vim.keymap.set(
                        "n",
                        cmd_config.run_key_binding,
                        function()
                            M.execute(terminal_name, cmd_config.cmd)
                        end
                    )
                end
            end
        end
    end
end

return M
