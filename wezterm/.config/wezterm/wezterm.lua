local wezterm = require("wezterm")

local config = wezterm.config_builder()

local colors = {
  background = "#1e1e2e",
  system = "#313244",
  battery = "#45475a",
  clock = "#585b70",
  text = "#cdd6f4",
  muted = "#a6adc8",
}

local function system_metrics()
  local success, stdout = wezterm.run_child_process({
    "/bin/sh",
    "-c",
    [[
      cpu_sum=$(/bin/ps -A -o %cpu= | /usr/bin/awk '{sum += $1} END {print sum + 0}')
      cores=$(/usr/sbin/sysctl -n hw.logicalcpu)
      total_bytes=$(/usr/sbin/sysctl -n hw.memsize)
      available_bytes=$(/usr/bin/vm_stat | /usr/bin/awk '
        /page size of/ { gsub(/[^0-9]/, "", $8); page_size = $8 }
        /Pages free:/ { gsub(/[^0-9]/, "", $3); free = $3 }
        /Pages speculative:/ { gsub(/[^0-9]/, "", $3); speculative = $3 }
        END { printf "%.0f", (free + speculative) * page_size }
      ')
      /usr/bin/awk -v cpu_sum="$cpu_sum" -v cores="$cores" \
        -v total_bytes="$total_bytes" -v available_bytes="$available_bytes" \
        'BEGIN {
          cpu = cores > 0 ? cpu_sum / cores : 0
          if (cpu > 100) cpu = 100
          ram = total_bytes > 0 ? 100 * (1 - available_bytes / total_bytes) : 0
          printf "CPU %.0f%%  RAM %.0f%%", cpu, ram
        }'
    ]],
  })

  if not success then
    return "CPU --  RAM --"
  end

  return stdout:gsub("%s+$", "")
end

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
  segment(elements, system_metrics(), colors.system, colors.text)
  segment(elements, battery_status(), colors.battery, colors.text)
  segment(elements, wezterm.strftime("%a %b %-d  %H:%M"), colors.clock, colors.text)
  window:set_right_status(wezterm.format(elements))
end)

config.font = wezterm.font("JetBrains Mono")
config.font_size = 14.0

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.use_fancy_tab_bar = false
config.status_update_interval = 10000

-- Always forward terminal-generated notifications, including from a focused window.
config.notification_handling = "AlwaysShow"

config.colors = {
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

config.window_close_confirmation = "NeverPrompt"

-- Treat both macOS Option keys as Alt for terminal shortcuts.
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- WezTerm's mux is intentionally not configured. tmux and Herdr own sessions.

return config
