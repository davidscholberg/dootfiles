-- Mapping of file extensions to compile commands.
-- The format strings must have 3 arguments: the source path and then the exe path twice.
local compile_table = {
    c = "gcc -Wall -Wextra -Werror -Wpedantic -std=c89 %s -o %s && %s",
    carbon = "(carbon compile --output=execute_current_file.carbon.o %s && carbon link --output=%s execute_current_file.carbon.o && %s); rm -f execute_current_file.carbon.o",
    cpp = "g++ -Wall -Wextra -Werror -Wpedantic -std=c++23 %s -o %s && %s",
}

-- Mapping of file extensions to interpret commands.
-- The format strings must have 1 argument: the source path.
local interpret_table = {
    clj = "clojure -M %s",
    fs = "gforth %s -e bye",
    java = "java --enable-preview --source 22 %s",
    lisp = "clisp %s",
    py = "python %s",
    rkt = "racket %s",
    scm = "csi -qb %s",
}

-- Executes the current source file with the compiler/interpreter defined for the file type.
vim.api.nvim_create_user_command(
    "ExecuteCurrentFile",
    function ()
        -- Get current file path and type
        local source_filepath = vim.fn.expand("%")
        local file_extension = source_filepath:match("%.(%w+)$")

        -- Get configured compile or interpret command for file type
        local command = nil
        if compile_table[file_extension] ~= nil then
            local exe_path = vim.fn.system("mktemp"):sub(1, -2)
            local command_fmt = compile_table[file_extension]
            command = command_fmt:format(source_filepath, exe_path, exe_path)
        elseif interpret_table[file_extension] ~= nil then
            local command_fmt = interpret_table[file_extension]
            command = command_fmt:format(source_filepath)
        else
            print(("error: file extension \"%s\" not supported for execution"):format(file_extension))
            return
        end

        -- Run the command
        require("include.terminals").execute("general", command)
    end,
    {
        desc = "Executes the current source file with the compiler/interpreter defined for the file type.",
        nargs = 0,
    }
)

-- Set keybinding for this command.
vim.keymap.set("n", "<leader>r", ":w<CR>:ExecuteCurrentFile<CR>", {})
