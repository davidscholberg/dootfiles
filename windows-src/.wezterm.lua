local wezterm = require "wezterm"

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Set font
config.font = wezterm.font("Source Code Pro")
config.font_size = 13.0

-- Set color scheme
config.color_scheme = "Vs Code Dark+ (Gogh)"

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

-- Disable cmd start text
config.default_prog = {"cmd.exe", "/k"}

return config
