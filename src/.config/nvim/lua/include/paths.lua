-- Convenience functions for system paths

local M = {}

-- Convert given path into a string that uniquely represents the path and can be used as a directory name.
function M.flatten(path)
    return path:gsub(":[\\/]", "+"):gsub("[\\/]", "+"):lower()
end

-- Join together the array of path elements by the path separator.
function M.join(path_elements)
    return table.concat(path_elements, vim.fn.expand("/"))
end

return M
