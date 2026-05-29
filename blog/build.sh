#!/usr/bin/env bash
#
# Build the blog HTML from its Markdown source.
#
# The Markdown file (README.md) is the single source of truth; this script
# regenerates index.html from it. Re-run after editing README.md.
#
# Usage: ./build.sh
set -euo pipefail

# Resolve this script's directory so the build works from any CWD.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$SCRIPT_DIR"

SRC="README.md"
OUT="index.html"
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

echo "Building $OUT from $SRC ..."
pandoc "$SRC" \
  --from gfm \
  --to html5 \
  --standalone \
  --template "$TEMPLATE" \
  --metadata "pagetitle=$TITLE" \
  --metadata "description=$DESCRIPTION" \
  --metadata "lang=en" \
  --output "$OUT"

echo "Wrote $SCRIPT_DIR/$OUT"
