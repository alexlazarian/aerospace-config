#!/bin/bash
# Cycle focus through windows on the current AeroSpace workspace.
# Usage: cycle-window.sh [--reverse]

# Get all window IDs on the focused workspace (one per line)
windows=$(aerospace list-windows --workspace focused --format '%{window-id}')

# Nothing to do if there are fewer than 2 windows
count=$(echo "$windows" | wc -l | tr -d ' ')
[ "$count" -lt 2 ] && exit 0

# Get the currently focused window ID
focused=$(aerospace list-windows --focused --format '%{window-id}')

# Build array compatible with macOS bash 3.2
ids=()
while IFS= read -r line; do
    ids+=("$line")
done <<< "$windows"

# Find the index of the focused window
current_index=0
for i in $(seq 0 $(( count - 1 ))); do
    if [ "${ids[$i]}" = "$focused" ]; then
        current_index=$i
        break
    fi
done

# Determine next index (with wrap-around)
if [ "${1:-}" = "--reverse" ]; then
    next_index=$(( (current_index - 1 + count) % count ))
else
    next_index=$(( (current_index + 1) % count ))
fi

aerospace focus --window-id "${ids[$next_index]}"

# Update the SketchyBar window indicator
$HOME/Dev/tools/aerospace-config/update-indicator.sh &
