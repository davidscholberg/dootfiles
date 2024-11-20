return {
    {
        "Civitasv/cmake-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local osys = require("cmake-tools.osys")
            require("cmake-tools").setup {
                cmake_regenerate_on_save = false,
                cmake_soft_link_compile_commands = false,
                cmake_compile_commands_from_lsp = true,
                cmake_build_directory = function()
                    if osys.iswin32 then
                        return "build\\${variant:buildType}"
                    end
                    return "build/${variant:buildType}"
                end,
                cmake_virtual_text_support = false,
            }
            vim.keymap.set("n", "<leader>cy", ":CMakeSelectBuildType<CR>", {})
            vim.keymap.set("n", "<leader>ct", ":CMakeSelectLaunchTarget<CR>", {})
            vim.keymap.set("n", "<leader>ca", ":CMakeLaunchArgs ", {})
            vim.keymap.set("n", "<leader>cc", ":CMakeClean<CR>", {})
            vim.keymap.set("n", "<leader>cx", ":CMakeCloseExecutor<CR>", {})
            vim.keymap.set("n", "<leader>cv", ":CMakeCloseRunner<CR>", {})
        end,
    }
}
