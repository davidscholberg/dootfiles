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

-- style the floating window to match what telescope does
-- idk if it's just me but this highlight api seems fucky
local normal_bg = vim.api.nvim_get_hl(0, {name = "Normal"}).bg
vim.api.nvim_set_hl(0, "NvimTreeNormal", {bg = normal_bg})
vim.api.nvim_set_hl(0, "NvimTreeNormalFloat", {bg = normal_bg})
vim.api.nvim_set_hl(0, "NvimTreeNormalFloatBorder", {bg = normal_bg, fg = "#4d4d4d"})

vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<CR>", {})
