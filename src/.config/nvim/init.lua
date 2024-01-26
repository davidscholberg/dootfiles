-- Remap leader to spacebar
vim.g.mapleader = " "

-- Enable relative line numbers with absolute line number for current line
vim.wo.relativenumber = true
vim.wo.number = true

-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup and configure plugins
require("lazy").setup({

  -- vscode theme
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require('vscode').load()
    end,
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function ()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = {
          "bash", "c", "cmake", "cpp", "dockerfile", "git_config", "git_rebase",
          "gitcommit", "gitignore", "javascript", "json", "lua", "make",
          "markdown", "markdown_inline", "python", "ssh_config", "typescript",
          "vim", "vimdoc",
        },
        sync_install = false,
        highlight = { enable = true },
      })
    end
  },

  -- telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function ()
      local telescope = require('telescope')
      telescope.setup({
        pickers = {
          find_files = {
            hidden = true,
            find_command = {
              'rg', '--files', '--color', 'never', '--glob', '!.git'
            },
          }
        }
      })
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    end
  },
})

