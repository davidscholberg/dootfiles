-- Bootstrap paq
local paq_path = vim.fn.stdpath("data") .. vim.fn.expand("/site/pack/paqs/start/paq-nvim")
if not vim.uv.fs_stat(paq_path) then
    vim.fn.system({
        "git",
        "clone",
        "--depth=1",
        "https://github.com/savq/paq-nvim.git",
        paq_path,
    })

    vim.cmd.packadd("paq-nvim")
end

-- Load plugin spec
local paq = require("paq")
paq({

    -- leap
    "tpope/vim-repeat",
    "https://codeberg.org/andyg/leap.nvim",

    -- lsp
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "neovim/nvim-lspconfig",

    -- lualine
    "nvim-lualine/lualine.nvim",

    -- nvim-tree
    "nvim-tree/nvim-tree.lua",

    -- telescope
    "nvim-lua/plenary.nvim",
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
    },

    -- treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
    },
})
