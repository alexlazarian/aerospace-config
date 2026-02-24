# AeroSpace Config

Two profiles for [AeroSpace](https://github.com/nikitabobko/AeroSpace) window manager on macOS, with [SketchyBar](https://github.com/alexlazarian/sketchybar-config) integration for a custom menu bar.

## Profiles

| Profile | Description |
|---------|-------------|
| `full` | Full i3-like tiling WM — focus/move bindings, layouts, resize mode, floating toggle |
| `workspaces-only` | Workspaces only — all windows float (normal macOS behavior), just workspace switching |

## Usage

```bash
./switch.sh 1   # full tiling mode
./switch.sh 2   # workspaces-only mode
```

The script symlinks `~/.aerospace.toml` to the selected profile and reloads AeroSpace automatically.

### Optional: shell alias

Add this to your `~/.zshrc` for quick switching:

```bash
alias aero="$HOME/aerospace-config/switch.sh"
```

Then reload your shell (`source ~/.zshrc`) and use:

```bash
aero 1   # full tiling mode
aero 2   # workspaces-only mode
```

## Keybindings (both profiles)

| Shortcut | Action |
|----------|--------|
| `alt-tab` / `alt-shift-tab` | Cycle through windows on current workspace |
| `alt-1..0` | Switch to workspace 1–10 |
| `alt-shift-1..0` | Move window to workspace 1–10 |
| `alt-shift-r` | Reset stuck/hidden windows on current workspace |
| `alt-shift-c` | Reload AeroSpace config |

### full.toml only

| Shortcut | Action |
|----------|--------|
| `alt-j/k/l/;` | Focus left/down/up/right |
| `alt-shift-j/k/l/;` | Move window left/down/up/right |
| `alt-s/w/e` | Stacking / tabbed / tiled layout |
| `alt-f` | Fullscreen |
| `alt-shift-space` | Toggle floating |
| `alt-r` | Enter resize mode |

## SketchyBar integration

Both profiles integrate with [SketchyBar](https://github.com/alexlazarian/sketchybar-config) for a custom menu bar that shows:

- **Workspace number** on the left
- **ActivityWatch status** (green dot = running, click to open dashboard)
- **Clock** in the center
- **Clickable app tabs** on the right with app icons (click to focus)

See the [sketchybar-config](https://github.com/alexlazarian/sketchybar-config) repo for setup instructions.

## Scripts

| Script | Purpose |
|--------|---------|
| `switch.sh` | Switch between config profiles |
| `cycle-window.sh` | Alt-tab window cycling on current workspace |
| `update-indicator.sh` | Updates SketchyBar workspace number and app tabs |
| `focus-tab.sh` | Focuses a window when clicking its SketchyBar tab |
| `reset-windows.sh` | Resets stuck/hidden window positions via AppleScript |

## Prerequisites

- [AeroSpace](https://github.com/nikitabobko/AeroSpace): `brew install --cask nikitabobko/tap/aerospace`
- [SketchyBar](https://github.com/FelixKratz/SketchyBar): `brew install FelixKratz/formulae/sketchybar`
- [ActivityWatch](https://activitywatch.net/): `brew install --cask activitywatch`
