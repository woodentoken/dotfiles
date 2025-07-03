-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28

-- or, changing the font size and color scheme.
config.font_size = 9
config.color_scheme = 'Kanagawa (Gogh)'
config.color_scheme = 'Fahrenheit'
config.color_scheme = 'Glacier'
config.color_scheme = 'Gruvbox dark, hard (base16)'
config.color_scheme = 'GruvboxDarkHard'
config.font = wezterm.font 'JetBrains Mono'
config.window_background_opacity= 0.9

-- Finally, return the configuration to wezterm:
return config
