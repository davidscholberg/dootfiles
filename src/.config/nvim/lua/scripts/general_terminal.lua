-- Create general terminal buffer with key combo to focus it.

require("include.terminals").setup({
    {
        name = "general",
        focus_key_binding = "<leader>1",
    },
})
