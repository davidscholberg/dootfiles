local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'

if not configs.dart_ls then
    configs.dart_ls = {
        default_config = {
            filetypes = {"dart"},
            cmd = {"dart", "language-server", "--protocol=lsp",},
            single_file_support = true,
        },
    }
end

lspconfig.dart_ls.setup{}
