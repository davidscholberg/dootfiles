local M = {}

-- Adds a customized clangd config.
function M.add_handler(handlers)
    -- If we're in a cmake directory, send clangd config to cmake-tools
    if vim.fn.filereadable(vim.fn.getcwd() .. "/CMakeLists.txt") == 1 then
        handlers.clangd = function ()
            require('lspconfig').clangd.setup{
                on_new_config = function(new_config, _)
                    local status, cmake = pcall(require, "cmake-tools")
                    if status then
                        cmake.clangd_on_new_config(new_config)
                    end
                end,
            }
        end
    end
end

return M
