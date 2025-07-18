#!/bin/bash

# Get current space
CURRENT_SPACE=$(yabai -m query --spaces --space | jq -r '.index')

# Open new Zen Browser window
open -na "Zen"

# Wait for window to appear
sleep 0.8

# Get the most recent Zen Browser window
LATEST_ZEN=$(yabai -m query --windows | jq '[.[] | select(.app=="Zen")] | sort_by(.id) | last | .id')

# Move to current space if window exists
if [ "$LATEST_ZEN" != "null" ] && [ "$LATEST_ZEN" != "" ]; then
    yabai -m window $LATEST_ZEN --space $CURRENT_SPACE
    yabai -m window $LATEST_ZEN --focus
fi
