#!/bin/bash
# Toggle Night Shift on macOS
# Requires: brew install smudge/smudge/nightlight
if command -v nightlight &> /dev/null; then
    if nightlight status | grep -q "on"; then
        nightlight off
    else
        nightlight on
    fi
else
    # Fallback: open Display settings
    open "x-apple.systempreferences:com.apple.preference.displays"
fi
