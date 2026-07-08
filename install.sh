#!/usr/bin/env bash
# Install the resume-handoff skill for Claude Code and/or Codex (and any agent that
# reads ~/.agents/skills). Idempotent: re-running updates an existing install.
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/sduhantao-maker/resume-handoff/main/install.sh | bash
#
# Env overrides:
#   RESUME_HANDOFF_REPO   git URL to clone (default: the public repo)
#   RESUME_HANDOFF_HOME   where to keep the canonical clone (default: ~/.local/share/resume-handoff)
set -euo pipefail

NAME=resume-handoff
REPO_URL="${RESUME_HANDOFF_REPO:-https://github.com/sduhantao-maker/resume-handoff.git}"
CLONE_DIR="${RESUME_HANDOFF_HOME:-${XDG_DATA_HOME:-$HOME/.local/share}/$NAME}"

command -v git >/dev/null 2>&1 || { echo "error: git is required" >&2; exit 1; }

# 1. Clone or update the canonical copy.
if [ -d "$CLONE_DIR/.git" ]; then
  echo "Updating $CLONE_DIR"
  git -C "$CLONE_DIR" pull --ff-only
else
  echo "Cloning $REPO_URL -> $CLONE_DIR"
  mkdir -p "$(dirname "$CLONE_DIR")"
  git clone --depth 1 "$REPO_URL" "$CLONE_DIR"
fi

# 2. Symlink into every agent skills dir whose runtime is present.
linked=0
for d in "$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.agents/skills"; do
  parent="$(dirname "$d")"
  [ -d "$parent" ] || continue          # runtime not installed → skip
  mkdir -p "$d"
  ln -sfn "$CLONE_DIR" "$d/$NAME"
  echo "  linked: $d/$NAME -> $CLONE_DIR"
  linked=$((linked + 1))
done

# 3. If no known runtime was found, default to Claude Code's location.
if [ "$linked" -eq 0 ]; then
  mkdir -p "$HOME/.claude/skills"
  ln -sfn "$CLONE_DIR" "$HOME/.claude/skills/$NAME"
  echo "  linked: $HOME/.claude/skills/$NAME -> $CLONE_DIR"
fi

echo
echo "✅ $NAME installed. Restart your agent (or reload skills) to pick it up."
echo "   Optional, Claude Code only: enable the PreCompact auto-nudge — see README."
