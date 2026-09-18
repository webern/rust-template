#!/usr/bin/env bash
# Reports every missing build prerequisite in one pass, with how to install it.
# Runs before every build, so it only checks that tools exist. rustup installs
# the toolchain and components rust-toolchain.toml names on first use.

# No -e: a missing tool must not stop the scan.
set -uo pipefail

missing=0

need() {
    local tool=$1 hint=$2
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "missing: $tool  ($hint)" >&2
        missing=1
    fi
}

need rustup "https://rustup.rs"
need cargo "installed by rustup"
need typos "cargo install typos-cli, or brew install typos-cli"

if [ "$missing" -ne 0 ]; then
    echo "install what is listed above, then run make again" >&2
    exit 1
fi
