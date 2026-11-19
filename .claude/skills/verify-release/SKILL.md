---
name: verify-release
description: "Workflow E. Verify release readiness: diff review, requirements coverage, build, tests, security, config and compatibility, then a release report and approval gate. Use before any release."
argument-hint: "<range or scope>"
disable-model-invocation: true
---

# verify-release

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Decide with evidence whether a change set is safe to release.

## Activation conditions
User asks 'is this ready to release/ship/merge to main'.

## Required inputs
Release scope (diff range, tag, or file list) and the requirements/plan it should satisfy.

## Execution workflow
1. Review the change set (git diff range, or explicit files if not a repo).
2. Map each requirement/acceptance criterion to code and test evidence; list gaps.
3. Run `./mvnw -q -DskipTests compile`, `./mvnw -q test`, `./mvnw -q verify` — record exact results. Integration tests run if they exist (note if none).
4. Check outstanding security findings (`security-audit` results) and config changes (`application*.yaml`, env vars, migrations).
5. Assess backward compatibility: public API, DB schema (expand/contract), message formats, config keys.
6. Write the Release Report (Final Report format + go/no-go recommendation).
7. **Stop at gate G4.** The framework never tags, publishes or deploys.

## Expected outputs
Release Report with recommendation: Go / No-go / Go with conditions.

## Quality criteria
Every checklist item labelled Verified / Not verified / Blocked; failing items cannot yield Go.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing.

## Safety constraints
No tag/publish/deploy/commit/push. Release itself is a human action after G4.
