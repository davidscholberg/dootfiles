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
        vim.cmd("!cmake --build build -j $(nproc)")
    end,
    {
        desc = "Builds the currently generated buildsystem.",
        nargs = 0,
    }
)

local run_script_name = "cmake_run.sh"
local cmake_run_command = "!test \\! -f %s && echo 'echo \"edit %s to run the target you want\"' > %s; bash %s"
vim.api.nvim_create_user_command(
    "CmakeRun",
    function ()
        vim.cmd(cmake_run_command:format(run_script_name, run_script_name, run_script_name, run_script_name))
    end,
    {
        desc = "Runs the shell script ./cmake_run.sh in the current dir.",
        nargs = 0,
    }
)
