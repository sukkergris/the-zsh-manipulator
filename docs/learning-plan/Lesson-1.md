# Lesson 1 — Your First Red Test

## Goal

Get the core dev loop working end to end, once, by hand:

    write a test → run it → see it fail for the right reason → make it pass

Everything else in this project builds on top of this cycle (see
[CLAUDE.md](../../CLAUDE.md) → "Priority: The Development Loop"). No plugin
functionality matters yet — only that this loop is fast and trustworthy.

## Prerequisites

- shellspec installed (`./scripts/install-shellspec.sh`, or `brew install
  shellspec` directly). Verify with:

      shellspec --version

## Step 1 — Tell shellspec to use zsh

Shellspec is shell-agnostic and defaults to `sh`. Since this project's code
is zsh, pin the shell explicitly in a `.shellspec` config file at the repo
root:

  --shell zsh

Then scaffold the conventional layout:

  shellspec --init

This creates a `spec/` directory and `spec/spec_helper.sh` (a file sourced
before every spec — useful later for shared setup/teardown).

## Step 2 — Write the thing under test

Create `koll.zsh` at the project root:

    greet() {
      echo "Hello, $1!"
    }

This is deliberately trivial — the point of this lesson is the *loop*, not
the function.

## Step 3 — Write the spec

Create `spec/greet_spec.sh`:

    Describe 'greet'
      Include ../koll.zsh

      It 'greets the given name'
        When call greet "World"
        The output should equal "Hello, World!"
      End
    End

Notes on the syntax:

- `Describe` / `It` — group and name test cases; read like English on
  purpose (BDD style).
- `Include ../koll.zsh` — sources the file so its functions become callable
  from the spec. Path is relative to the *spec file's own directory*, hence
  `../`.
- `When call greet "World"` — calls the zsh function directly, in-process
  (fast — no subprocess). The alternative, `When run <cmd>`, invokes an
  actual script/binary as a subprocess — that's what we'll use later for a
  compiled Zig helper.
- `The output should equal "..."` — an assertion ("expectation"). Other
  common ones: `The status should be success`, `The stderr should ...`,
  `The variable X should ...`.

## Step 4 — Run it

  shellspec

Expect this to pass first try, since the spec matches the function exactly.
**Before moving on, deliberately break something** to see a real failure —
e.g. change the assertion to `The output should equal "Hi, World!"` and
re-run. Read the diff shellspec prints (expected vs. actual). This is the
signal you're learning to read for the rest of this project: a fast,
clear "no, and here's exactly why."

Then fix it back and confirm green again.

## What to carry forward

- `shellspec` (no args) runs the whole `spec/` suite; `shellspec
  spec/some_spec.sh` runs one file.
- `shellspec --watch` re-runs on file changes — worth switching to once
  this file's loop feels comfortable, for continuous feedback while
  editing.
- Every new zsh function from here on gets a spec *first*, per CLAUDE.md.

## Open questions for next lesson

- Anatomy of a zsh function in more depth (arguments, `$1`/`$@`, local
  vars, return codes) — using real examples from `koll.zsh` /
  `utils.zsh` in the kollzsh reference plugin.
- Aliases vs. functions — when each is appropriate.
