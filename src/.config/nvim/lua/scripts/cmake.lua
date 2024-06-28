-- Set up some nvim command wrappers for cmake.

vim.api.nvim_create_user_command(
    "CmakeGenDebug",
    function ()
        vim.cmd("!cmake -B build -D CMAKE_BUILD_TYPE=Debug")
    end,
    {
        desc = "Generates a debug buildsystem.",
        nargs = 0,
    }
)

vim.api.nvim_create_user_command(
    "CmakeGenRelease",
    function ()
        vim.cmd("!cmake -B build -D CMAKE_BUILD_TYPE=Release")
    end,
    {
        desc = "Generates a release buildsystem.",
        nargs = 0,
    }
)

vim.api.nvim_create_user_command(
    "CmakeBuild",
    function ()
        vim.cmd("!cmake --build build")
    end,
    {
        desc = "Builds the currently generated buildsystem.",
        nargs = 0,
    }
)
