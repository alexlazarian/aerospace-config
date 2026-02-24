#!/bin/bash
export PATH="/opt/homebrew/bin:$PATH"
# Update SketchyBar: workspace number + window tabs with app icons and names.
# Tab items tab.0–tab.9 are pre-created in sketchybarrc — this script
# just shows/hides and updates labels to avoid flashing.

# Bail out if sketchybar isn't running
if ! pgrep -x sketchybar >/dev/null 2>&1; then
  exit 0
fi

# Update workspace number
ws=$(aerospace list-workspaces --focused 2>/dev/null)
if [ -n "$ws" ]; then
  sketchybar --set workspace label="$ws"
fi

# Get all windows on focused workspace: "id|app-name|bundle-id" per line
window_list=$(aerospace list-windows --workspace focused --format '%{window-id}|%{app-name}|%{app-bundle-id}' 2>/dev/null)

# Get the focused window ID
focused=$(aerospace list-windows --focused --format '%{window-id}' 2>/dev/null)

# Count windows
count=0
if [ -n "$window_list" ]; then
  count=$(echo "$window_list" | wc -l | tr -d ' ')
fi

# Hide all tabs if 0 windows
if [ "$count" -eq 0 ]; then
  for i in $(seq 0 9); do
    sketchybar --set "tab.$i" drawing=off 2>/dev/null
  done
  exit 0
fi

# Update each tab slot
index=0
while IFS='|' read -r wid app bundle; do
  click_cmd="/Users/sixmoog/aerospace-config/focus-tab.sh $wid"

  if [ "$wid" = "$focused" ]; then
    # Focused tab: bold text on white background, app icon
    sketchybar --set "tab.$index" \
      drawing=on \
      label="$app" \
      label.font="SF Pro:Bold:12.0" \
      label.color=0xff1e1e2e \
      icon.drawing=on \
      icon.background.drawing=on \
      icon.background.image="app.$bundle" \
      icon.background.image.scale=0.5 \
      background.drawing=on \
      click_script="$click_cmd"
  else
    # Inactive tab: dimmed text, no background, app icon
    sketchybar --set "tab.$index" \
      drawing=on \
      label="$app" \
      label.font="SF Pro:Regular:12.0" \
      label.color=0x99ffffff \
      icon.drawing=on \
      icon.background.drawing=on \
      icon.background.image="app.$bundle" \
      icon.background.image.scale=0.5 \
      background.drawing=off \
      click_script="$click_cmd"
  fi
  index=$((index + 1))
done <<< "$window_list"

# Hide unused tab slots
for i in $(seq "$index" 9); do
  sketchybar --set "tab.$i" drawing=off 2>/dev/null
done
