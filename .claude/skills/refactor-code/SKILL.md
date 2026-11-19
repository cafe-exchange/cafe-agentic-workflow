---
name: refactor-code
description: "Restructure code without changing behavior, protected by tests. Use for cleanup, extraction, renaming or simplification requests."
argument-hint: "<target and goal>"
disable-model-invocation: true
---

# refactor-code

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Improve structure while proving behavior is unchanged.

## Activation conditions
User asks to refactor/clean up/simplify code.

## Required inputs
Target files/classes and the goal.

## Execution workflow
1. Confirm a behavior-preserving goal; if behavior must change, redirect to implement-feature.
2. Run existing tests for the area first (baseline). If coverage is missing, have `test-engineer` add characterization tests first.
3. Present a short refactor plan (G2 if it crosses >3 modules or alters public API); get approval.
4. Apply in small steps via `backend-developer`; compile + run tests after each step.
5. Run `code-reviewer` on the diff.

## Expected outputs
Refactored code, baseline vs final test results, summary.

## Quality criteria
Tests green before and after; no behavior or public-API change; smaller or clearer code, not just different.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing. If baseline is red, stop and report; don't refactor on red.

## Safety constraints
No behavior changes smuggled in. No commit/push.
