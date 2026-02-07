local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local battery = sbar.add("item", "battery", {
  position = "right",
  icon = {
    color = colors.white,
    padding_left = 0,
    padding_right = 4,
    y_offset = 1,
  },
  label = {
    color = colors.white,
    padding_right = 0,
    y_offset = 1,
  },
  background = {
    color = colors.transparent,  -- No background (omarchy style)
  },
  update_freq = 120,
})

-- Minimal padding
sbar.add("item", "battery.padding", {
  position = "right",
  width = settings.group_paddings
})

battery:subscribe({"routine", "power_source_change", "system_woke", "forced"}, function()
  sbar.exec("pmset -g batt", function(batt_info)
    local icon = icons.battery._0
    local label = "?"

    local found, _, charge = batt_info:find("(%d+)%%")
    if found then
      charge = tonumber(charge)
      label = charge .. "%"
    end

    local color = colors.white
    local charging, _, _ = batt_info:find("AC Power")

    if charging then
      icon = icons.battery.charging
      color = colors.green
    else
      if found and charge > 80 then
        icon = icons.battery._100
      elseif found and charge > 60 then
        icon = icons.battery._75
      elseif found and charge > 40 then
        icon = icons.battery._50
      elseif found and charge > 20 then
        icon = icons.battery._25
        color = colors.yellow
      else
        icon = icons.battery._0
        color = colors.red
      end
    end

    battery:set({
      icon = { string = icon, color = color },
      label = { string = label, color = color },
    })
  end)
end)
