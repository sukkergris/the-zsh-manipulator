# Claude Code on macOS — Editor Integration Notes

Troubleshooting notes specific to running Claude Code's IDE integration
(VSCode-family editor, panel/chat UI) on macOS.

## Cmd+Escape ("Focus input") silently does nothing

**Symptom:** Claude Code for VS Code binds `⌘ Escape` to **"Claude Code:
Focus input"** (jumps focus to the chat input, carrying the current editor
selection along as context). On some Macs, pressing it does *nothing* —
no error, no focus change, nothing — in VSCode, and also nothing in any
other app.

**Root cause: macOS "Game Overlay" claims Cmd+Escape system-wide.**

Apple added a system feature called **Game Overlay** (a HUD for Game
Center, controller status, screen recording, etc., shown while a game is
running). It is bound to `Cmd+Escape` by default, registered under:

    System Settings → Keyboard → Keyboard Shortcuts → Mission Control
    → Game Overlay

Because Game Overlay's HUD "only appears when a game is running," pressing
Cmd+Escape outside of a game context has **no visible effect whatsoever**
— but macOS still intercepts and consumes the keypress at the OS level,
before it ever reaches any application (VSCode included). This makes it
look exactly like a silent, unexplainable app-level bug.

**How this was diagnosed** (useful technique for similar "shortcut does
nothing" mysteries):

1. Confirmed the physical keypress was correct using a keystroke visualizer
   (Keycaster) — ruled out a typo/hardware issue.
2. Confirmed no conflicting VSCode/extension keybinding was involved, using
   VSCode's built-in keybinding dispatch log:
   `Cmd+Shift+P` → **"Developer: Toggle Keyboard Shortcuts
   Troubleshooting"**, then check the **Output panel** (Window /
   Keybindings channel). The log showed Cmd (Meta) arriving as its own
   keydown, then timing out ("Clearing single modifier due to 300ms
   elapsed.") with Escape never arriving as part of a combined chord — the
   chord was being split/eaten before VSCode's dispatcher saw it.
3. Ruled out third-party interference: disabled Keycaster (an event-hooking
   tool) — no change, so it wasn't the interferer.
4. Ruled out Rectangle (window manager) by checking its shortcuts panel
   directly — none of its bindings used Escape.
5. Tested at the OS level, outside any app entirely (plain TextEdit /
   Spotlight): Cmd+Escape produced no visible effect anywhere — confirming
   this was a system-level interception, not anything VSCode- or
   Claude-Code-specific.
6. Checked System Settings → Keyboard → Keyboard Shortcuts →
   **Accessibility** (VoiceOver's default shortcut is nearby territory) —
   nothing bound there.
7. Checked **Mission Control** shortcuts next — found "Game Overlay" bound
   to Cmd+Escape. Confirmed via web search that this is a known, recently
   added macOS feature with exactly this "looks broken, does nothing
   outside a game" behavior.

**Fix:** in that same panel (System Settings → Keyboard → Keyboard
Shortcuts → Mission Control), find the **Game Overlay** row and either:

- Clear its shortcut (click the binding, then delete/unset it), or
- Rebind it to a key you won't hit by accident.

Once cleared, Cmd+Escape reaches VSCode normally again.

**Alternative fix**, if you'd rather not touch a system shortcut: rebind
Claude Code's own command instead, via VSCode's Keyboard Shortcuts editor
(`Cmd+K Cmd+S`, search "Claude Code: Focus input", assign a different
chord).

## Related

- [Claude Code — VS Code docs](https://code.claude.com/docs/en/vs-code.md)
- [Claude Code — Keybindings docs](https://code.claude.com/docs/en/keybindings.md)
- [Apple Community thread on disabling the Game Overlay shortcut](https://discussions.apple.com/thread/256144225)
