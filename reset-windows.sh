#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"
# Reset all windows on the current workspace: reposition them via System Events.
# Uses System Events instead of app-specific AppleScript so it works for any app
# (including 1Password and other apps that don't expose bounds control).

# Get all app names on the focused workspace (unique)
apps=$(aerospace list-windows --workspace focused --format '%{app-name}' 2>/dev/null | sort -u)

if [ -z "$apps" ]; then
  exit 0
fi

while IFS= read -r app; do
  osascript -e "
    tell application \"$app\" to activate
    tell application \"System Events\"
      tell process \"$app\"
        repeat with w in every window
          set position of w to {100, 100}
        end repeat
      end tell
    end tell
  " 2>/dev/null &
done <<< "$apps"

wait
