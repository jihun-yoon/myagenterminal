local wezterm = require("wezterm")

local config = wezterm.config_builder()

local colors = {
  background = "#14191f",
  system = "#252a31",
  battery = "#343a43",
  clock = "#4a515c",
  text = "#dcdcdc",
  muted = "#a6a6a6",
}

-- Open local file hyperlinks with their macOS default application.
wezterm.on("open-uri", function(_, _, uri)
  if uri:find("^file:") == 1 then
    local url = wezterm.url.parse(uri)
    wezterm.open_with(url.file_path)
    return false
  end
end)

-- Show the same window number used by Command-Option-1..9 in the title bar.
wezterm.on("format-window-title", function(tab, pane)
  local number
  if wezterm.gui then
    for index, gui_window in ipairs(wezterm.gui.gui_windows()) do
      local ok, window_id = pcall(function()
        return gui_window:window_id()
      end)
      if ok and window_id == tab.window_id then
        number = index
        break
      end
    end
  end

  if number then
    return string.format("[%d] %s", number, pane.title)
  end
  return pane.title
end)

local function battery_status()
  local batteries = wezterm.battery_info()
  if #batteries == 0 then
    return "BAT --"
  end

  local battery = batteries[1]
  local suffix = battery.state == "Charging" and "+" or ""
  return string.format("BAT%s %.0f%%", suffix, battery.state_of_charge * 100)
end

local function segment(elements, text, background, foreground)
  table.insert(elements, { Background = { Color = background } })
  table.insert(elements, { Foreground = { Color = foreground } })
  table.insert(elements, { Text = "  " .. text .. "  " })
end

wezterm.on("update-right-status", function(window)
  local elements = {}
  segment(elements, battery_status(), colors.battery, colors.text)
  segment(elements, wezterm.strftime("%a %b %-d  %H:%M"), colors.clock, colors.text)
  window:set_right_status(wezterm.format(elements))
end)

-- Match the saved iTerm2 Default profile: JetBrainsMono Nerd Font Mono, 16pt.
config.font = wezterm.font("JetBrainsMono Nerd Font Mono")
config.font_size = 16.0
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.status_update_interval = 10000

-- Move the active WezTerm pane into its own window without using a shell.
config.keys = {
  {
    key = "`",
    mods = "CMD",
    action = wezterm.action.ActivateWindowRelative(1),
  },
  {
    key = "`",
    mods = "CMD|SHIFT",
    action = wezterm.action.ActivateWindowRelative(-1),
  },
  {
    key = "UpArrow",
    mods = "CMD",
    action = wezterm.action.ScrollByPage(-1),
  },
  {
    key = "DownArrow",
    mods = "CMD",
    action = wezterm.action.ScrollByPage(1),
  },
  {
    key = "UpArrow",
    mods = "CMD|SHIFT",
    action = wezterm.action.ScrollByLine(-3),
  },
  {
    key = "DownArrow",
    mods = "CMD|SHIFT",
    action = wezterm.action.ScrollByLine(3),
  },
  {
    key = "m",
    mods = "CMD|SHIFT",
    action = wezterm.action_callback(function(_, pane)
      pane:move_to_new_window()
    end),
  },
}

-- Select a specific WezTerm window with Command-Option-1..9.
for index = 1, 9 do
  table.insert(config.keys, {
    key = tostring(index),
    mods = "CMD|ALT",
    action = wezterm.action.ActivateWindow(index - 1),
  })
end

-- Always forward terminal-generated notifications, including from a focused window.
config.notification_handling = "AlwaysShow"

config.colors = {
  foreground = "#dcdcdc",
  background = "#14191f",
  cursor_bg = "#ffffff",
  cursor_fg = "#000000",
  selection_bg = "#b3d7ff",
  selection_fg = "#000000",
  ansi = {
    "#14191e",
    "#b43c2a",
    "#00c200",
    "#c7c400",
    "#2744c7",
    "#c040be",
    "#00c5c7",
    "#c7c7c7",
  },
  brights = {
    "#686868",
    "#dd7975",
    "#58e790",
    "#ece100",
    "#a7abf2",
    "#e17ee1",
    "#60fdff",
    "#ffffff",
  },
  tab_bar = {
    background = colors.background,
    active_tab = {
      bg_color = colors.clock,
      fg_color = colors.text,
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = colors.background,
      fg_color = colors.muted,
    },
    inactive_tab_hover = {
      bg_color = colors.system,
      fg_color = colors.text,
    },
    new_tab = {
      bg_color = colors.background,
      fg_color = colors.muted,
    },
    new_tab_hover = {
      bg_color = colors.system,
      fg_color = colors.text,
    },
  },
}

config.window_padding = {
  left = 10,
  right = 10,
  top = 8,
  bottom = 8,
}

-- Let Command-click bypass app mouse reporting and open terminal hyperlinks.
config.bypass_mouse_reporting_modifiers = "CMD"
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = wezterm.action.Nop,
  },
}

config.window_close_confirmation = "NeverPrompt"

-- Treat both macOS Option keys as Alt for terminal shortcuts.
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- WezTerm's mux is intentionally not configured. tmux and Herdr own sessions.

return config
