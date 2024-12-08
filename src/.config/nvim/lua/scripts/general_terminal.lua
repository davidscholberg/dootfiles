-- Create general terminal buffer and assign key combo to focus it.

local terminals = require("include.terminals")

vim.keymap.set(
    "n",
    "<leader>1",
    function ()
        terminals.focus("general")
    end,
    {}
)

