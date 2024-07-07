-- Allows you to specify an arbitrary set of config files to load if we're in a
-- particular directory.

local home_dir = vim.env.HOME
local dir_table = {
    [home_dir .. "/src/git/dengine"] = {
        "conditional.cmake_keybindings",
    },
}

local dir_reqs = dir_table[vim.fn.getcwd()]
if dir_reqs ~= nil then
    for _, dir_req in ipairs(dir_reqs) do
        require(dir_req)
    end
end
