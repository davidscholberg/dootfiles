local vscode = require("vscode")
vscode.setup({
    -- prevent theme from touching terminal colors
    terminal_colors = false,
})
vscode.load()
