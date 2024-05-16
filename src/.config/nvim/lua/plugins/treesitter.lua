return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "cmake",
                    "commonlisp",
                    "cpp",
                    "dockerfile",
                    "git_config",
                    "git_rebase",
                    "gitcommit",
                    "gitignore",
                    "javascript",
                    "json",
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "racket",
                    "ssh_config",
                    "typescript",
                    "vim",
                    "vimdoc",
                },
                sync_install = false,
                highlight = { enable = true },
            })
        end,
    }
}
