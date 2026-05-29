#!/usr/bin/env bash
#
# Build the published site from the blog's Markdown source.
#
# blog/README.md is the single source of truth. This script renders it to the
# repository's root index.html, which is what GitHub Pages serves at
# ghpagesblog.click. Re-run after editing README.md.
#
# Usage: ./build.sh
set -euo pipefail

# Resolve this script's directory so the build works from any CWD.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$SCRIPT_DIR"

# Repository root (one level up from blog/), where the published site lives.
REPO_ROOT="$(cd -- ".." >/dev/null 2>&1 && pwd)"

SRC="README.md"
OUT="$REPO_ROOT/index.html"
TEMPLATE="template.html"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Error: pandoc is required but was not found on PATH." >&2
  echo "Install it from https://pandoc.org/installing.html (e.g. 'brew install pandoc')." >&2
  exit 1
fi

for f in "$SRC" "$TEMPLATE"; do
  if [[ ! -f "$f" ]]; then
    echo "Error: required file '$f' not found in $SCRIPT_DIR." >&2
    exit 1
  fi
done

# Derive the page title and description from the Markdown so metadata stays in
# sync with the source. Title = first level-1 heading; description = first
# non-empty paragraph.
TITLE="$(grep -m1 '^# ' "$SRC" | sed 's/^# *//')"
TITLE="${TITLE:-Blog}"

DESCRIPTION="$(awk '
  /^#/        { next }                 # skip headings
  /^!\[/      { next }                 # skip images
  /^[[:space:]]*$/ { if (started) exit; next }
  { started = 1; printf "%s ", $0 }
' "$SRC" | sed 's/[[:space:]]*$//')"

echo "Building $OUT from blog/$SRC ..."
pandoc "$SRC" \
  --from gfm \
  --to html5 \
  --standalone \
  --template "$TEMPLATE" \
  --metadata "pagetitle=$TITLE" \
  --metadata "description=$DESCRIPTION" \
  --metadata "lang=en" \
  --output "$OUT"

# The Markdown references images relative to blog/ (images/media/...), but the
# generated page lives at the repository root, so rewrite those paths to point
# under blog/ where the image files actually live.
sed 's|src="images/media/|src="blog/images/media/|g' "$OUT" > "$OUT.tmp" && mv "$OUT.tmp" "$OUT"

echo "Wrote $OUT"
