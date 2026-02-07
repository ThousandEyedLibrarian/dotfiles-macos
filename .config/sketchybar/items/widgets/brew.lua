local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local UPDATE_SCRIPT = "/Users/carter/.config/sketchybar/plugins/brew_update.sh"

local brew = sbar.add("item", "brew", {
  position = "right",
  icon = {
    string = icons.brew.default,
    color = colors.with_alpha(colors.white, 0.5),
    padding_left = 0,
    padding_right = 4,
    y_offset = 1,
  },
  label = {
    string = "?",
    color = colors.with_alpha(colors.white, 0.5),
    padding_right = 0,
    y_offset = 1,
  },
  background = {
    color = colors.transparent,
  },
  update_freq = 1800,
})

-- Padding
sbar.add("item", "brew.padding", {
  position = "right",
  width = settings.group_paddings
})

-- Run update script on events
brew:subscribe({"routine", "forced", "system_woke"}, function()
  os.execute(UPDATE_SCRIPT .. " &")
end)

-- Click to upgrade packages in Kitty terminal
brew:subscribe("mouse.clicked", function()
  sbar.exec('kitty -e /bin/zsh -c "/opt/homebrew/bin/brew upgrade; echo; echo Done. Press enter to close.; read"')
end)
