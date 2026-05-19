local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- ============ POMODORO CONFIG ============
-- Edit values here, then run `sketchybar --reload` to apply.
local config = {
  work_minutes        = 25,
  short_break_minutes = 5,
  long_break_minutes  = 15,
  long_break_every    = 4,        -- long break after every N work phases
  notify_on_finish    = true,     -- macOS notification when a phase ends
  notify_sound        = "Glass",  -- system sound name, "" or nil for silent
}
-- =========================================

local GLYPH = {
  timer    = "",
  play     = "",
  pause    = "",
  skip     = "",
  reset    = "",
  settings = "",
}

local state = {
  phase          = "work",
  running        = false,
  remaining      = config.work_minutes * 60,
  completed_work = 0,
}

local function phase_seconds(phase)
  if phase == "work"        then return config.work_minutes        * 60 end
  if phase == "short_break" then return config.short_break_minutes * 60 end
  if phase == "long_break"  then return config.long_break_minutes  * 60 end
  return config.work_minutes * 60
end

local function phase_base_color()
  if state.phase == "work"        then return colors.red   end
  if state.phase == "short_break" then return colors.green end
  return colors.blue
end

local function active_color()
  if state.running then return phase_base_color() end
  if state.remaining == phase_seconds(state.phase) then
    return colors.with_alpha(colors.white, 0.5)
  end
  return colors.with_alpha(phase_base_color(), 0.5)
end

local function format_remaining()
  local m = math.floor(state.remaining / 60)
  local s = state.remaining % 60
  return string.format("%02d:%02d", m, s)
end

local function advance_phase()
  if state.phase == "work" then
    state.completed_work = state.completed_work + 1
    if state.completed_work % config.long_break_every == 0 then
      state.phase = "long_break"
    else
      state.phase = "short_break"
    end
  else
    state.phase = "work"
  end
  state.remaining = phase_seconds(state.phase)
end

local function notify(msg)
  if not config.notify_on_finish then return end
  local sound = config.notify_sound or ""
  if sound ~= "" then
    sbar.exec(string.format(
      [[osascript -e 'display notification "%s" with title "Pomodoro" sound name "%s"']],
      msg, sound))
  else
    sbar.exec(string.format(
      [[osascript -e 'display notification "%s" with title "Pomodoro"']], msg))
  end
end

-- ---------- main bar item ----------
local pomodoro = sbar.add("item", "widgets.pomodoro", {
  position    = "right",
  update_freq = 1,
  icon = {
    string        = GLYPH.timer,
    padding_left  = 0,
    padding_right = 4,
    y_offset      = 1,
  },
  label = {
    string        = format_remaining(),
    padding_right = 0,
    y_offset      = 1,
  },
  background = { color = colors.transparent },
  popup = {
    align        = "center",
    horizontal   = false,
    background   = {
      color        = colors.popup.bg,
      border_color = colors.popup.border,
      border_width = 2,
      corner_radius = 6,
    },
  },
})

sbar.add("item", "widgets.pomodoro.padding", {
  position = "right",
  width    = settings.group_paddings,
})

-- ---------- popup buttons ----------
local function make_popup_item(name, glyph, text)
  return sbar.add("item", name, {
    position = "popup." .. pomodoro.name,
    icon = {
      string        = glyph,
      color         = colors.with_alpha(colors.white, 0.9),
      padding_left  = 10,
      padding_right = 8,
      width         = 20,
    },
    label = {
      string        = text,
      color         = colors.with_alpha(colors.white, 0.9),
      padding_left  = 0,
      padding_right = 14,
      width         = 97,
      align         = "left",
    },
    background = { color = colors.transparent },
  })
end

local toggle_btn   = make_popup_item("widgets.pomodoro.toggle",   GLYPH.play,     "Start")
local skip_btn     = make_popup_item("widgets.pomodoro.skip",     GLYPH.skip,     "Skip phase")
local reset_btn    = make_popup_item("widgets.pomodoro.reset",    GLYPH.reset,    "Reset")
local settings_btn = make_popup_item("widgets.pomodoro.settings", GLYPH.settings, "Edit settings")

-- ---------- rendering ----------
local function render()
  local c = active_color()
  pomodoro:set({
    icon  = { color = c },
    label = { string = format_remaining(), color = c },
  })
  toggle_btn:set({
    icon  = { string = state.running and GLYPH.pause or GLYPH.play },
    label = { string = state.running and "Pause"     or "Start"     },
  })
end

local function close_popup()
  pomodoro:set({ popup = { drawing = false } })
end

-- ---------- tick ----------
pomodoro:subscribe("routine", function()
  if not state.running then return end
  state.remaining = state.remaining - 1
  if state.remaining <= 0 then
    local finished = state.phase:gsub("_", " ")
    advance_phase()
    notify(finished .. " finished")
  end
  render()
end)

-- ---------- clicks ----------
local function do_toggle()
  state.running = not state.running
  render()
end

pomodoro:subscribe("mouse.clicked", function(env)
  if env.BUTTON == "right" then
    pomodoro:set({ popup = { drawing = "toggle" } })
  else
    do_toggle()
  end
end)

toggle_btn:subscribe("mouse.clicked", function()
  do_toggle()
  close_popup()
end)

skip_btn:subscribe("mouse.clicked", function()
  local finished = state.phase:gsub("_", " ")
  advance_phase()
  notify(finished .. " skipped")
  render()
  close_popup()
end)

reset_btn:subscribe("mouse.clicked", function()
  state.remaining = phase_seconds(state.phase)
  render()
  close_popup()
end)

settings_btn:subscribe("mouse.clicked", function()
  sbar.exec([[open -na Ghostty --args -e /bin/zsh -c "${EDITOR:-nvim} ~/.config/sketchybar/items/widgets/pomodoro.lua"]])
  close_popup()
end)

-- Close popup when cursor leaves the bar entirely
pomodoro:subscribe("mouse.exited.global", close_popup)

render()
