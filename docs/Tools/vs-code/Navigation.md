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

## Navigating the terminal pane

All stock defaults — no custom bindings here yet.

|Shortcut|Action|
|---|---|
|`Cmd+J`|Toggle the terminal panel open/closed|
|`` Ctrl+` ``|Focus the terminal (opens it if closed)|
|`Cmd+\``|Create a new terminal|
|`Cmd+Shift+\``|Split the current terminal|
|`Option+Cmd+Left` / `Option+Cmd+Right`|Move focus between split terminals|
|`Cmd+Shift+[` / `Cmd+Shift+]`|Cycle focus to previous/next terminal (also works for editor tabs when terminal isn't focused)|
|`Cmd+K`|Clear the active terminal's scrollback|
|`Cmd+Up` / `Cmd+Down` (while terminal focused)|Scroll the terminal up/down|

Note the split: my custom `` Alt+` `` opens a terminal as its own **editor
tab** (lives among your file tabs, in `workbench.action.navigateLeft`-style
groups); stock `` Cmd+` `` opens one in the **terminal panel** at the bottom.
Different UI surface, same underlying shell.

## Related

- [Claude Code cheat sheet](../Claude/Claude-cheat-sheet.md) — Claude-specific
  shortcuts (chat focus, selection references).

## Adding a new entry

1. Add a row to the relevant table above (custom vs. stock).
2. If it's a custom binding, keep this file in sync with
   `~/Library/Application Support/Code/User/keybindings.json` — it's the
   source of truth, this doc is a human-readable mirror of it.
