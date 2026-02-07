#\!/bin/bash
if pgrep -x "ghostty" > /dev/null 2>&1; then
    osascript -e '
        tell application "System Events"
            tell process "ghostty"
                click menu item "New Window" of menu "File" of menu bar 1
            end tell
        end tell
    '
else
    open -a Ghostty
fi
