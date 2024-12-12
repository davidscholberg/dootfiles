-- Create discrete terminal buffers that each have a project-specific function (configure, build,
-- run, test, debug, etc), and effortlessly open and/or send configurable commands to each.

-- TODO: add shared terminal that configs can opt to use instead of a unique one.

local paths = require("include.paths")
local strings = require("include.strings")
local terminals = require("include.terminals")

local plugin_name = "project_terminals"

local custom_default_template = [[
-- config for %s terminal
return {
    cmd = "",
    dep = "",
    run_once = false,
    focus_key_binding = "",
    run_key_binding = "",
}
]]

local pt_data_dir = paths.join({vim.fn.stdpath("data"), plugin_name})
local pt_cwd_data_dir = paths.join({pt_data_dir, paths.flatten(vim.fn.getcwd())})
local pt_configs_glob = paths.join({pt_cwd_data_dir, "*.lua"})
local pt_bin_dir = paths.join({vim.fn.stdpath("config"), "bin"})

local terminal_states = {}

local function get_config_name_from_path(config_path)
    return config_path:gsub([[.+[\/](.+)%.lua$]], "%1")
end

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

    if config.dep == nil then
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
                local remaining_cmds_str = e.data:gsub("^.+8084;%-%-remaining ([%w_%-:]+)$", "%1")
                if remaining_cmds_str == e.data then
                    return
                end

                local remaining_cmds = strings.split(remaining_cmds_str, ":")
                vim.defer_fn(function() execute_dep_chain(remaining_cmds) end, 0)
            end,
        }
    )
end

-- Setup state and keybindings for the given terminal config.
local function process_terminal_config(config_name, terminal_config)
    if terminal_states[config_name] == nil then
        terminal_states[config_name] = {
            ran_at_least_once = false,
        }
    end

    local terminal_state = terminal_states[config_name]
    local old_config = terminal_state.config
    terminal_state.config = terminal_config

    if old_config ~= nil then
        if old_config.focus_key_binding ~= terminal_state.config.focus_key_binding then
            vim.keymap.del("n", old_config.focus_key_binding)
        end
        if old_config.run_key_binding ~= terminal_state.config.run_key_binding then
            vim.keymap.del("n", old_config.run_key_binding)
        end
    end

    if terminal_state.config.dep ~= nil and terminal_state.config.dep ~= "" then
        create_termrequest_autocmd()
    end

    vim.keymap.set(
        "n",
        terminal_state.config.focus_key_binding,
        function()
            terminals.focus(config_name)
        end
    )

    vim.keymap.set(
        "n",
        terminal_state.config.run_key_binding,
        function()
            execute_dep_chain(get_dep_chain(config_name))
        end
    )
end

-- Create autocmds for editing the given config file.
-- TODO: possibly just have one set of autocmds that match all configs, and have them always be present.
local function create_autocmds_for_config(config_name, config_path)
    local group_name = plugin_name .. "_" .. config_name
    local group_id = vim.api.nvim_create_augroup(group_name, {clear = false})

    local group_autocmds = vim.api.nvim_get_autocmds({group = group_id})
    if next(group_autocmds) ~= nil then
        return
    end

    -- Stupid workaround so that windows paths can work with autocmds
    config_path = config_path:gsub([[\]], "/")

    vim.api.nvim_create_autocmd(
        "BufNewFile",
        {
            group = group_id,
            pattern = config_path,
            callback = function(e)
                print("inside new file autocmd")
                local lines = strings.split(custom_default_template:format(config_name), "\n")
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
            pattern = config_path,
            callback = function(e)
                print("inside write post autocmd")
                local config_lines = vim.api.nvim_buf_get_lines(e.buf, 0, vim.api.nvim_buf_line_count(e.buf), true)
                local config_func, err = load(table.concat(config_lines, "\n"))
                if not config_func then
                    print("error: " .. err)
                    return
                end
                process_terminal_config(config_name, config_func())
            end,
        }
    )
end

-- Create command that will list out existing configs for the current project.
vim.api.nvim_create_user_command(
    "PTls",
    function (_)
        if next(terminal_states) == nil then
            print("(no configs present)")
            return
        end

        for config_name, _ in pairs(terminal_states) do
            print(config_name)
        end
    end,
    {
        desc = "List existing config names for the current project",
        nargs = 0,
    }
)

-- Create command that will allow us to create a custom project terminal.
vim.api.nvim_create_user_command(
    "PTedit",
    function (opts)
        local config_name = opts.fargs[1]:lower()
        local config_path = paths.join({pt_cwd_data_dir, config_name .. ".lua"})
        create_autocmds_for_config(config_name, config_path)
        vim.fn.mkdir(pt_cwd_data_dir, "p")
        vim.cmd.edit(config_path)
    end,
    {
        desc = "Configure a project terminal with the given name",
        nargs = 1,
    }
)

-- Startup tasks: load any existing config on startup, update PATH env var.
;(function()
    for _, config_path in ipairs(vim.fn.glob(pt_configs_glob, false, true)) do
        local config_name = get_config_name_from_path(config_path)
        create_autocmds_for_config(config_name, config_path)

        local config_func, err = loadfile(config_path)
        if not config_func then
            print("error: " .. err)
            return
        end

        process_terminal_config(config_name, config_func())
    end

    update_path_env_var()
end)()
