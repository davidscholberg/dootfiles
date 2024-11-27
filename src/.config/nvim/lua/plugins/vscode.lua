return {
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("vscode").setup({
                -- prevent theme from touching terminal colors
                terminal_colors = false,
            })
            require("vscode").load()
        end,
    }
}

