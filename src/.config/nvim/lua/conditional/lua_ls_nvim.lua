local M = {}

-- Adds a neovim-specific lua_ls config.
function M.add_handler(handlers)
    handlers.lua_ls = function ()
        require("lspconfig").lua_ls.setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT"
                    },
                    diagnostics = {
                        globals = {"vim"},
                    },
                    workspace = {
                        library = {
                            vim.env.VIMRUNTIME,
                        }
                    }
                }
            }
        })
    end
end

return M
