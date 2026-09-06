# Guide: Starting a Fresh Conversation

Two different shortcuts start a conversation with no prior history —
they differ in whether the old conversation stays reachable.

## Shortcut

| Action | Shortcut | Requires a setting? |
| --- | --- | --- |
| Open a new conversation as a **new tab** (old one stays open) | `Cmd+Shift+Escape` | No |
| **Clear the current tab** in place, starting fresh | `Cmd+N` | Yes — see below |

## Which one to use

- **Want to keep working in an existing conversation later** (e.g. you're
  mid-task in one chat and want to point a fresh prompt at a doc, like
  `docs/learning-plan/Lesson-1.md`, without losing this one)? Use
  **`Cmd+Shift+Escape`**. It opens a new tab; the old conversation is
  still there, unchanged, whenever you switch back to it.
- **Done with the current conversation and want to reuse the same tab**?
  Use `Cmd+N` — but only after enabling it (see below). This replaces the
  current chat's history in place rather than adding a new tab.

## Enabling Cmd+N

`Cmd+N` ("New Conversation") is **disabled by default**. To turn it on,
add to VSCode settings (`settings.json`):

```json
"claudeCode.enableNewConversationShortcut": true
```

Without this, `Cmd+N` does nothing when Claude's panel is focused.

## Notes

- Both require Claude's panel to be focused first (see
  [Select text, then ask Claude](Claude-Select-Text-Form-Prompting.md) for
  how focus/`Cmd+Escape` works).
- Neither shortcut deletes conversation history permanently — past
  conversations remain in Claude Code's session history (accessible via
  the session history button at the top of the panel), even after
  starting a new one.
