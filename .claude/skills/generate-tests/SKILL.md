---
name: generate-tests
description: "Design and write unit and integration tests for code or a plan, find coverage gaps, and run them. Use when tests are missing or after implementation."
argument-hint: "<target>"
---

# generate-tests

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Prove behavior with fast, deterministic tests.

## Activation conditions
Untested code, new feature code, bug regression, or explicit test request.

## Required inputs
Target classes/methods or acceptance criteria.

## Execution workflow
1. Delegate to `test-engineer` with targets and criteria.
2. Require a test plan: scenarios, edge cases, failure paths; unit first, integration only where needed.
3. Run `./mvnw -q test -Dtest=<NewTests>` then the full `./mvnw -q test`.
4. Review flakiness risks (time, randomness, ordering, network).

## Expected outputs
New test files, exact commands, verbatim results, remaining gaps.

## Quality criteria
Each acceptance criterion covered; deterministic; no assertion-free tests; no weakened existing tests.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing. If production code blocks testability, report the needed change; don't edit production code from this skill.

## Safety constraints
Write only under `src/test/`.
