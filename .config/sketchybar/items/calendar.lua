local settings = require("settings")
local colors = require("colors")

-- Clock in center (omarchy style)
local clock = sbar.add("item", "clock", {
  position = "center",
  icon = { drawing = false },
  label = {
    color = colors.white,
    padding_left = 0,
    padding_right = 0,
    y_offset = 1,
  },
  background = {
    color = colors.transparent,
  },
  update_freq = 10,
})

clock:subscribe({"forced", "routine", "system_woke"}, function(env)
  clock:set({ label = os.date("%a %H:%M") })
end)
