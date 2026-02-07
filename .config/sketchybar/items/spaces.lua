local colors = require("colors")
local settings = require("settings")

-- Omarchy style: numbers 1-9, 0
local SPACE_ICONS = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"}

local spaces = {}

for i = 1, 10, 1 do
  local space = sbar.add("space", "space." .. i, {
    space = i,
    icon = {
      string = SPACE_ICONS[i],
      padding_left = 6,
      padding_right = 6,
      color = colors.with_alpha(colors.white, 0.5),
      highlight_color = colors.white,
      y_offset = 1,
    },
    label = { drawing = false },
    padding_right = 0,
    padding_left = 0,
    background = {
      color = colors.transparent,
    },
    click_script = "yabai -m space --focus " .. i
  })

  spaces[i] = space

  space:subscribe("space_change", function(env)
    local selected = env.SELECTED == "true"
    space:set({
      icon = { color = selected and colors.white or colors.with_alpha(colors.white, 0.5) }
    })
  end)
end

-- Minimal padding after spaces
sbar.add("item", "spaces.padding", {
  width = settings.group_paddings
})
