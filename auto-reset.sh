#!/bin/bash
# Auto-correct off-screen floating windows after workspace switch.
# Runs via exec-on-workspace-change — only repositions windows that have
# drifted to clamped/off-screen positions, leaves everything else alone.

export PATH="/opt/homebrew/bin:$PATH"

# Get screen bounds dynamically via NSScreen (no Finder access required)
bounds=$(osascript -l JavaScript -e 'ObjC.import("AppKit"); var f=$.NSScreen.mainScreen.frame; f.size.width+","+f.size.height' 2>/dev/null)
screen_w=$(echo "$bounds" | cut -d',' -f1)
screen_h=$(echo "$bounds" | cut -d',' -f2)

if [ -z "$screen_w" ] || [ -z "$screen_h" ]; then exit 0; fi

# Get all apps on the focused workspace
apps=$(aerospace list-windows --workspace focused --format '%{app-name}' 2>/dev/null | sort -u)
if [ -z "$apps" ]; then exit 0; fi

while IFS= read -r app; do
  osascript -e "
    set sw to $screen_w
    set sh to $screen_h
    tell application \"System Events\"
      tell process \"$app\"
        repeat with w in every window
          set {wx, wy} to position of w
          -- Reposition only if the window has drifted off-screen
          if wx > (sw - 50) or wx < -50 or wy > (sh - 50) or wy < -50 then
            set position of w to {100, 100}
          end if
        end repeat
      end tell
    end tell
  " 2>/dev/null &
done <<< "$apps"

wait
