require("nvim-tree").setup({
    view = {
        width = {
            min = 30,
            max = -1,
        },
        preserve_window_proportions = true,
        float = {
            enable = true,
            quit_on_focus_loss = true,
        },
    },
    update_focused_file = {
        enable = true,
    },
    git = {
        enable = false,
    },
})

vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<CR>", {})
