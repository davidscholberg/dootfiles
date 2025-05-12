-- Create discrete terminal buffers that each have a project-specific function (configure, build,
-- run, test, debug, etc), and effortlessly open and/or send configurable commands to each.

-- TODO: add shared terminal that configs can opt to use instead of a unique one.

local paths = require("include.paths")
local strings = require("include.strings")
local terminals = require("include.terminals")

local plugin_name = "project_terminals"

local new_config_file_template = [[
-- project terminals config for %s
-- Yank a config template into the default register with :PtYank template_name
-- This script should return an array of tables where each table holds a terminal config.
-- The config will be loaded as soon as this buffer is saved.
return {
}
]]

local config_templates = {
    custom = [[
    {
        name = "custom",
        cmd = "echo test",
        dep = "",
        focus_key_binding = "<leader>f",
        run_key_binding = "<leader>r",
    },
]],
}

local pt_data_dir = paths.join({vim.fn.stdpath("data"), plugin_name})
local pt_config_path = paths.join({pt_data_dir, paths.flatten(vim.fn.getcwd()) .. ".lua"})
local pt_bin_dir = paths.join({vim.fn.stdpath("config"), "bin"})

local terminal_states = {}

local function update_path_env_var()
    local field_sep = ":"
    if vim.fn.has("win32") == 1 then
        field_sep = ";"
    end

    vim.fn.setenv("PATH", pt_bin_dir .. field_sep .. vim.fn.getenv("PATH"))
end

local function get_signal_shell_script_name()
    local shell_script_name = "pt_cmd_done."
    if vim.fn.has("win32") == 1 then
        shell_script_name = shell_script_name .. "bat"
    else
        shell_script_name = shell_script_name .. "sh"
    end

    return shell_script_name
end

local function get_dep_chain(config_name)
    local config = terminal_states[config_name].config

    if config.dep == nil or config.dep == "" then
        return {config_name}
    end

    local dep_chain = get_dep_chain(config.dep)
    table.insert(dep_chain, config_name)
    return dep_chain
end

local function execute_dep_chain(dep_chain)
    local next_config_name = dep_chain[1]
    local cmd = terminal_states[next_config_name].config.cmd
    if #dep_chain > 1 then
        cmd = string.format(
            "%s && %s --remaining %s",
            cmd,
            get_signal_shell_script_name(),
            table.concat(dep_chain, ":", 2)
        )
    end

    terminals.execute(next_config_name, cmd)
end

local function create_termrequest_autocmd()
    local group_id = vim.api.nvim_create_augroup("pt_termrequest", {clear = false})

    if next(vim.api.nvim_get_autocmds({group = group_id})) ~= nil then
        return
    end

    vim.api.nvim_create_autocmd(
        "TermRequest",
        {
            group = group_id,
            pattern = "*",
            callback = function(e)
                local request_sequence = e.data
                if type(request_sequence) == "table" then
                    request_sequence = request_sequence.sequence
                elseif type(request_sequence) ~= "string" then
                    print("error: unexpected type for request_sequence: " .. type(request_sequence))
                    return
                end

                local remaining_cmds_str = request_sequence:gsub("^.+8084;%-%-remaining ([%w_%-:]+)$", "%1")
                if remaining_cmds_str == request_sequence then
                    return
                end

                local remaining_cmds = strings.split(remaining_cmds_str, ":")
                vim.defer_fn(function() execute_dep_chain(remaining_cmds) end, 0)
            end,
        }
    )
end

