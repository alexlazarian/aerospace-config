#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"
# Focus a window by its ID (passed as $1), then refresh the indicator.
# Called by SketchyBar click_script on tab items.

wid="$1"
if [ -n "$wid" ]; then
  aerospace focus --window-id "$wid"
  /Users/sixmoog/aerospace-config/update-indicator.sh &
fi
