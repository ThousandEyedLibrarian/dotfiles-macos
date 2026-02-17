local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Event provider: fires "cpu_update" every 2 seconds
sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = sbar.add("item", "widgets.cpu", {
  position = "right",
  icon = {
    string = icons.cpu,
    color = colors.with_alpha(colors.white, 0.5),
    padding_left = 0,
    padding_right = 4,
    y_offset = 1,
  },
  label = {
    string = "?%",
    color = colors.with_alpha(colors.white, 0.5),
    padding_right = 0,
    y_offset = 1,
  },
  background = {
    color = colors.transparent,
  },
})

-- Padding to separate from brew
sbar.add("item", "widgets.cpu.padding", {
  position = "right",
  width = settings.group_paddings,
})

cpu:subscribe("cpu_update", function(env)
  local load = tonumber(env.total_load)
  local color = colors.with_alpha(colors.white, 0.5)

  if load > 80 then
    color = colors.red
  elseif load > 60 then
    color = colors.orange
  elseif load > 30 then
    color = colors.yellow
  end

  cpu:set({
    icon  = { color = color },
    label = { string = env.total_load .. "%", color = color },
  })
end)

cpu:subscribe("mouse.clicked", function()
  sbar.exec('open -na Ghostty --args -e /bin/zsh -c "btop"')
end)
