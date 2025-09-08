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
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
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

-- Setup general lsp keybindings
vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float({border = \"rounded\"})<cr>")
vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.jump({count = -1, float = {border = \"rounded\"}})<cr>")
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.jump({count = 1, float = {border = \"rounded\"}})<cr>")
vim.api.nvim_create_autocmd(
    "LspAttach",
    {
        desc = "LSP actions",
        callback = function(event)
            local opts = {buffer = event.buf}
            vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover({border = \"rounded\"})<cr>", opts)
            vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
            vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
            vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
            vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
            vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
            vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
            vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
            vim.keymap.set({"n", "x"}, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
            vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
        end
    }
)
