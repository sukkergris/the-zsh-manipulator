# Lesson 1 — Your First Red Test

Checklist for [Lesson-1.md](Lesson-1.md). Toggle boxes with `Alt+C`.

## Prerequisites

- [x] Install shellspec (`./scripts/install-shellspec.sh` or `brew install shellspec`)
- [x] Verify with `shellspec --version`

## Step 1 — Tell shellspec to use zsh

- [x] Create `.shellspec` at repo root containing `--shell zsh`
- [x] Run `shellspec --init` to scaffold `spec/`
- [x] Confirm `spec/spec_helper.sh` exists

## Step 2 — Write the thing under test

- [x] Create `koll.zsh` at the project root
- [x] Define `greet()` that echoes `Hello, $1!`

## Step 3 — Write the spec

- [x] Create `spec/greet_spec.sh`
- [x] Wrap the case in `Describe` / `It`
- [x] `Include` `koll.zsh` so the function is callable
- [x] Assert with `When call greet "World"` + `The output should equal ...`

## Step 4 — Run it

- [x] Run `shellspec` and see it pass
- [x] Deliberately break the assertion to see a real failure
- [ ] Read the expected-vs-actual diff shellspec prints
- [ ] Fix the assertion back and confirm green

## What to carry forward

- [ ] Run a single file: `shellspec spec/greet_spec.sh`
- [ ] Try `shellspec --watch` for continuous feedback
- [ ] Adopt the rule: every new zsh function gets a spec _first_

## Open questions for next lesson

- [ ] zsh function anatomy: `$1`, `$@`, `local`, return codes
- [ ] Aliases vs. functions — when each is appropriate
- [ ] Study `koll.zsh` / `utils.zsh` in the kollzsh reference plugin
