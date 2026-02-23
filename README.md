# AeroSpace Config

Two profiles for [AeroSpace](https://github.com/nikitabobko/AeroSpace) window manager on macOS.

## Profiles

| Profile | Description |
|---------|-------------|
| `full` | Full i3-like tiling WM — focus/move bindings, layouts, resize mode, floating toggle |
| `workspaces-only` | Workspaces only — all windows float (normal macOS behavior), just workspace switching |

## Usage

```bash
# Switch to full tiling mode
./switch.sh full

# Switch to workspaces-only mode
./switch.sh workspaces-only
```

The script symlinks `~/.aerospace.toml` to the selected profile and reloads AeroSpace automatically.

### Optional: shell alias

Add this to your `~/.zshrc` for quick switching:

```bash
alias aero="$HOME/aerospace-config/switch.sh"
```

Then reload your shell (`source ~/.zshrc`) and use:

```bash
aero full
aero workspaces-only
```

## What's in each profile

### full.toml
- Focus wrapping (alt-j/k/l/;)
- Window moving (alt-shift-j/k/l/;)
- Layouts: stacking, tabbed, tiled (alt-s/w/e)
- Fullscreen (alt-f)
- Floating toggle (alt-shift-space)
- Resize mode (alt-r)
- Workspace switching (alt-1..0)
- Move to workspace (alt-shift-1..0)

### workspaces-only.toml
- All windows float by default (normal macOS window behavior)
- Workspace switching (alt-1..0)
- Move to workspace (alt-shift-1..0)
- Config reload (alt-shift-c)
