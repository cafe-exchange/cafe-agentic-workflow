#!/usr/bin/env bash
# Shared helpers for hooks. Hooks read JSON on stdin. Requires jq (fails OPEN with a warning if missing).
# Debug: set CLAUDE_HOOK_DEBUG=1 to log to .claude/hooks/hook.log
command -v jq >/dev/null 2>&1 || { echo "hook: jq not found; guard skipped" >&2; exit 0; }
INPUT="$(cat)"
dbg() { [ "${CLAUDE_HOOK_DEBUG:-0}" = "1" ] && echo "$(date +%T) $(basename "$0"): $*" >> "$(dirname "$0")/hook.log"; return 0; }
# decide <allow|ask|deny> <reason>
decide() {
  jq -n --arg d "$1" --arg r "$2" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:$d,permissionDecisionReason:$r}}'
  dbg "$1: $2"; exit 0
}
