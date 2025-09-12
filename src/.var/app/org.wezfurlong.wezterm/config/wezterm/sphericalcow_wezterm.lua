local wezterm = require "wezterm"

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Set font
config.font = wezterm.font("Source Code Pro")
config.font_size = 13.0

-- Set color scheme
local custom_colorscheme = wezterm.color.get_builtin_schemes()["Builtin Tango Dark"]
custom_colorscheme.background = "#14161b"
config.color_schemes = {["Builtin Tango Dark Custom"] = custom_colorscheme}
config.color_scheme = "Builtin Tango Dark Custom"

-- Set window title
wezterm.on(
    "format-window-title",
    function (tab, pane, tabs, panes, config)
        return ""
    end
)

-- Set tab titles
wezterm.on(
    "format-tab-title",
    function (tab, tabs, panes, config, hover, max_width)
        local pane_title = tab.active_pane.title
        return {
            {Background = {Color = "#1e1e1e"}},
            {Text = pane_title:sub(pane_title:find(":") + 1)},
        }
    end
)

return config
