-- First read our docs (completely) then check the example_config repo

local M = {}

M.ui = {
  theme_toggle = { "tokyonight", "one_light" },
  theme = "tokyonight",
}

M.plugins = require "custom.plugins"

return M
