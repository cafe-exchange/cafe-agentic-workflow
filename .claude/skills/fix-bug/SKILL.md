---
name: fix-bug
description: "Workflow B. Investigate, reproduce, root-cause, fix and regression-test a bug, producing an RCA. Use for defects and unexpected behavior in code."
argument-hint: "<bug description>"
disable-model-invocation: true
---

# fix-bug

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Fix the root cause, not the symptom, with proof.

## Activation conditions
User reports a bug, failing test, exception or wrong behavior.

## Required inputs
Bug report, stack trace, failing test, or reproduction steps.

## Execution workflow
1. Restate the bug; list what is known vs unknown.
2. Reproduce: write/run a failing test or command. If not reproducible, say so (**Not verified**) and continue with evidence from code.
3. Run `explore-codebase` on the failing path; list candidate root causes and gather evidence for each.
4. Select the root cause supported by evidence; if several remain, present to the human.
5. If the fix is significant (public API, schema, security, >3 modules): **gate G2**.
6. Delegate the fix to `backend-developer` (minimal change), regression test to `test-engineer` — the test must fail before and pass after when feasible.
7. Run `./mvnw -q test`; run `review-code` on the diff.
8. Write RCA (format in output-formats.md).

## Expected outputs
Fix, regression test, RCA report.

## Quality criteria
Root cause evidenced; regression test present; no unrelated changes; before/after results actually observed.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing. If unreproducible after reasonable effort, report that and propose instrumentation instead of speculative fixes.

## Safety constraints
No commit/push. Do not change tests to hide the bug. Production data/systems are never touched.
