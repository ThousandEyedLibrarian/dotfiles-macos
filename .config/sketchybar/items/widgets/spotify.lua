local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Spacer added first so it sits between cpu.padding and spotify
-- (right items stack leftward, so this creates the gap)
local spacer = sbar.add("item", "widgets.spotify.spacer", {
  position = "right",
  width = 20,
  drawing = false,
})

local spotify = sbar.add("item", "widgets.spotify", {
  position = "right",
  drawing = false,
  update_freq = 3,
  updates = true,
  icon = {
    string = icons.media.playing,
    color = colors.with_alpha(colors.white, 0.5),
    padding_left = 0,
    padding_right = 4,
    y_offset = 1,
  },
  label = {
    string = "",
    color = colors.with_alpha(colors.white, 0.5),
    padding_right = 0,
    y_offset = 1,
    max_chars = 20,
    scroll_duration = 200,
  },
  background = {
    color = colors.transparent,
  },
})

local function update_spotify()
  sbar.exec('osascript -e \'tell application "System Events" to (name of processes) contains "Spotify"\'', function(running)
    if running:match("true") then
      sbar.exec('osascript -e \'tell application "Spotify" to {player state as string, artist of current track as string, name of current track as string}\'', function(result)
        local state, artist, title = result:match("^(%w+), (.-), (.+)")
        if artist and title then
          title = title:gsub("%s+$", "")
          local label_color = (state == "playing")
            and colors.with_alpha(colors.white, 0.5)
            or colors.with_alpha(colors.white, 0.3)
          spotify:set({
            drawing = true,
            label = { string = artist .. " - " .. title, color = label_color },
            icon = { color = label_color },
          })
          spacer:set({ drawing = true })
        else
          spotify:set({ drawing = true, label = { string = "" } })
          spacer:set({ drawing = true })
        end
      end)
    else
      spotify:set({ drawing = false })
      spacer:set({ drawing = false })
    end
  end)
end

spotify:subscribe("routine", update_spotify)
spotify:subscribe("forced", update_spotify)

spotify:subscribe("mouse.clicked", function()
  sbar.exec('osascript -e \'tell application "Spotify" to playpause\'')
end)

spotify:subscribe("mouse.scrolled", function(env)
  if tonumber(env.SCROLL_DELTA) > 0 then
    sbar.exec('osascript -e \'tell application "Spotify" to previous track\'')
  else
    sbar.exec('osascript -e \'tell application "Spotify" to next track\'')
  end
end)

update_spotify()
