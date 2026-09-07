# Devcontainer Dockerfile — package notes

Why specific `apt-get install` packages are in
[`.devcontainer/debian/Dockerfile.debian`](../../../.devcontainer/debian/Dockerfile.debian),
for entries that aren't obvious from the package name alone. Not a full
manifest — just the ones worth explaining.

|Package|Why it's here|
|---|---|
|`shellcheck`|Static analysis for the `lib-bash/` bash modules (which already carry `# shellcheck disable=...` / `# shellcheck source=...` directives) and for `spec/` shell files. Backs the `timonwong.shellcheck` VS Code extension (see `devcontainer.json`), which lints those files inline as you edit — there's no separate `task` target that invokes it directly yet.|

## Adding a new entry

Add a row when a package's purpose isn't self-evident from its name, or
when you had to go dig to figure out why it was added — that's a sign a
future reader (including future you) will need the same explanation.
