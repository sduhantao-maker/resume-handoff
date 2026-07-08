---
name: resume-handoff
description: Use when work won't finish before the quota or context runs out and must be paused and handed off — triggers include 额度快用完, 额度用完前干不完, 续命, 交接, 生成交接文档, handoff, context running low, 上下文快满, pausing mid-task, or another agent must pick up and continue unfinished work and recover context.
---

# Resume Handoff

## Overview

When work spans more of a session than can safely finish, keep a **handoff document** that lets a fresh agent (with zero memory of this conversation) get oriented in minutes and continue from exactly where you stopped.

**Two core principles:**
1. **Write for a stranger.** The next agent knows nothing. If it isn't in the file (or linked from it), it doesn't exist.
2. **Checkpoint as you go — never gamble on the last moment.** See below.

## Why checkpoint, not wait (the honest limitation)

You **cannot** reliably know when the session is about to end:

- **Quota / rate limit:** you receive *no* signal at all. Only the user sees remaining usage in the UI. You cannot self-detect "about to run out."
- **Context window:** semi-observable — the harness auto-compacts when it fills, but you have no exact token count.
- **Hard cutoff mid-turn:** you get no chance to act — no last-second save is possible.

So a design that waits until "I judge I'm about to run out" is unreliable by construction. The fix is to **make `HANDOFF.md` a living document, refreshed at milestones**, so that whenever the session ends, a recent checkpoint (at most one step stale) already exists on disk. Handoff becomes a heartbeat, not a deathbed event.

**Refresh the handoff when:**
- A sub-task completes, or you're **about to start a long/risky step** (write the checkpoint *before* it, not after).
- The user says 交接 / 续命 / handoff / 生成交接文档 / 快没额度了.
- You get a **PreCompact / just-compacted reminder** (context is filling — save now).
- You've done substantial work since the last refresh and none is captured yet.

Re-running is cheap and idempotent — it just overwrites `HANDOFF.md`. When in doubt, refresh. Do **not** use for finished work (just report results) or trivial one-step tasks.

## Procedure

Run this the first time you checkpoint, then re-run the relevant steps on each refresh (it overwrites `HANDOFF.md` in place).

1. **Gather state** — objective, what's done, what's left, key files, decisions, gotchas, next steps. Reconstruct from the actual conversation, not a guess.
2. **Fill the template** — use [template.md](template.md). Keep every section; write "N/A" if truly empty rather than deleting it.
3. **Reference, don't duplicate** — link plans/PRDs/ADRs/diffs/issues/memory files by path or URL instead of pasting them.
4. **Redact secrets** — no API keys, passwords, tokens, or PII in the file.
5. **Save to two places** — run the helper so the doc lands both where the next agent will look and in a timestamped archive:
   ```bash
   # run save-handoff.sh from this skill's own directory
   # (the skill loader prints its base dir; default install: ~/.claude/skills/resume-handoff/)
   ./save-handoff.sh /path/to/drafted-handoff.md
   ```
   It writes `HANDOFF.md` at the project root and archives a timestamped copy to your agent's handoffs dir (`~/.claude/handoffs/` on Claude Code, `~/.codex/handoffs/` on Codex; auto-detected). It refuses to clutter `$HOME`: if the working dir is your home directory, it archives only and tells you.
6. **Tell the user** where it saved and the one-line command the next agent should start with (see the template's first section).

## What makes a handoff the next agent can actually use

| Include | Why |
|---|---|
| One-line objective + how to resume | Orientation in 10 seconds |
| Status split into done / in-progress / not-started | Next agent doesn't redo or skip |
| Exact file paths (with `:line`) + run/test/build commands | No re-discovery of the environment |
| Decisions **with reasons** | Next agent won't reverse them blindly |
| Dead ends already tried | Stops repeating your mistakes |
| Ordered, concrete next steps | Continue, don't re-plan |
| Suggested skills + your runtime's memory entry points | Recover the "muscle memory" fast |

## Common mistakes

- **Writing to OS temp** — gets wiped; the next agent can't find it. Save to the project + archive.
- **Vague next steps** ("continue the refactor") — give the actual next file and change.
- **Summarizing the vibe instead of the state** — paths, commands, and decisions beat prose.
- **Deleting empty sections** — the next agent won't know if "no blockers" means none or forgotten. Write "N/A".
- **Waiting until it's too late** — offer the handoff while budget remains, not at 0.

## Platform notes

Runs on any skill-aware agent — the `SKILL.md` format is shared. Only a few bits are runtime-specific:

- **Install path** — Claude Code: `~/.claude/skills/resume-handoff/`; Codex / cross-runtime: `~/.codex/skills/` or `~/.agents/skills/`.
- **Handoffs archive** — `save-handoff.sh` auto-picks `~/.claude/handoffs/` or `~/.codex/handoffs/` (override with `RESUME_HANDOFF_ARCHIVE_DIR`).
- **Auto-nudge before compaction** — the optional `PreCompact` hook (`precompact-hook.sh`) is **Claude Code-specific**. On Codex or elsewhere, rely on the manual + milestone triggers (the primary path anyway).
- **Memory entry points** — point the next agent at your runtime's memory: Claude Code auto-memory / `mem-search`; Codex `AGENTS.md`.
