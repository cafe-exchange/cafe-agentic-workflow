#!/usr/bin/env bash
# Stop: non-blocking reminder if Java sources are newer than the last compile. Never blocks (avoids Stop loops).
. "$(dirname "$0")/lib.sh"
[ "$(jq -r '.stop_hook_active // false' <<<"$INPUT")" = "true" ] && exit 0
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
if [ -d src ]; then
  if [ ! -d target/classes ] || [ -n "$(find src -name '*.java' -newer target/classes -print -quit 2>/dev/null)" ]; then
    jq -n '{systemMessage:"Java sources changed since last compile/test. Status of build/tests is NOT verified until ./mvnw -q test is run."}'
    dbg "stale build reminder"
  fi
fi
exit 0
