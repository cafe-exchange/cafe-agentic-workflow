#!/usr/bin/env bash
# Validates the agentic framework: settings, hooks, agents, skills, cross-references.
# Usage: .claude/validate.sh   (exit 0 = all checks passed)
cd "$(dirname "$0")/.." || exit 1
fail=0; ok=0
pass() { ok=$((ok+1)); }
bad()  { fail=$((fail+1)); echo "FAIL: $*"; }

command -v jq >/dev/null || { echo "jq required"; exit 2; }
python3 -c 'import yaml' 2>/dev/null || { echo "python3 + PyYAML required for frontmatter checks"; exit 2; }

# 1. settings.json
jq empty .claude/settings.json 2>/dev/null && pass || bad "settings.json is not valid JSON"
for cmd in $(jq -r '.. | objects | select(.command?) | .command' .claude/settings.json | sed 's/^"\$CLAUDE_PROJECT_DIR"//; s/"//g'); do
  [ -x ".${cmd#.}" ] || [ -x "${cmd#/}" ] && pass || bad "hook script missing or not executable: $cmd"
done
for f in .claude/hooks/*.sh; do bash -n "$f" 2>/dev/null && pass || bad "syntax error: $f"; done

# 2. frontmatter parse helper (prints key=value lines; exits 1 on invalid YAML)
fm() { python3 - "$1" <<'PY'
import sys, yaml
t = open(sys.argv[1]).read()
if not t.startswith('---\n'): sys.exit(1)
d = yaml.safe_load(t.split('---\n', 2)[1])
for k, v in d.items(): print(f"{k}={v}")
PY
}

# 3. agents
REQ_AGENTS="architect product-analyst planner backend-developer test-engineer code-reviewer security-reviewer performance-engineer documentation-writer"
READONLY="architect product-analyst planner code-reviewer security-reviewer performance-engineer"
for a in $REQ_AGENTS; do
  f=".claude/agents/$a.md"
  [ -f "$f" ] || { bad "missing agent $a"; continue; }
  meta="$(fm "$f")" || { bad "$f: invalid frontmatter"; continue; }
  grep -q "^name=$a$" <<<"$meta" && pass || bad "$f: name must be '$a'"
  grep -q '^description=.\{20,\}' <<<"$meta" && pass || bad "$f: description missing/short"
  grep -q '^tools=' <<<"$meta" && pass || bad "$f: tools missing"
  for sec in "## Responsibilities" "## Execution rules" "## Expected output" "## Constraints"; do grep -q "^$sec" "$f" && pass || bad "$f: missing section $sec"; done
  case " $READONLY " in *" $a "*)
    grep '^tools=' <<<"$meta" | grep -Eq '(^|[ ,=])(Edit|Write|MultiEdit|NotebookEdit)([ ,]|$)' && bad "$f: read-only agent has write tools" || pass
    grep '^tools=' <<<"$meta" | grep -Eq 'Bash\((rm|mv|cp|git (commit|push|reset))' && bad "$f: unsafe Bash grant" || pass;;
  esac
done

# 4. skills
REQ_SKILLS="analyze-requirements explore-codebase design-architecture create-implementation-plan implement-feature fix-bug refactor-code generate-tests review-code security-audit performance-audit debug-production-issue update-documentation prepare-pull-request verify-release"
for s in $REQ_SKILLS; do
  f=".claude/skills/$s/SKILL.md"
  [ -f "$f" ] || { bad "missing skill $s"; continue; }
  meta="$(fm "$f")" || { bad "$f: invalid frontmatter"; continue; }
  grep -q "^name=$s$" <<<"$meta" && pass || bad "$f: name must be '$s'"
  grep -q '^description=.\{40,\}' <<<"$meta" && pass || bad "$f: description missing/short"
  for sec in "## Purpose" "## Activation conditions" "## Required inputs" "## Execution workflow" "## Expected outputs" "## Quality criteria" "## Error handling" "## Safety constraints"; do
    grep -q "^$sec" "$f" && pass || bad "$f: missing section $sec"
  done
done

# 5. cross-references: every docs/... path mentioned in framework files exists; every agent named in skills exists
refs="$(grep -rhoE 'docs/[A-Za-z0-9_./-]+\.(md|json)' CLAUDE.md .claude/agents .claude/skills docs/agentic 2>/dev/null | sort -u)"
for r in $refs; do
  case "$r" in *'<'*|docs/pr/*|docs/adr/*) continue;; esac
  [ -f "$r" ] && pass || bad "broken reference: $r"
done
for a in $(grep -rhoE '`(architect|product-analyst|planner|backend-developer|test-engineer|code-reviewer|security-reviewer|performance-engineer|documentation-writer)`' .claude/skills | tr -d '`' | sort -u); do
  [ -f ".claude/agents/$a.md" ] && pass || bad "skill references unknown agent $a"
done

# 6. hooks behavior
.claude/hooks/test-hooks.sh >/dev/null 2>&1 && pass || bad "hook self-test failed (run .claude/hooks/test-hooks.sh)"

# 7. no secrets committed in framework files
grep -rEq '(AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY|ghp_[A-Za-z0-9]{30,})' .claude docs CLAUDE.md 2>/dev/null && bad "possible secret in framework files" || pass

echo "framework validation: ok=$ok fail=$fail"
[ "$fail" -eq 0 ]
