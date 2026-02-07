#!/bin/bash
# Toggle yabai window gaps between 0 and omarchy defaults (5/10)
current_gap=$(yabai -m config window_gap)
if [ "$current_gap" -gt 0 ]; then
    yabai -m config window_gap 0
    yabai -m config top_padding 0
    yabai -m config bottom_padding 0
    yabai -m config left_padding 0
    yabai -m config right_padding 0
else
    yabai -m config window_gap 5
    yabai -m config top_padding 10
    yabai -m config bottom_padding 10
    yabai -m config left_padding 10
    yabai -m config right_padding 10
fi
