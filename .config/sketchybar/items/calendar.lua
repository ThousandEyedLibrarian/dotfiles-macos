local settings = require("settings")
local colors = require("colors")

local show_date = false

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

local function update_clock()
  if show_date then
    clock:set({ label = os.date("W%V %d %b %Y") })
  else
    clock:set({ label = os.date("%a %H:%M") })
  end
end

clock:subscribe({"forced", "routine", "system_woke"}, function()
  update_clock()
end)

clock:subscribe("mouse.clicked", function()
  show_date = not show_date
  update_clock()
end)
