-- Setup cmp
local cmp = require("cmp")
cmp.setup({
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
    }, {
        { name = 'buffer' },
    })
})

-- Setup lsp config settings for all lsps
vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Setup lua_ls
vim.lsp.config("lua_ls", {
    on_init = function(client)
        -- Do neovim-specific setup if we're inside our config dir
        if vim.fn.getcwd() ~= vim.fn.expand("~/src/git/dootfiles") then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
                version = "LuaJIT",
                path = {
                    "lua/?.lua",
                    "lua/?/init.lua",
                },
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                },
            },
        })
    end,
    settings = {
        Lua = {},
    },
})
vim.lsp.enable("lua_ls")

-- Setup clangd
vim.lsp.enable("clangd")

-- Setup clojure-lsp
vim.lsp.enable("clojure_lsp")

-- Setup haskell-language-server
vim.lsp.enable("hls")

-- Setup general lsp keybindings
vim.keymap.set("n", "gl", function() vim.diagnostic.open_float({border = "rounded"}) end)
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({count = -1, float = {border = "rounded"}}) end)
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({count = 1, float = {border = "rounded"}}) end)
vim.api.nvim_create_autocmd(
    "LspAttach",
    {
        desc = "LSP actions",
        callback = function(event)
            local opts = {buffer = event.buf}
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover({border = "rounded"}) end, opts)
            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
            vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
            vim.keymap.set("n", "go", function() vim.lsp.buf.type_definition() end, opts)
            vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "gs", function() vim.lsp.buf.signature_help({border = "rounded"}) end, opts)
            vim.keymap.set("n", "<F2>", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set({"n", "x"}, "<F3>", function() vim.lsp.buf.format({async = true}) end, opts)
            vim.keymap.set("n", "<F4>", function() vim.lsp.buf.code_action() end, opts)
        end
    }
)
