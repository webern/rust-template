# The build entry points. The /proj-build-doctrine skill governs this file:
# target names are a verb then a scope, the bare verb does everything, help
# lists build, test, check, clean in that order, and set targets come first.

.DEFAULT_GOAL := help

SCRIPTS := scripts

# Flags for every cargo call. `ci` adds --locked so a stale Cargo.lock fails
# there instead of being rewritten.
CARGO_FLAGS ?=

.PHONY: help \
        build build-release \
        test \
        check check-clippy check-doc check-fmt check-publish check-typos \
        clean \
        ci \
        fix fix-clippy fix-fmt \
        preflight

help:
	@echo "build          build the library and binary with the debug profile"
	@echo "build-release  build with the release profile"
	@echo "test           run every test, doctests included"
	@echo "check          run every check that gates CI: fmt, clippy, doc, typos"
	@echo "check-clippy   clippy with warnings denied, tests included"
	@echo "check-doc      build the docs with warnings denied"
	@echo "check-fmt      rustfmt in check mode"
	@echo "check-publish  cargo publish --dry-run; slow, so not part of check"
	@echo "check-typos    spell check the tree"
	@echo "clean          remove everything make created"
	@echo "ci             what CI runs: preflight, check, build, test, with --locked"
	@echo "fix            apply every automatic fix: fmt, clippy"
	@echo "fix-clippy     apply clippy's suggested fixes"
	@echo "fix-fmt        rustfmt in place"
	@echo "preflight      report what must be installed by hand before a build can succeed"

# ---------------------------------------------------------------------------
# build

build: preflight
	cargo build $(CARGO_FLAGS) --all-features

build-release: preflight
	cargo build $(CARGO_FLAGS) --all-features --release

# ---------------------------------------------------------------------------
# test

test: preflight
	cargo test $(CARGO_FLAGS) --all-features

# ---------------------------------------------------------------------------
# check

check: check-fmt check-clippy check-doc check-typos

check-clippy: preflight
	cargo clippy $(CARGO_FLAGS) --all-features --all-targets -- -D warnings

# rustdoc has warnings of its own, broken links say, that clippy never sees.
check-doc: preflight
	RUSTDOCFLAGS="-D warnings" cargo doc $(CARGO_FLAGS) --all-features --no-deps

check-fmt: preflight
	cargo fmt -- --check

# Builds from the packaged crate, which catches a file that `exclude` dropped
# but the build needs. Too slow for `check`; the release workflow runs it.
check-publish: preflight
	cargo publish $(CARGO_FLAGS) --dry-run --all-features

check-typos: preflight
	typos

# ---------------------------------------------------------------------------
# clean

clean:
	cargo clean

# ---------------------------------------------------------------------------
# ci, fix, preflight

# A target-specific variable reaches the prerequisites, so every cargo call
# under ci is --locked.
ci: CARGO_FLAGS += --locked
ci: preflight check build test

fix: fix-fmt fix-clippy

fix-clippy: preflight
	cargo clippy $(CARGO_FLAGS) --all-features --all-targets --fix --allow-dirty --allow-staged

fix-fmt: preflight
	cargo fmt

preflight:
	@$(SCRIPTS)/preflight.sh