-- Setup state and keybindings for the current directory's terminal configs.
local function process_terminal_configs(terminal_configs)
    for _, terminal_config in ipairs(terminal_configs) do
        local terminal_name = terminal_config.name
        if terminal_states[terminal_name] == nil then
            terminal_states[terminal_name] = {}
        end

        local terminal_state = terminal_states[terminal_name]
        local old_config = terminal_state.config
        terminal_state.config = terminal_config

        if old_config ~= nil then
            if
                old_config.focus_key_binding ~= ""
                and old_config.focus_key_binding ~= terminal_state.config.focus_key_binding
            then
                vim.keymap.del("n", old_config.focus_key_binding)
            end

            if
                old_config.run_key_binding ~= ""
                and old_config.run_key_binding ~= terminal_state.config.run_key_binding
            then
                vim.keymap.del("n", old_config.run_key_binding)
            end
        end

        if terminal_state.config.dep ~= nil and terminal_state.config.dep ~= "" then
            create_termrequest_autocmd()
        end

        if terminal_state.config.focus_key_binding ~= "" then
            vim.keymap.set(
                "n",
                terminal_state.config.focus_key_binding,
                function()
                    terminals.focus(terminal_name)
                end
            )
        end

        if terminal_state.config.run_key_binding ~= "" then
            vim.keymap.set(
                "n",
                terminal_state.config.run_key_binding,
                function()
                    execute_dep_chain(get_dep_chain(terminal_name))
                end
            )
        end
    end
end

-- Create autocmds for editing the config file for the current directory.
local function create_autocmds_for_config()
    local group_name = plugin_name .. "_config_edit"
    local group_id = vim.api.nvim_create_augroup(group_name, {clear = false})

    local group_autocmds = vim.api.nvim_get_autocmds({group = group_id})
    if next(group_autocmds) ~= nil then
        return
    end

    -- Paths in autocmd patterns can only contain forward slashes as the dir separator.
    local config_pattern = pt_config_path:gsub([[\]], "/")

    vim.api.nvim_create_autocmd(
        "BufNewFile",
        {
            group = group_id,
            pattern = config_pattern,
            callback = function(e)
                print("inside new file autocmd")
                local lines = strings.split(new_config_file_template:format(vim.fn.getcwd()), "\n")
                if lines[#lines] == "" then
                    table.remove(lines)
                end
                vim.api.nvim_buf_set_lines(e.buf, 0, 1, true, lines)
                vim.api.nvim_set_option_value("modified", true, {buf = e.buf})
            end,
        }
    )

    vim.api.nvim_create_autocmd(
        "BufWritePost",
        {
            group = group_id,
            pattern = config_pattern,
            callback = function(e)
                print("inside write post autocmd")
                local config_lines = vim.api.nvim_buf_get_lines(e.buf, 0, vim.api.nvim_buf_line_count(e.buf), true)
                local config_func, err = load(table.concat(config_lines, "\n"))
                if not config_func then
                    print("error: " .. err)
                    return
                end
                process_terminal_configs(config_func())
            end,
        }
    )
end

-- Create command that will list out existing configs for the current project.
vim.api.nvim_create_user_command(
    "PtList",
    function (_)
        if next(terminal_states) == nil then
            print("(no configs present)")
            return
        end

        for terminal_name, _ in pairs(terminal_states) do
            print(terminal_name)
        end
    end,
    {
        desc = "List existing terminal names that have been configured for the current project",
        nargs = 0,
    }
)

-- Create command that will allow us to create a custom project terminal.
vim.api.nvim_create_user_command(
    "PtEdit",
    function (_)
        create_autocmds_for_config()
        vim.fn.mkdir(pt_data_dir, "p")
        vim.cmd.edit(pt_config_path)
    end,
    {
        desc = "Configure terminals for the current directory",
        nargs = 0,
    }
)

-- Create command that will yank the given config template to the default register.
vim.api.nvim_create_user_command(
    "PtYank",
    function (opts)
        local config_template = config_templates[opts.fargs[1]]
        if config_template == nil then
            print("error: config template doesn't exist")
            return
        end

        vim.fn.setreg("", config_template)
    end,
    {
        desc = "Yank the given config template into default register",
        nargs = 1,
        complete = function()
            local template_keys = {}
            for key, _ in pairs(config_templates) do
                table.insert(template_keys, key)
            end
            return template_keys
        end
    }
)

-- Startup tasks: load any existing config on startup, update PATH env var.
;(function()
    if vim.fn.filereadable(pt_config_path) == 1 then
        local config_func, err = loadfile(pt_config_path)

        if not config_func then
            print("error: " .. err)
            return
        end

        process_terminal_configs(config_func())
    end

    update_path_env_var()
end)()
