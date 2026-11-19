---
name: implement-feature
description: "Workflow A. End-to-end feature delivery from requirement to PR description, with a human approval gate after the plan. Use for new features or tickets."
argument-hint: "<requirement or ticket>"
disable-model-invocation: true
---

# implement-feature

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Deliver a reviewed, tested feature incrementally and safely.

## Activation conditions
User asks to build/add/implement a feature or provides a ticket.

## Required inputs
Requirement text or ticket.

## Execution workflow
1. **Plan phase** — run `analyze-requirements` → `explore-codebase` → `design-architecture` → `create-implementation-plan`. **Stop at G1.**
2. **Build phase** — for each task in order: delegate to `backend-developer`; then `test-engineer` (unit tests; integration tests where wiring/IO matters). Run `./mvnw -q -DskipTests compile` after each task and `./mvnw -q test` after test writing. Write agents run sequentially, never concurrently on the same files.
3. **Review phase** — run `review-code` (parallel read-only reviewers). Include performance review only if the change touches queries, hot paths, concurrency or I/O.
4. **Fix phase** — fix only *Confirmed* Critical/High findings (and Medium if cheap) via `backend-developer`/`test-engineer`; re-run tests; re-review changed files.
5. **Verify** — run `./mvnw -q verify`; capture exact results.
6. **Report** — Final Report; then `prepare-pull-request` for the PR description. Do not commit or push.

## Expected outputs
Code + tests, Final Report, PR description file `docs/pr/<slug>.md`.

## Quality criteria
All acceptance criteria mapped to tests; build and tests actually run and reported verbatim; review findings dispositioned; scope matches approved plan.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing. If a task fails twice, stop and report **Blocked** with evidence; don't paper over with test changes.

## Safety constraints
G1 required before writing code. No commit/push/deploy. Re-gate if scope grows. No secrets.
