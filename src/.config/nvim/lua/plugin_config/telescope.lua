local telescope = require("telescope")
telescope.setup({
    pickers = {
        find_files = {
            hidden = true,
            find_command = {
                "rg",
                "--files",
                "--color",
                "never",
                "--glob",
                "!.git",
            },
        },
        live_grep = {
            glob_pattern = "!.git",
            additional_args = {"--hidden",},
        },
    },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set(
    "n",
    "<leader>fc",
    function ()
        builtin.live_grep({search_dirs = {vim.fn.expand("%:p")}})
    end,
    {}
)
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fr", builtin.resume, {})
