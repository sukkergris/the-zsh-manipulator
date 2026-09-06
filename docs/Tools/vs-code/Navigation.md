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
|`` Cmd+` ``|Create a new terminal|
|`` Cmd+Shift+` ``|Split the current terminal|
|`Option+Cmd+Left` / `Option+Cmd+Right`|Move focus between split terminals|
|`Cmd+Shift+[` / `Cmd+Shift+]`|Cycle focus to previous/next terminal (also works for editor tabs when terminal isn't focused)|
|`Cmd+K`|Clear the active terminal's scrollback|
|`Cmd+Up` / `Cmd+Down` (while terminal focused)|Scroll the terminal up/down|

Note the split: my custom `` Alt+` `` opens a terminal as its own **editor
tab** (lives among your file tabs, in `workbench.action.navigateLeft`-style
groups); stock `` Cmd+` `` opens one in the **terminal panel** at the bottom.
Different UI surface, same underlying shell.

## Navigating the Claude Code panel

Officially called the **"Claude Code panel"** in Claude's own docs (also
referred to as the Claude view/chat panel). All stock defaults below — no
custom bindings here yet.

|Shortcut|Action|
|---|---|
|`Cmd+Escape`|Toggle focus between the editor and Claude's prompt box|
|`Cmd+Shift+Escape`|Open Claude in a new conversation tab|
|`Cmd+Shift+T`|Reopen the most recently closed Claude tab|
|`Cmd+N`|New conversation (Claude must be focused; needs `enableNewConversationShortcut: true`)|
|`Ctrl+Option+F`|Toggle Focus view (hides tool-call noise, v2.1.221+)|
|`Option+K`|Insert an `@file#line-line` reference for the current selection|

**Repositioning the panel** — via Command Palette (`Cmd+Shift+P`):

- **Claude Code: Open in Side Bar** / **Open in New Tab** / **Open in New
  Window** / **Open in Terminal** — move the panel between UI surfaces.

**Session history** — click the session history button at the top of the
panel to search, browse, rename, or archive past conversations.

⚠️ **Known conflict:** Claude Code documents `Ctrl+H`, `Ctrl+J`, `Ctrl+K`
as reserved shortcuts it won't let you rebind — but this project's own
`keybindings.json` (see "My custom bindings" above) already claims those
exact chords for pane navigation. Not yet confirmed whether this causes
an actual clash in practice; worth testing if Claude Code behaves oddly
around those keys specifically.

See also: [Claude Code cheat sheet](../Claude/Claude-cheat-sheet.md) for
the full picture (selection-to-prompt workflow, the Game Overlay gotcha
on `Cmd+Escape`).

## Related

- [Claude Code cheat sheet](../Claude/Claude-cheat-sheet.md) — Claude-specific
  shortcuts (chat focus, selection references).

## Adding a new entry

1. Add a row to the relevant table above (custom vs. stock).
2. If it's a custom binding, keep this file in sync with
   `~/Library/Application Support/Code/User/keybindings.json` — it's the
   source of truth, this doc is a human-readable mirror of it.
