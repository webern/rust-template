# proj

TODO: one paragraph on what this project is and who it is for.

## Repository layout

<!-- keep this up-to-date and relevant -->

```
proj/
  AGENTS.md            <- you are here
  Makefile             <- every build, test and check; `make help` lists the targets
  src/lib.rs           <- the library; all the logic
  src/main.rs          <- the binary; a thin wrapper over the library
  scripts/             <- build, lint and utility scripts
  docs/design/         <- design docs; the /proj-design-docs skill says who owns which
  .agents/skills/      <- agent skills, the source of truth; every name starts with proj-
  .claude/skills       <- symlink to .agents/skills
```

## Build

`make help` lists the targets. `make ci` is the gate CI runs: preflight, check, build, test.
`make preflight` reports what must be installed by hand. The `/proj-build-doctrine` skill governs
the Makefile, `scripts/`, CI and dependencies; read it before changing any of them.

## Skills

- `/proj-build-doctrine`: the build system, Makefile, scripts, CI, dependencies.
- `/proj-design-docs`: the docs in `docs/design/` and who owns which.
- `/proj-open-pr`: opening a pull request.

## Rules

- Run git as `git -C <path>` and gh with `--repo webern/proj`.
- Commits, PRs, issues and comments carry no AI attribution. Human writing and AI writing must be
  visually distinct from one another (see `/proj-open-pr` for an example).
- `docs/design/*.desired.md` are human-authored. Do not rewrite them.

## Initial setup

DELETE THIS SECTION when setup is complete.

You are in a fresh copy of a project template. Nothing is named yet: the crate name in `Cargo.toml`
is the placeholder, and it appears in file contents and file names throughout the tree. Do the
following in order and ask the user about anything you cannot decide.

1. Ask for the crate name if it was not given, then run `scripts/setup.sh <name>`. It replaces the
   placeholder everywhere, renames the skill directories and design docs, and stamps the license
   year.
2. If there is no `.git` directory, `git init -b main` now.
3. Fill in `description` in `Cargo.toml` and the first paragraph of `README.md` and of this file.
   Ask if you do not know what the project is for.
4. Settle the crate shape with the user. The template ships a library plus a binary, and a release
   that publishes to crates.io and attaches per-target binaries. Remove what does not apply; the
   `/proj-release` skill says what to delete for each simpler shape.
5. Run `make ci` and fix whatever fails. `make preflight` says what to install.
6. Write the first real code in `src/lib.rs` in place of the placeholder, then rewrite
   `docs/design/<name>.asbuilt.md` to match. Leave `<name>.desired.md` to the user.
7. Create the GitHub repository (`gh repo create webern/<name> --private --source . --push` or as
   the user prefers) and do the one-time release setup in the `/proj-release` skill.
8. Delete `scripts/setup.sh`, delete this section, commit.
