#!/bin/bash

# ponytail: cache count in a file, only run `brew outdated` when the cache is
# older than a week. Routine ticks just re-render the cached value (cheap, and
# survives a sketchybar restart). Pass "force" to bypass the weekly gate.
CACHE_FILE="$HOME/.cache/sketchybar_brew_count"
STALE_SECONDS=$((7 * 24 * 60 * 60))  # 1 week

ITEM_NAME="${NAME:-brew}"

render() {
    if [ "$1" -gt 0 ]; then
        sketchybar --set "$ITEM_NAME" label.string="$1" \
                   icon.string="󰏔" \
                   icon.color=0xffd79921 \
                   label.color=0xffd79921
    else
        sketchybar --set "$ITEM_NAME" label.string="0" \
                   icon.string="󰏗" \
                   icon.color=0x7ffbf1c7 \
                   label.color=0x7ffbf1c7
    fi
}

# Use cached count if it's fresh and we weren't told to force a check
if [ "$1" != "force" ] && [ -f "$CACHE_FILE" ]; then
    age=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE") ))
    if [ "$age" -lt "$STALE_SECONDS" ]; then
        render "$(cat "$CACHE_FILE")"
        exit 0
    fi
fi

# Stale, missing, or forced: actually check for outdated packages
COUNT=$(/opt/homebrew/bin/brew outdated --quiet 2>/dev/null | wc -l | tr -d ' ')
mkdir -p "$(dirname "$CACHE_FILE")"
echo "$COUNT" > "$CACHE_FILE"
render "$COUNT"
