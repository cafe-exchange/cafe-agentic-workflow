#!/usr/bin/env bash
# PostToolUse(Edit|Write|MultiEdit): cheap syntax sanity check on the single edited file. No builds. Never edits files (no recursion).
. "$(dirname "$0")/lib.sh"
F="$(jq -r '.tool_input.file_path // ""' <<<"$INPUT")"
[ -f "$F" ] || exit 0
msg=""
case "$F" in
  *.json) jq empty "$F" >/dev/null 2>&1 || msg="Invalid JSON in $F";;
  *.yaml|*.yml) python3 -c 'import sys,yaml;yaml.safe_load(open(sys.argv[1]))' "$F" 2>/dev/null || { python3 -c 'import yaml' 2>/dev/null && msg="Invalid YAML in $F"; };;
  pom.xml|*.xml) command -v xmllint >/dev/null && { xmllint --noout "$F" >/dev/null 2>&1 || msg="Malformed XML in $F"; };;
  *.java)
    o=$(tr -cd '{' <"$F" | wc -c); c=$(tr -cd '}' <"$F" | wc -c)
    [ "$o" -ne "$c" ] && msg="Unbalanced braces in $F ({=$o, }=$c)"
    if grep -q $'\t' "$F"; then msg="${msg:+$msg; }Tab characters in $F (project uses spaces)"; fi
    ;;
  *.sh) bash -n "$F" >/dev/null 2>&1 || msg="Shell syntax error in $F";;
esac
if [ -n "$msg" ]; then
  jq -n --arg m "$msg" '{hookSpecificOutput:{hookEventName:"PostToolUse",additionalContext:$m}}'
  dbg "problem: $msg"
fi
exit 0
