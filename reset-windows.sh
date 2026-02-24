#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"
# Reset all windows on the current workspace: unminimize and reposition them.

# Get all app names on the focused workspace (unique)
apps=$(aerospace list-windows --workspace focused --format '%{app-name}' 2>/dev/null | sort -u)

if [ -z "$apps" ]; then
  exit 0
fi

while IFS= read -r app; do
  osascript -e "
    tell application \"$app\"
      activate
      set allWindows to every window
      repeat with w in allWindows
        set bounds of w to {100, 100, 1200, 800}
      end repeat
    end tell
  " 2>/dev/null &
done <<< "$apps"

wait
