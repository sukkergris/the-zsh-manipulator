# Guide: Select Text, Then Ask Claude About It

## Shortcut

|Action|Shortcut|
|---|---|
|Focus Claude's chat input (carries current selection as context)|`Cmd+Escape`|
|Insert an explicit `@file#line-line` reference into the prompt|`Option+K`|

## Steps

1. Select some text in the editor. Any method works, including Vim visual
   mode if you have it enabled:
   - `viw` — inner word
   - `vi{` / `vi(` / `vi"` — inside braces/parens/quotes
   - `vip` — inner paragraph
   - `V` + `j`/`k` — whole lines
   - `v` + motion — arbitrary range
2. Press **`Cmd+Escape`** to jump focus to the chat input. The current
   selection is automatically included as context — there is no separate
   "send selection" step.
3. Type your question and send it as normal.
4. Optional: before typing, press **`Option+K`** to insert an explicit
   `@filename#startLine-endLine` reference into the prompt text, if you
   want the exact range spelled out in your own message.

## Known issue: Cmd+Escape does nothing

On some Macs this shortcut is silently intercepted by **macOS Game
Overlay**, a system feature also bound to `Cmd+Escape` (Settings →
Keyboard → Keyboard Shortcuts → Mission Control → Game Overlay). It
produces no visible effect outside of a running game, so the symptom looks
like a broken keybinding in every app, not just VSCode.

Fix: clear or rebind the Game Overlay shortcut in that panel. Full
diagnosis writeup: [Claude-on-macOs.md](../../Claude-on-macOs.md).
