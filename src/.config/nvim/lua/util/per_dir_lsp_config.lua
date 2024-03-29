local M = {}

-- Adds custom lsp configs for specific directories
function M.add_handlers(handlers)
    local home_dir = vim.env.HOME
    local dir_table = {
        [home_dir .. "/src/git/dootfiles"] = {
            "conditional.lua_ls_nvim",
        },
    }

    local handler_adders = dir_table[vim.fn.getcwd()]
    if handler_adders ~= nil then
        for _, handler_adder in ipairs(handler_adders) do
            require(handler_adder).add_handler(handlers)
        end
    end
end

return M
