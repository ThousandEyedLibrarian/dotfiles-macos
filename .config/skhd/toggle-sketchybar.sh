#!/bin/bash
# Toggle sketchybar, keeping yabai's top offset in sync so no gap is left behind
if [ "$(sketchybar --query bar | jq -r '.hidden')" = "on" ]; then
    sketchybar --bar hidden=off
    yabai -m config external_bar all:30:0
else
    sketchybar --bar hidden=on
    yabai -m config external_bar all:0:0
fi
