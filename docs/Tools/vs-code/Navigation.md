# VSCode Navigation Cheat Sheet

Personal shortcut reference for moving around VSCode. Includes both my
custom keybindings (from `keybindings.json`) and stock defaults I actually
use. Newest entries at the bottom of each section.

## My custom bindings

These override the defaults, set in `keybindings.json`:

|Shortcut|Action|
|---|---|
|`Ctrl+H`|Navigate to the group/pane to the left (`workbench.action.navigateLeft`)|
|`Ctrl+L`|Navigate to the group/pane to the right (`workbench.action.navigateRight`)|
|`Ctrl+K`|Navigate to the group/pane above (`workbench.action.navigateUp`)|
|`Ctrl+J`|Navigate to the group/pane below (`workbench.action.navigateDown`)|
|`Alt+\``|Open a new Terminal **editor tab** (not the panel) (`workbench.action.createTerminalEditor`)|

These are deliberately Vim-shaped (`h`/`j`/`k`/`l` for left/down/up/right)
so pane navigation matches Vim motion muscle memory instead of arrow keys.

## Stock defaults I use

|Shortcut|Action|
|---|---|
|`Cmd+P`|Quick Open — jump to any file by name|
|`Cmd+Shift+P`|Command Palette — run any VSCode/extension command by name|
|`Cmd+B`|Toggle the sidebar|
|`Cmd+J`|Toggle the integrated terminal panel|
|`Ctrl+Tab`|Cycle through open editor tabs|
|`Cmd+\`|Split the editor (new group to the right)|

## Related

- [Claude Code cheat sheet](../Claude/Claude-cheat-sheet.md) — Claude-specific
  shortcuts (chat focus, selection references).

## Adding a new entry

1. Add a row to the relevant table above (custom vs. stock).
2. If it's a custom binding, keep this file in sync with
   `~/Library/Application Support/Code/User/keybindings.json` — it's the
   source of truth, this doc is a human-readable mirror of it.
