-- Convenience functions for system paths

local M = {}

-- Convert given path into a string that uniquely represents the path and can be used as a base directory name.
function M.flatten(path)
    return path:gsub(":\\", "_._"):gsub("\\", "._."):gsub("/", "._.")
end

-- Get path to unique data directory for the current directory we're in. prefix_dir is an optional directory that will be
-- set as the parent of the unique directory.
function M.get_project_data_path(prefix_dir)
    if prefix_dir and prefix_dir ~= "" then
        prefix_dir = "/" .. prefix_dir .. "/"
    else
        prefix_dir = "/"
    end

    return vim.fn.stdpath("data") .. vim.fn.expand(prefix_dir) .. M.flatten(vim.fn.getcwd())
end

return M
