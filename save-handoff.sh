#!/usr/bin/env bash
# Save a handoff doc to the project root as HANDOFF.md and archive a timestamped
# copy to ~/.claude/handoffs/ so a fresh agent can find it later.
#
# Usage:
#   save-handoff.sh path/to/draft.md      # read content from a file
#   some-command | save-handoff.sh -      # read content from stdin
#   save-handoff.sh -                     # read content from stdin
set -euo pipefail

ARCHIVE_DIR="$HOME/.claude/handoffs"
mkdir -p "$ARCHIVE_DIR"

# --- read content -----------------------------------------------------------
src="${1:-}"
if [ -z "$src" ] || [ "$src" = "-" ]; then
  content="$(cat)"
elif [ -f "$src" ]; then
  content="$(cat "$src")"
else
  echo "error: no such file: $src" >&2
  exit 1
fi

if [ -z "${content//[$'\t\r\n ']/}" ]; then
  echo "error: handoff content is empty; nothing saved" >&2
  exit 1
fi

# --- resolve project root ---------------------------------------------------
# Prefer the git top-level; fall back to CWD. Never treat $HOME as a project.
root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
if [ -z "$root" ]; then
  root="$PWD"
fi

# --- write project copy (unless we'd clutter $HOME) -------------------------
dest=""
if [ "$root" = "$HOME" ]; then
  echo "note: working dir is \$HOME — skipping project HANDOFF.md, archiving only." >&2
else
  dest="$root/HANDOFF.md"
  printf '%s\n' "$content" > "$dest"
fi

# --- write timestamped archive ----------------------------------------------
slug="$(basename "$root" | tr ' /:' '___')"
ts="$(date +%Y%m%d-%H%M%S)"
archive="$ARCHIVE_DIR/${slug}-${ts}-${RANDOM}.md"
printf '%s\n' "$content" > "$archive"

# --- report -----------------------------------------------------------------
echo "Handoff saved to:"
[ -n "$dest" ] && echo "  project : $dest"
echo "  archive : $archive"
