-- Create general terminal buffer and assign key combo to focus it.
-- This script requires the kassio/neoterm plugin.

local terminal_id = 0

vim.keymap.set(
    "n",
    "<leader>1",
    function ()
        if terminal_id == 0 then
            local tls_output = vim.api.nvim_exec2("Tls", {output = true}).output
            local _, newline_count = tls_output:gsub("\n", "\n")
            terminal_id = newline_count + 1
        end
        vim.cmd(tostring(terminal_id) .. "Topen")
    end,
    {}
)

