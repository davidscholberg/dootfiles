-- Mapping of file extensions to compile commands.
-- The format strings must have 3 arguments: the source path and then the exe path twice.
local compile_table = {
    c = "gcc %s -o %s && %s",
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
        local command_fmt = compile_table[file_extension]
        if command_fmt ~= nil then
            local exe_path = vim.fn.system("mktemp"):sub(1, -2)
            command = command_fmt:format(source_filepath, exe_path, exe_path)
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
