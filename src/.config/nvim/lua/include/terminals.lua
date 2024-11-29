-- Convenience functions for creating terminal buffers (requires kassio/neoterm)

local M = {}

-- Opens a new terminal and returns its terminal id, which can be used to subsequently focus and send commands to the associated terminal.
-- The terminal id is an int greater than 0.
function M.open_new()
    local tls_output = vim.api.nvim_exec2("Tls", {output = true}).output
    local _, newline_count = tls_output:gsub("\n", "\n")
    local terminal_id = newline_count + 1

    vim.cmd("Tnew")
    return terminal_id
end

-- Focus the terminal associated with the given terminal id.
function M.focus(terminal_id)
    vim.cmd(tostring(terminal_id) .. "Topen")
end

return M
