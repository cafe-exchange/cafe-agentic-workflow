#!/usr/bin/env bash
# PreToolUse(Edit|Write|MultiEdit): protect secrets and framework/build files.
. "$(dirname "$0")/lib.sh"
F="$(jq -r '.tool_input.file_path // ""' <<<"$INPUT")"
dbg "file=$F"
base="$(basename "$F")"
case "$F" in */.git/*|*/.mvn/wrapper/maven-wrapper.jar) decide deny "Protected path: $F";; esac
case "$base" in
  .env|.env.*|*.pem|*.key|*.p12|*.jks|id_rsa*|credentials*|*secret*) decide deny "Sensitive file ($base): never edited by agents.";;
  pom.xml) decide ask "pom.xml change (dependencies/build): needs approval (gate G2).";;
  settings.json|settings.local.json) case "$F" in */.claude/*) decide ask "Changing Claude settings/hooks alters safety rails; confirm.";; esac;;
  application*.yaml|application*.yml|application*.properties) decide ask "Runtime config change: confirm no secrets and compatibility.";;
esac
case "$F" in */.claude/hooks/*) decide ask "Editing hook scripts alters safety rails; confirm.";; esac
exit 0
