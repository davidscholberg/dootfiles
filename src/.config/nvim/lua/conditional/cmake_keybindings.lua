-- Set keybinding to do cmake build in current project.
vim.keymap.set("n", "<leader>b", ":CmakeBuild<CR>", {})

-- Set keybinding to run a cmake target in current project.
vim.keymap.set("n", "<leader>r", ":CmakeRun<CR>", {})
