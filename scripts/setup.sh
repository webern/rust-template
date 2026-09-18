#!/usr/bin/env bash
# Turns the template into a project: replaces the placeholder name `proj`
# everywhere, renames the paths that carry it, and stamps the license year.
# Run once, from AGENTS.md's setup steps, then delete it.
#
# usage: scripts/setup.sh <name>
#   name is the crate and repository name: lowercase, digits, - or _

set -euo pipefail

name=${1:?usage: scripts/setup.sh <name>}

if ! [[ $name =~ ^[a-z][a-z0-9_-]*$ ]]; then
    echo "name must be lowercase letters, digits, - or _, starting with a letter: $name" >&2
    exit 1
fi

# The crate as Rust code refers to it; cargo maps - to _.
ident=${name//-/_}
year=$(date +%Y)

cd "$(dirname "$0")/.."

files() {
    find . -type f -not -path './.git/*' -not -path './target/*' -not -name setup.sh
}

# Code refers to the library by its identifier; everything else uses the name as typed.
perl -pi -e "s/\bproj\b/$ident/g" src/main.rs
files | xargs perl -pi -e "s/\bproj\b/$name/g; s/\bYEAR\b/$year/g"

# Deepest first, so a directory is renamed after the files inside it.
find . -depth -name '*proj*' -not -path './.git/*' -not -path './target/*' | while read -r old; do
    mv "$old" "$(dirname "$old")/$(basename "$old" | sed "s/proj/$name/g")"
done

echo "renamed proj to $name; the rest of the setup steps are in AGENTS.md"
