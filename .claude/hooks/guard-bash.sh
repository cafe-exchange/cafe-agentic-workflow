#!/usr/bin/env bash
# PreToolUse(Bash): block destructive commands, require approval for commit/push/deploy.
. "$(dirname "$0")/lib.sh"
CMD="$(jq -r '.tool_input.command // ""' <<<"$INPUT")"
dbg "cmd=$CMD"
shopt -s nocasematch
# Hard deny: destructive / irreversible
if [[ "$CMD" =~ (^|[\;\&\|[:space:]])rm[[:space:]]+(-[a-z]*[rf][a-z]*[[:space:]]+)+(/|~|\$HOME|\.\.?)([[:space:]]|/?$) ]]; then decide deny "Destructive rm on root/home/parent blocked."; fi
if [[ "$CMD" =~ git[[:space:]]+reset[[:space:]]+--hard ]]; then decide deny "git reset --hard discards work; ask the human to run it."; fi
if [[ "$CMD" =~ git[[:space:]]+clean[[:space:]]+-[a-z]*f ]]; then decide deny "git clean -f deletes untracked files; ask the human."; fi
if [[ "$CMD" =~ git[[:space:]]+push.*(--force|[[:space:]]-f([[:space:]]|$)) ]]; then decide deny "Force push blocked."; fi
if [[ "$CMD" =~ (drop[[:space:]]+(table|database|schema)|truncate[[:space:]]+table) ]]; then decide deny "Destructive SQL blocked (gate G5)."; fi
if [[ "$CMD" =~ (curl|wget)[^\|]*\|[[:space:]]*(sudo[[:space:]]+)?(ba)?sh ]]; then decide deny "Piping downloads into a shell is blocked."; fi
# Ask: outward-facing or history-changing
if [[ "$CMD" =~ git[[:space:]]+(commit|push|tag|merge|rebase) ]]; then decide ask "Git history/remote change needs explicit human approval."; fi
if [[ "$CMD" =~ (gh[[:space:]]+(pr|issue|release)[[:space:]]+(create|merge|edit|comment|close)|kubectl[[:space:]]+(apply|delete|rollout)|helm[[:space:]]+(install|upgrade)|docker[[:space:]]+push|terraform[[:space:]]+apply|mvn[a-z]*[[:space:]].*(deploy|release:)) ]]; then decide ask "External write / deploy (gate G3/G4/G5): confirm exact action."; fi
if [[ "$CMD" =~ (^|[[:space:]])(psql|mysql|redis-cli|kafka-[a-z-]+\.sh)([[:space:]]|$) ]]; then decide ask "Direct datastore/broker access: confirm target is NOT production and the statement is read-only."; fi
exit 0
