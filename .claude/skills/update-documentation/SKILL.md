---
name: update-documentation
description: "Update README, API docs, ADRs and implementation summaries to match the code. Use after features/fixes or when docs are stale."
argument-hint: "<what changed>"
---

# update-documentation

Shared contracts: `docs/agentic/contracts/output-formats.md`, `docs/agentic/contracts/approval-gates.md`. Java-stack rules (`docs/agentic/contracts/java-stack.md`) only where the technology is present. Input: $ARGUMENTS

## Purpose
Keep documentation accurate and non-duplicative.

## Activation conditions
After code changes; explicit docs request; stale docs found in review.

## Required inputs
Changed files or a documentation target.

## Execution workflow
1. Identify what changed (file list or git diff).
2. Delegate to `documentation-writer` with the changes and existing doc locations.
3. Verify every statement against source; remove claims that cannot be verified.
4. Prefer linking to existing docs over duplicating.

## Expected outputs
Updated Markdown files + change summary.

## Quality criteria
Accurate vs code; concise; no copy-pasted duplication; examples compile conceptually against actual APIs.

## Error handling
On any failed command, show the real error, do not retry blindly more than once, and report status as **Blocked** with what is missing.

## Safety constraints
Writes only `docs/**` and `*.md`; never source or config.
