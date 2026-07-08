# resume-handoff

A skill for agentic coding assistants (Claude Code, Codex, and other skill-aware agents) that writes a **handoff document** when work can't finish in one session — so a fresh agent, with zero memory of the conversation, can get oriented in minutes and continue from exactly where you stopped.

## Why

When a long task is interrupted — quota runs out, the context window fills, or you simply stop for the day — the next agent starts from nothing. `resume-handoff` captures the live state (goal, progress, key files, decisions, gotchas, next steps) into a `HANDOFF.md` that reads like an onboarding doc for a competent stranger.

### The core idea: checkpoint as you go, never gamble on the last moment

An agent **cannot** reliably detect when a session is about to end:

- **Quota / rate limits** emit *no* signal the model can see — only the human sees remaining usage.
- **Context window** fills silently; the harness auto-compacts with no exact token count.
- A **hard cutoff** mid-turn leaves no chance to save anything.

So instead of trying to "save at the last second," this skill treats `HANDOFF.md` as a **living document** refreshed at milestones (a sub-task finishes, or before a long/risky step). Whenever the session ends, a recent checkpoint — at most one step stale — already exists on disk. Handoff becomes a heartbeat, not a deathbed event.

## What's in here

| File | Purpose |
|---|---|
| `SKILL.md` | The skill itself: when to trigger, the procedure, what makes a usable handoff |
| `template.md` | The handoff document template (objective / status / files / env / decisions / gotchas / next steps / verification / blockers / memory entry points) |
| `save-handoff.sh` | Writes `HANDOFF.md` to the project root **and** a timestamped archive in `~/.claude/handoffs/`; refuses to clutter `$HOME` |
| `precompact-hook.sh` | Optional Claude Code `PreCompact` hook — nudges the agent to refresh the handoff right before context is compacted away |

## Install

### Quick install (Claude Code + Codex)

One command — clones the repo and symlinks it into every agent skills dir it finds (`~/.claude/skills`, `~/.codex/skills`, `~/.agents/skills`):

```bash
curl -fsSL https://raw.githubusercontent.com/sduhantao-maker/resume-handoff/main/install.sh | bash
```

Re-run any time to update. Then restart your agent (or reload skills).

### Install by handing an agent the link

Paste this to Claude Code, Codex, or any shell-capable agent:

> Install this skill: https://github.com/sduhantao-maker/resume-handoff —
> run its `install.sh`, or `curl -fsSL https://raw.githubusercontent.com/sduhantao-maker/resume-handoff/main/install.sh | bash`

The agent clones the repo and links it into your skills directory.

### Manual

```bash
# Claude Code
git clone https://github.com/sduhantao-maker/resume-handoff.git ~/.claude/skills/resume-handoff
# Codex
git clone https://github.com/sduhantao-maker/resume-handoff.git ~/.codex/skills/resume-handoff
```

The skill is then discoverable by name (`resume-handoff`) on both runtimes.

### Optional: auto-nudge before context compaction (Claude Code)

Add a `PreCompact` hook so the agent is reminded to checkpoint right before detail is discarded. In `~/.claude/settings.json`:

```json
{
  "hooks": {
    "PreCompact": [
      { "hooks": [ {
        "type": "command",
        "command": "~/.claude/skills/resume-handoff/precompact-hook.sh",
        "timeout": 10
      } ] }
    ]
  }
}
```

This covers the *context* axis only — quota exhaustion stays invisible to any hook. Trigger a handoff manually (say "handoff" / "交接") when you see a usage warning.

## Usage

- Ask for a handoff explicitly: **"write a handoff"**, **"交接"**, **"续命"**, **"生成交接文档"**.
- Or let the agent offer one proactively when a task is unfinished and the context is getting long.

The result: `HANDOFF.md` at your project root (plus a timestamped copy under `~/.claude/handoffs/`). Point the next agent at that file and it can pick up.

## License

MIT — see [LICENSE](LICENSE).
