-- Mapping of file extensions to compile commands.
-- The format strings must have 3 arguments: the source path and then the exe path twice.
local compile_table = {
    c = "gcc %s -o %s && %s",
}

-- Mapping of file extensions to interpret commands.
-- The format strings must have 1 argument: the source path.
local interpret_table = {
    py = "python %s",
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
        vim.cmd("!" .. command)
    end,
    {
        desc = "Executes the current source file with the compiler/interpreter defined for the file type.",
        nargs = 0,
    }
)
