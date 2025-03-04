local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'

if not configs.carbon_ls then
    configs.carbon_ls = {
        default_config = {
            filetypes = {"carbon"},
            cmd = {"carbon", "language-server"},
            single_file_support = true,
        },
    }
end

lspconfig.carbon_ls.setup{}
