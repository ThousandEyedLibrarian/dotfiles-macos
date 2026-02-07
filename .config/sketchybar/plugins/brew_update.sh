#!/bin/bash

# Get outdated package count
COUNT=$(/opt/homebrew/bin/brew outdated --quiet 2>/dev/null | wc -l | tr -d ' ')

# Use $NAME if available (from sketchybar), otherwise use "brew"
ITEM_NAME="${NAME:-brew}"

# Update sketchybar
if [ "$COUNT" -gt 0 ]; then
    sketchybar --set "$ITEM_NAME" label.string="$COUNT" \
               icon.string="󰏔" \
               icon.color=0xffd79921 \
               label.color=0xffd79921
else
    sketchybar --set "$ITEM_NAME" label.string="0" \
               icon.string="󰏗" \
               icon.color=0x7ffbf1c7 \
               label.color=0x7ffbf1c7
fi
