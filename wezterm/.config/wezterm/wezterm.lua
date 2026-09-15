local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 14.0

config.window_padding = {
  left = 10,
  right = 10,
  top = 8,
  bottom = 8,
}

config.window_close_confirmation = "NeverPrompt"

-- Treat both macOS Option keys as Alt for terminal shortcuts.
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- WezTerm's mux is intentionally not configured. tmux and Herdr own sessions.

return config
