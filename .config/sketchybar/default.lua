local settings = require("settings")
local colors = require("colors")

-- Omarchy style: minimal, no backgrounds, small font
sbar.default({
  updates = "when_shown",
  icon = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Regular"],
      size = 12.0
    },
    color = colors.white,
    padding_left = 0,
    padding_right = 0,
    background = { image = { corner_radius = 0 } },
  },
  label = {
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Regular"],
      size = 12.0
    },
    color = colors.white,
    padding_left = 0,
    padding_right = 0,
  },
  background = {
    height = 26,
    corner_radius = 0,
    border_width = 0,
    color = colors.transparent,  -- No backgrounds (omarchy style)
  },
  popup = {
    background = {
      border_width = 0,
      corner_radius = 0,
      color = colors.popup.bg,
      shadow = { drawing = true },
    },
    blur_radius = 0,
  },
  padding_left = 0,
  padding_right = 0,
  scroll_texts = true,
})
