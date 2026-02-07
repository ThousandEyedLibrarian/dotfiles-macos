local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local volume = sbar.add("item", "volume", {
  position = "right",
  icon = {
    string = icons.volume._100,
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
    color = colors.transparent,
  },
  popup = {
    align = "center",
    height = 30,
  }
})

-- Minimal slider popup
local volume_slider = sbar.add("slider", 120, {
  position = "popup." .. volume.name,
  slider = {
    highlight_color = colors.white,
    background = {
      height = 4,
      corner_radius = 2,
      color = colors.with_alpha(colors.white, 0.2),
    },
    knob = {
      string = "",
      drawing = false,
    },
  },
  background = {
    color = colors.transparent,
    height = 30,
    padding_left = 10,
    padding_right = 10,
  },
  click_script = 'osascript -e "set volume output volume $PERCENTAGE"'
})

-- Minimal padding
sbar.add("item", "volume.padding", {
  position = "right",
  width = settings.group_paddings
})

-- Update volume display
volume:subscribe("volume_change", function(env)
  local vol = tonumber(env.INFO)
  local icon = icons.volume._0
  if vol > 60 then
    icon = icons.volume._100
  elseif vol > 30 then
    icon = icons.volume._66
  elseif vol > 10 then
    icon = icons.volume._33
  elseif vol > 0 then
    icon = icons.volume._10
  end

  volume:set({
    icon = { string = icon },
    label = { string = vol .. "%" },
  })
  volume_slider:set({ slider = { percentage = vol } })
end)

-- Toggle popup on click
local function toggle_popup()
  local drawing = volume:query().popup.drawing == "on"
  volume:set({ popup = { drawing = not drawing } })
end

local function hide_popup()
  volume:set({ popup = { drawing = false } })
end

-- Scroll to adjust volume
local function scroll_volume(env)
  local delta = env.SCROLL_DELTA
  sbar.exec('osascript -e "set volume output volume (output volume of (get volume settings) + ' .. delta .. ')"')
end

volume:subscribe("mouse.clicked", toggle_popup)
volume:subscribe("mouse.exited.global", hide_popup)
volume:subscribe("mouse.scrolled", scroll_volume)
