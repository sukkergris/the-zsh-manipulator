# Copilot Instructions

## What This Is

A learning project for building zsh plugins/extensions (functions, aliases,
hooks, completions — and eventually a compiled helper binary in Zig), using
`~/.oh-my-zsh/custom/plugins/kollzsh` as a reference for patterns, not to be
copied wholesale. The repo is in an early state: dev environment and
conventions are being established before real plugin functionality exists.

## Working Mode — teach, don't implement

This is a learning project. The point is for the **user** to write the zsh
code and build muscle memory.

- Explain concepts, walk through code, and show examples inline in chat
  (text/code blocks/terminal output) by default.
- Do **not** create or edit a file unless the user's **current message**
  explicitly asks for that file to be created or changed (e.g. "create this
  file", "write this test", "update koll.zsh"). Approval from earlier in the
  conversation does not carry forward — each file change needs its own
  explicit ask.
- Read-only exploration (reading files, searching, running existing tests)
  is always fine without asking.
- When it's unclear whether a message authorizes a file change, ask first.

## Language

All documentation, comments, commit messages, and code (identifiers, output
strings) are written in English (US), regardless of the language used in
conversation.

## Build / Test Commands

Test framework is [shellspec](https://github.com/shellspec/shellspec)
(`.shellspec` pins `--shell zsh`; minimum version 0.28.1 is enforced in
`spec/spec_helper.sh`). Spec files live in `spec/`, named `*_spec.sh`.

- Run full suite: `shellspec` (or `task spec:run`)
- Run a single spec file: `shellspec spec/some_spec.sh` (or
  `task spec:file -- spec/some_spec.sh`)
- Watch mode (fast dev loop): `shellspec --watch` (or `task spec:watch`)
- Scaffold `spec/` (one-time, already done): `task spec:init`
- Install shellspec via Homebrew: `./scripts/install-shellspec.sh`
- `task` (no args) lists all available tasks (`Taskfile.yml` includes
  `Taskfile.Shellspec.yml`)

The test/iterate loop (write a failing test → make it pass → refactor) is
the top priority to keep fast and protected — introduce new concepts with a
test-first example where practical.

## Architecture

- **Top-level zsh plugin code** (e.g. `koll.zsh`) follows the Oh My Zsh
  plugin convention (`<name>.plugin.zsh` entry point). All zsh source and
  its specs (`spec/`) stay at repo root — this is deliberate, not scaffolding
  left over.
- **`lib-bash/`** is a separate bash (not zsh) module system used for
  dev-environment/setup scripts, not the plugin itself:
  - `root-loader.sh` walks up from its own location (max 5 levels) looking
    for the `root-marker` file to determine `PROJECT_ROOT`, and exports
    `PROJECT_ROOT`, `LIB_DIR`, `SCRIPTS_DIR`. The `root-marker` file must not
    be removed/renamed without updating this logic.
  - `module-loader.sh` provides `load_module`/`load_optional_module`, which
    `find` a module by basename anywhere under `LIB_DIR` and `source` it
    exactly once (tracked in `LOADED_MODULES`).
  - `header.sh` is the standard entry point for bash scripts: sourcing it
    loads `root-loader.sh` and `module-loader.sh`, then always loads
    `error-handling` and `logging` modules.
  - `error-handling.sh` sets `set -Eeuo pipefail` and installs an ERR trap
    that prints exit code/line/command and exits.
  - `logging.sh` provides `log::info`, `log::warn`, `log::error`, `log::ok`
    helpers with ANSI colors.
  - `os-detection.sh` exports `OS_FAMILY`, `OS`, `IS_WSL`, `ARCH`,
    `IN_CONTAINER` and helper predicates (`is_macos`, `is_linux`,
    `is_wsl`, `is_container_runtime`, etc.).
- **`src/`** is reserved only for the future compiled Zig helper binary and
  should not be created until that binary is actually being added. The zsh
  layer is expected to shell out to it and degrade gracefully if it's
  missing/unbuilt.
- **`.devcontainer/`** holds the Debian devcontainer setup (Dockerfile +
  scripts) used to provide a consistent dev environment.
- **`docs/Tools/Claude/`** holds a shortcut/workflow cheat sheet
  (`Claude-cheat-sheet.md`) for the AI coding assistant itself: one row per
  shortcut linking to a full guide under an `Examples/` subfolder. New
  entries follow that same "one row + one guide file" pattern. `docs/`
  also has a `learning-plan/` with lesson files (`Lesson-N.md` /
  `Lesson-N.todo.md`).

## Conventions

- Bash modules in `lib-bash/` use include-guards of the form
  `[[ -n "${_NAME_LOADED:-}" ]] && return 0` / `_NAME_LOADED=1` to make
  sourcing idempotent — follow this pattern for any new module.
- `Taskfile.yml` is the top-level task runner entry point; task-specific
  files are split out and `include`d (e.g. `Taskfile.Shellspec.yml`) rather
  than kept in one large file.
