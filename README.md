# the-manipulator

A learning project for building zsh plugins/extensions from scratch —
functions, aliases, hooks, completions, and eventually a compiled helper
binary — using `~/.oh-my-zsh/custom/plugins/kollzsh` as a reference example.

See [CLAUDE.md](CLAUDE.md) for how this project works with Claude Code
(teach-don't-implement mode, testing priorities).

## Tools

| Tool                                                | Role                                                                                                                          | Status                                                |
| --------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| [zsh](https://www.zsh.org/)                         | Target shell — the plugin runs in and extends zsh                                                                             | In use                                                |
| [Oh My Zsh](https://ohmyz.sh/)                      | Plugin manager/convention this project follows (`<name>.plugin.zsh` entry point, `custom/plugins/` layout)                    | In use                                                |
| [shellspec](https://github.com/shellspec/shellspec) | Test framework for the zsh code (`Describe`/`It`/`When` BDD-style specs)                                                      | Chosen — not yet installed (`brew install shellspec`) |
| [Zig](https://ziglang.org/)                         | Language for an eventual compiled helper binary the zsh layer shells out to (mirrors kollzsh's Rust binary, no Rust required) | Chosen — no code yet                                  |
| [Homebrew](https://brew.sh/)                        | Package manager used to install the above on macOS                                                                            | In use                                                |

## Reference Project

- `~/.oh-my-zsh/custom/plugins/kollzsh` — a working, more advanced example
  plugin (Rust + Python + zsh) studied for patterns, not copied directly.

## Status

Early setup — dev environment and conventions are being established before
any plugin functionality exists.
