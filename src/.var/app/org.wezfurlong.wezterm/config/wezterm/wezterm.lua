local wezterm = require 'wezterm'

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Set font
config.font = wezterm.font('Monospace')
config.font_size = 11.0

-- Set color scheme
config.color_scheme = 'Vs Code Dark+ (Gogh)'

return config

