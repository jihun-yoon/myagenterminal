local theme = vim.env.MYAGENTERMINAL_NVIM_THEME or "gruvbox-night"
local theme_file = vim.env.MYAGENTERMINAL_THEME_FILE
  or (vim.fn.expand("~") .. "/.config/myagenterminal/theme")
local file = io.open(theme_file, "r")
if file then
  local mode = file:read("*l")
  file:close()
  if mode == "day" or mode == "night" then
    theme = "gruvbox-" .. mode
  else
    vim.notify("Unknown saved theme mode; using Gruvbox Night", vim.log.levels.WARN)
    theme = "gruvbox-night"
  end
end

if theme ~= "gruvbox-day" and theme ~= "gruvbox-night" and theme ~= "ayu-mirage" then
  vim.notify("Unknown Neovim theme: " .. theme .. "; using Gruvbox Night", vim.log.levels.WARN)
  theme = "gruvbox-night"
end

return {
  {
    "Shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    config = function()
      if theme == "ayu-mirage" then
        vim.cmd.colorscheme("ayu-mirage")
      end
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    opts = { contrast = "soft" },
    config = function(_, opts)
      require("gruvbox").setup(opts)
      if theme == "gruvbox-day" or theme == "gruvbox-night" then
        vim.o.background = theme == "gruvbox-day" and "light" or "dark"
        vim.cmd.colorscheme("gruvbox")
      end
    end,
  },
}
