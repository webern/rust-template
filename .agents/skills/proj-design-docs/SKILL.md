---
name: proj-design-docs
description: >
  Read this skill before writing or editing anything in docs/design/, when the user asks about the
  design or architecture, when a change moves things around in the repo, or when you are trying to
  understand how proj is put together. It says which docs are yours to maintain and which are not.
argument-hint: "<prompt>"
disable-model-invocation: false
user-invocable: true
---
# /proj-design-docs

Design docs live in `docs/design/`. `proj.*` docs cover the codebase as a whole; other docs cover a
subsystem or a single change.

## The doc types

The suffix says who owns a doc and what it is for: `{{topic}}.{{type}}.md`.

### Desired (`*.desired.md`)

Human-authored. The vision and the intended design: a desired future state that the code may not
match yet. These are not yours. When a human vaguely asks you to update one, they want surgical
help: a wrong or missing word, grammar, spelling. Preserve the author's voice. Do not turn one into
a typical LLM-authored doc, and never rewrite one to match the code.

### As-built (`*.asbuilt.md`)

Machine-authored and maintained. A stateless description of the code as it is, whether or not that
is desirable. Your job is to keep them from lying about the repo. They are not history: git records
how we got here, so do not describe how things used to be or the decisions behind them.

Each starts with YAML frontmatter:

- `updated`: `YYYY-MM-DD`, set to today whenever you edit the doc.
- `subsystems`: the canonical names of what the doc describes.
- `max_size_bytes`: a hard limit on the doc's length. Do not raise it without human authorization;
  every edit must keep the doc under it. LLMs grow documents without bound and this keeps you
  honest: decide what matters and omit the rest.

Write for a human first. A high-level mental model comes before any detail; define terms before
using them; show directory structure the way `tree` does; make relationships explicit in words
(inherits, composes, calls) rather than by arrow shape alone. Mermaid and visual aids are welcome.
Give repo-relative paths.

### Topic docs (`{{topic}}.md`)

A design for one change or one decision: a plan, a proposal, a post-mortem. Either party may write
one. The first line after the title is `Status: DRAFT`, `APPROVED`, `IMPLEMENTED` or
`SUPERSEDED by <doc>`, then what the doc is, how it was produced, and what it binds. Number the
sections so other docs and PRs can cite them. Once the state is `IMPLEMENTED` or `SUPERSEDED`, they
should no longer be updated (that's what `asbuilt` docs are for).

## Tension between desired and as-built

They are expected not to match. When changing the system keep the desired design in mind and do not
widen the gap. When the gap closes, the as-built doc records it and the desired doc stays as the
human wrote it. If a desired doc has become wrong or obsolete, say so to the human instead of
editing it.
