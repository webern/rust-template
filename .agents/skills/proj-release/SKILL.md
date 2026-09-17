---
name: proj-release
description: >
  Use this skill when the user says release, cut a release, publish a version, or bump the version,
  when asked how releases work, or when doing the one-time release setup for a new repository.
argument-hint: "<prompt>"
disable-model-invocation: false
user-invocable: true
---
# /proj-release

Releases are cut by `.github/workflows/release.yml`, run by hand from `main`. It takes the version
and the commit, checks everything that could be wrong in a read-only job, builds an archive per
target, and only then tags, creates the GitHub release with the archives and checksums, and
publishes to crates.io.

## One-time setup for a new repository

The workflow fails without both.

1. A `release` environment in the repository. Settings > Environments > New environment, named
   `release`; or `gh api --method PUT repos/webern/proj/environments/release`. Add a required
   reviewer if releases should wait for a click.
2. Trusted publishing on crates.io, so the workflow needs no stored token. On the crate's
   Settings page, under Trusted Publishing, add a GitHub publisher: owner `webern`, repository
   `proj`, workflow `release.yml`, environment `release`. The crate has to exist before this can
   be configured, so the very first version is published by hand with `cargo publish`.

## Cutting a release

1. `main` is green and contains everything the release should.
2. Bump `version` in `Cargo.toml` and run `cargo build` so `Cargo.lock` follows. Commit that alone
   as `chore: bump to X.Y.Z` and merge it through a PR (`/proj-open-pr`).
3. Take the SHA: `git -C <path> fetch origin && git -C <path> rev-parse origin/main`.
4. Run the workflow and watch it:

   ```sh
   gh workflow run release.yml --repo webern/proj --ref main -f version=X.Y.Z -f sha=<sha>
   gh run watch --repo webern/proj
   ```

5. Confirm the tag `vX.Y.Z`, the GitHub release with its archives and checksums, and the crates.io
   page.

A version with a suffix, `1.2.3-rc1`, is published as a prerelease.

## What the workflow checks

Semver-shaped version; run from `main`; the SHA is an ancestor of `main`; the version equals
`Cargo.toml`; the tag does not exist; crates.io does not have the version; `make ci` passes;
`make check-publish` passes. The crate and binary names are read from `Cargo.toml`, so nothing in
the workflow is project-specific.

## Adjusting it

- No binary: delete the `build` job, and in `publish` the download and checksum steps and the
  `dist/*` argument to `gh release create`.
- Not on crates.io: delete the "Validate version not already published", "Check the crate
  packages", "Authenticate with crates.io" and "Publish to crates.io" steps, and the Makefile's
  `check-publish` target. The trusted publishing setup no longer applies.
- More targets: add a row to the `build` matrix. Every row builds natively on its runner.
