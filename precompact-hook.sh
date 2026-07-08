#!/usr/bin/env bash
# PreCompact hook for the resume-handoff skill.
# Fires right before the conversation is compacted (context filling up), i.e. right
# before detail gets discarded. Emits `additionalContext` — which carries across the
# compaction boundary — nudging the model to checkpoint the handoff while full detail
# is still available. Does NOT and cannot detect quota exhaustion (no such signal exists).
#
# Reads the hook payload on stdin (ignored); writes a JSON directive on stdout.
cat <<'JSON'
{"systemMessage":"resume-handoff: context is compacting — refresh HANDOFF.md if work is unfinished.","hookSpecificOutput":{"hookEventName":"PreCompact","additionalContext":"The conversation is being compacted because this session is long, so detail is about to be discarded. If there is unfinished multi-step work, invoke the resume-handoff skill NOW to write or refresh HANDOFF.md (saved to the project root and ~/.claude/handoffs/) so a fresh agent can continue from an up-to-date checkpoint. Skip only if the current task is already finished or trivial."}}
JSON
