-- Add custom language servers that mason doesn't handle.
require("include.carbon_ls")
require("include.dart_ls")

local M = {}

-- Adds custom lsp configs for existing servers to mason
function M.add_handlers(handlers)
    -- Add custom lsp configs if we're in a certain directory
    -- TODO: This could probably be replaced with custom root_dir function in the lspconfig for the
    -- server.
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

    -- Add custom lsp configs unconditionally
    for _, handler_adder in ipairs({
    }) do
        require(handler_adder).add_handler(handlers)
    end
end

return M
