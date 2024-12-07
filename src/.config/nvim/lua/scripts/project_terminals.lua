-- Create discrete terminal buffers that each have a project-specific function (configure, build,
-- run, test, debug, etc), and effortlessly open and/or send configurable commands to each.

-- TODO: add shared terminal that configs can opt to use instead of a unique one.

local paths = require("include.paths")
local strings = require("include.strings")
local terminals = require("include.terminals")

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

local plugin_name = "project_terminals"

local data_dir = nil
local terminal_states = {}

local function get_data_dir()
    if data_dir then
        return data_dir
    end

    data_dir = paths.get_project_data_path(plugin_name)
    return data_dir
end

local function create_data_dir()
    vim.fn.mkdir(get_data_dir(), "p")
end

local function get_config_name_from_path(config_path)
    return config_path:gsub([[.+[\/](.+)%.lua$]], "%1")
end

local function get_configs_glob()
    return get_data_dir() .. vim.fn.expand("/") .. "*.lua"
end

local function build_cmd_dep_chain(terminal_state)
    local config = terminal_state.config

    if config.dep == nil then
        return config.cmd
    end

    return build_cmd_dep_chain(terminal_states[config.dep]) .. " && " .. config.cmd
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
            local cmd = build_cmd_dep_chain(terminal_state)
            terminals.execute(config_name, cmd)
        end
    )
end

-- Create autocmds for editing the given config file.
-- TODO: possibly just have one set of autocmds that match all configs, and have them always be present.
local function create_autocmds_for_config(config_path)
    local config_name = get_config_name_from_path(config_path)
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
        local config_path = get_data_dir() .. vim.fn.expand("/") .. config_name .. ".lua"
        create_autocmds_for_config(config_path)
        create_data_dir()
        vim.cmd("edit " .. config_path)
    end,
    {
        desc = "Configure a project terminal with the given name",
        nargs = 1,
    }
)

-- Load any existing config on startup
;(function()
    for _, config_path in ipairs(vim.fn.glob(get_configs_glob(), false, true)) do
        create_autocmds_for_config(config_path)

        local config_func, err = loadfile(config_path)
        if not config_func then
            print("error: " .. err)
            return
        end

        local config_name = get_config_name_from_path(config_path)
        process_terminal_config(config_name, config_func())
    end
end)()
