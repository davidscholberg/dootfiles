-- Create general terminal buffer and assign key combo to focus it.

local terminals = require("include.terminals")
local terminal_id = 0

vim.keymap.set(
    "n",
    "<leader>1",
    function ()
        if terminal_id == 0 then
            terminal_id = terminals.open_new()
        else
            terminals.focus(terminal_id)
        end
    end,
    {}
)

