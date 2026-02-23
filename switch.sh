#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$HOME/.aerospace.toml"

usage() {
    echo "Usage: $(basename "$0") <1|2>"
    echo ""
    echo "Switches the active AeroSpace config by symlinking ~/.aerospace.toml"
    echo ""
    echo "Profiles:"
    echo "  1  Full tiling WM (i3-like keybindings, layouts, resize mode)"
    echo "  2  Workspaces only (windows behave normally, no tiling)"
    echo ""
    echo "Current: $(current_profile)"
    exit 1
}

current_profile() {
    if [ -L "$TARGET" ]; then
        local link
        link="$(readlink "$TARGET")"
        basename "$link" .toml
    elif [ -f "$TARGET" ]; then
        echo "unmanaged (not a symlink)"
    else
        echo "none"
    fi
}

if [ $# -ne 1 ]; then
    usage
fi

case "$1" in
    1) SOURCE="$CONFIG_DIR/full.toml"; PROFILE="full" ;;
    2) SOURCE="$CONFIG_DIR/workspaces-only.toml"; PROFILE="workspaces-only" ;;
    *)
        echo "Error: unknown profile '$1'"
        echo ""
        usage
        ;;
esac

if [ ! -f "$SOURCE" ]; then
    echo "Error: config file not found: $SOURCE"
    exit 1
fi

if [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "Warning: $TARGET exists and is not a symlink."
    echo "Backing up to $TARGET.bak"
    cp "$TARGET" "$TARGET.bak"
fi

ln -sf "$SOURCE" "$TARGET"
echo "Switched to '$PROFILE' profile"

if command -v aerospace &>/dev/null; then
    aerospace reload-config
    echo "AeroSpace config reloaded."
else
    echo "Run 'aerospace reload-config' to apply changes."
fi
