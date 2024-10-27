-- Set keybindings for cmake build and run within cmake project directories.
if vim.fn.filereadable(vim.fn.getcwd() .. "/CMakeLists.txt") == 1 then
    vim.keymap.set("n", "<leader>b", ":CMakeBuild<CR>", {})
    vim.keymap.set("n", "<leader>r", ":CMakeRun<CR>", {})
end
