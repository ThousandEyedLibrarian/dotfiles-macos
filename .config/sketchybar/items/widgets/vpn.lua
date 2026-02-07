local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local vpn = sbar.add("item", "vpn", {
  position = "right",
  icon = {
    string = icons.vpn.disconnected,
    color = colors.with_alpha(colors.white, 0.5),
    padding_left = 0,
    padding_right = 4,
    y_offset = 1,
  },
  label = {
    string = "--",
    color = colors.with_alpha(colors.white, 0.5),
    padding_right = 2,
    y_offset = 1,
  },
  background = {
    color = colors.transparent,
  },
  update_freq = 5,
})

-- Minimal padding
sbar.add("item", "vpn.padding", {
  position = "right",
  width = settings.group_paddings
})

local function update_vpn_status()
  sbar.exec("scutil --nc list 2>/dev/null | grep -i proton | grep -q '(Connected)' && echo 'connected' || echo 'disconnected'", function(status)
    local connected = status:gsub("%s+", "") == "connected"

    if connected then
      sbar.exec("curl -s --max-time 2 https://ifconfig.co/country-iso 2>/dev/null | tr -d '\\n'", function(country)
        local country_code = (country ~= "" and #country == 2) and country or "??"
        vpn:set({
          icon = {
            string = icons.vpn.connected,
            color = colors.green,
          },
          label = {
            string = country_code,
            color = colors.green,
          },
        })
      end)
    else
      vpn:set({
        icon = {
          string = icons.vpn.disconnected,
          color = colors.with_alpha(colors.white, 0.5),
        },
        label = {
          string = "--",
          color = colors.with_alpha(colors.white, 0.5),
        },
      })
    end
  end)
end

-- Toggle VPN on click
vpn:subscribe("mouse.clicked", function()
  sbar.exec("scutil --nc list 2>/dev/null | grep -i proton | grep -q '(Connected)' && echo 'connected' || echo 'disconnected'", function(status)
    local connected = status:gsub("%s+", "") == "connected"
    if connected then
      sbar.exec('scutil --nc stop "ProtonVPN"')
    else
      sbar.exec('scutil --nc start "ProtonVPN"')
    end
    -- Update status after toggle
    sbar.exec("sleep 2 && sketchybar --trigger forced")
  end)
end)

vpn:subscribe({"routine", "forced", "system_woke"}, update_vpn_status)
