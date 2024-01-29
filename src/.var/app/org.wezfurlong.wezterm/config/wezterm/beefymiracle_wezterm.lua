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

return config
