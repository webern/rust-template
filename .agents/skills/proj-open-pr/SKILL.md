---
name: proj-open-pr
description: >
  Use this skill when the user says open a PR, create a pull request, make a PR, or submit this
  work as a PR.
argument-hint: "<prompt>"
disable-model-invocation: false
user-invocable: true
---
# /proj-open-pr

Use `<prompt>` and your context to understand what the PR is about. `AGENTS.md` describes the
repository layout and the build; read it if you have not already.

Use `gh` for GitHub interactions, always with `--repo webern/proj`, and always run local git as
`git -C <path>`.

Search the open issues for ones that this PR would close or is related to. Make a list of issues it
closes and related issues. It might also be related to other PRs.

## Before opening

`make ci` must exit 0. If the change touches the Makefile, `scripts/`, CI or the release workflow,
check it against the `/proj-build-doctrine` skill.

## Writing it

The title is lowercase and starts with one keyword, e.g.

- build: pin the typos action
- chore: clean up stale code comments
- docs: add a design doc for the parser
- feat: read the header chunk
- fix: reject lengths past the end of the file

Look at the labels on GitHub and choose the ones that fit best.

Keep the body tight and human-readable, with enough information to understand what was done and
why. Go easy on bold, italics and backticked keywords.

Determine from the original prompt whether the user wanted you to open it directly or wanted to see
a draft first. When in doubt, show the draft.

No self-attribution anywhere in the PR: no mention of AI, no co-author trailers, no robot emoji.

Template:

```markdown
## Human Summary

TODO: human writes here

## Summary

What changed and why, in a paragraph or two.

## Testing

- [x] `make ci`: exit 0
- [x] whatever else was run

## References

- Closes #123
- Progresses #456
```

`Closes` and `Fixes` are special: use them only when the issue can really be closed.

Formatting note: hard-wrapped markdown does not render correctly in GitHub comments and PR
descriptions, so do not wrap the body.
