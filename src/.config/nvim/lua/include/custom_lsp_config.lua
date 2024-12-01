local M = {}

-- Adds custom lsp configs under certain conditions
function M.add_handlers(handlers)
    -- Add custom lsp configs if we're in a certain directory
    local dir_table = {
        [vim.fn.expand("~/src/git/dootfiles")] = {
            "include.lua_ls_nvim",
        },
    }

    local handler_adders = dir_table[vim.fn.getcwd()]
    if handler_adders ~= nil then
        for _, handler_adder in ipairs(handler_adders) do
            require(handler_adder).add_handler(handlers)
        end
    end

    -- The following scripts have their own conditional logic
    for _, handler_adder in ipairs({
        "include.clangd",
    }) do
        require(handler_adder).add_handler(handlers)
    end
end

return M
