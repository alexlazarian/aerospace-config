#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="$HOME/.aerospace.toml"

usage() {
    echo "Usage: $(basename "$0") <full|workspaces-only>"
    echo ""
    echo "Switches the active AeroSpace config by symlinking ~/.aerospace.toml"
    echo ""
    echo "Profiles:"
    echo "  full             Full tiling WM (i3-like keybindings, layouts, resize mode)"
    echo "  workspaces-only  Workspaces only (windows behave normally, no tiling)"
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
    full|workspaces-only)
        SOURCE="$CONFIG_DIR/$1.toml"
        ;;
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
echo "Switched to '$1' profile: $TARGET -> $SOURCE"

if command -v aerospace &>/dev/null; then
    aerospace reload-config
    echo "AeroSpace config reloaded."
else
    echo "Run 'aerospace reload-config' to apply changes."
fi
